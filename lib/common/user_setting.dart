import 'package:fairyland/utils/file_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ini/ini.dart';

enum BookShelfMode { List, Page, Grid }
enum BookCatalogMode { Tree, Flat }
enum RestartPageIndex { Auto, Catalog, Editor, Assist }

class UserSetting {
  UserSetting({@required this.iniPath}) {
    if (FileUtil.isFileExists(iniPath)) {
      String content = FileUtil.readText(iniPath);
      config = Config.fromString(content);
    } else {
      config = new Config();
    }

    readFromFile();
  }

  Config config;
  String iniPath;

  /// =====================================================
  ///                       用户配置
  /// =====================================================

  // ----------------------- 全局 -----------------------
  bool debugMode = false;
  Color accentColor;
  Color windowFontColor;
  Color windowBackgroundColor;
  Color cardBackgroundColor;
  Color editorFontColor;

  // ----------------------- 界面 -----------------------
  BookShelfMode bookShelfMode; // 书架模式
  BookCatalogMode bookCatalogMode; // 目录模式
  bool bookCatalogWordCount; // 目录显示章节的字数

  // ----------------------- 编辑 -----------------------
  int indentSpace; // 段首缩进全角空格数量
  int indentLine; // 空行数量（不包括自己的空行）

  // ----------------------- 智能编辑 -----------------------
  bool smartQuote; // 智能引号
  bool smartSpace; // 智能空格
  bool spaceQuotes; // 空格引号
  bool smartEnter; // 智能回车
  bool autoPunc; // 自动标点
  String smartSpaceSpaceLeft; // 智能空格 符合左边表达式时强制空格
  String smartSpaceSpaceRight; // 智能空格 符合右边表达式时强制空格
  String smartEnterNoPunc; // 智能回车 不添加标点的正则表达式
  bool paraAfterQuote; // 多段后引号

  // ----------------------- 内容感知 -----------------------
  bool emotionFilter;

  // ----------------------- 数据 -----------------------
  bool autoSave; // 每改一个字就自动保存

  // ----------------------- 同步 -----------------------
  bool syncEnabled; // 同步数据
  bool rankEnabled; // 同步积分并参加排行榜

  // ----------------------- 交互 -----------------------
  RestartPageIndex restartPageIndex;

  // ----------------------- 素材 -----------------------

  // ----------------------- 排版 -----------------------
  bool typesetLongPara; // 长段落自动排版
  bool typesetWordsBlank; // 单词和中文之间的空格
  bool typesetArab; // 阿拉伯数字转中文
  bool typesetFirstLetter; // 句子首字母大写
  bool typesetPaste; // 粘贴排版

  /// =====================================================
  ///                       一些方法
  /// =====================================================

  /// 读取已有的配置文件
  void readFromFile() {
    bookShelfMode = BookShelfMode
        .values[getInt('us/book_shelf_mode', BookShelfMode.List.index)];
    bookCatalogMode = BookCatalogMode
        .values[getInt('us/book_catalog_mode', BookCatalogMode.Tree.index)];
    bookCatalogWordCount = getBool('us/book_catalog_word_count', false);

    indentSpace = getInt('us/indent_space', 2);
    indentLine = getInt('us/indent_line', 1);

    smartQuote = getBool('us/smart_quote', true);
    smartSpace = getBool('us/smart_space', true);
    spaceQuotes = getBool('us/space_quotes', true);
    smartEnter = getBool('us/smart_enter', true);
    autoPunc = getBool('us/auto_punc', true);
    smartSpaceSpaceLeft = getStr('us/smart_space_space_left', '');
    smartSpaceSpaceRight = getStr('us/smart_space_space_right', '');
    smartEnterNoPunc = getStr('us/smart_enter_no_punc', '');
    paraAfterQuote = getBool('us/para_after_quote', false);

    emotionFilter = getBool('us/emotion_filter', true);
    
    autoSave = getBool('us/auto_save', true);

    syncEnabled = getBool('us/sync_enabled', true);
    rankEnabled = getBool('us/rank_enabled', true);

    restartPageIndex = RestartPageIndex
        .values[getInt('us/restart_page_index', 0)];

    typesetLongPara = getBool('us/typesetLongPara', true);
    typesetWordsBlank = getBool('us/typesetWordsBlank', true);
    typesetArab = getBool('us/typesetArab', false);
    typesetFirstLetter = getBool('us/typesetFirstLetter', false);
    typesetPaste = getBool('us/typesetPaste', true);
  }

  // 运行时设置（不需要手动保存）
  bool showCatalogRecycle = false; // 显示目录回收站

  /// 保存设置到文件
  void setConfig(String key, value) {
    if (key.contains('/')) {
      int pos = key.indexOf('/');
      String name = key.substring(0, pos);
      String option = key.substring(pos + 1);
      if (!config.hasSection(name)) {
        config.addSection(name);
      }
      /*if (value is int) {
        value = value.toString();
      } else if (value is bool) {
        value = value ? 'true' : 'false';
      } else if (value is Color) {
        value = value.toString();
      }*/
      config.set(name, option, value.toString());
    } else {
      config.set('', key, value);
    }
    FileUtil.writeText(iniPath, config.toString());
  }

  bool getBool(String key, bool def) {
    var s = getConfig(key, def);
    if (s is String)
      return !(s == '0' || s == '' || s.toLowerCase() == 'false');
    return s;
  }

  int getInt(String key, int def) {
    var s = getConfig(key, def);
    if (s is String) return int.parse(s);
    return s;
  }

  String getStr(String key, String def) {
    var s = getConfig(key, def);
    return s.toString();
  }

  /// 读取设置，不存在则为空
  dynamic getValue(String key) {
    if (key.contains('/')) {
      int pos = key.indexOf('/');
      String name = key.substring(0, pos);
      String option = key.substring(pos + 1);
      return config.get(name, option);
    } else {
      return config.get('', key);
    }
  }

  /// 读取设置，不存在则返回默认值
  dynamic getConfig(String key, def) {
    if (key.contains('/')) {
      int pos = key.indexOf('/');
      String name = key.substring(0, pos);
      String option = key.substring(pos + 1);
      if (config.hasOption(name, option)) {
        return config.get(name, option);
      } else {
        return def;
      }
    } else {
      if (config.hasOption('', key)) {
        return config.get('', key);
      } else {
        return def;
      }
    }
  }
}
