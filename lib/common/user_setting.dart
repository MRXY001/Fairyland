import 'package:fairyland/utils/file_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ini/ini.dart';

enum BookShelfMode { List, Page, Grid }
enum BookCatalogMode { Tree, Flat }

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

  // ----------------------- 编辑 -----------------------
  int indentSpace;
  int indentLine;
  
  // ----------------------- 智能编辑 -----------------------
  bool smartQuote;
  bool smartSpace;
  bool smartEnter;
  bool autoPunc;
  
  // ----------------------- 文字感知 -----------------------

  // ----------------------- 数据 -----------------------
  bool autoSave;
  
  // ----------------------- 同步 -----------------------
  bool syncEnabled;
  bool rankEnabled;

  // ----------------------- 交互 -----------------------

  // ----------------------- 素材 -----------------------

  // ----------------------- 排版 -----------------------

  /// =====================================================
  ///                       一些方法
  /// =====================================================

  /// 读取已有的配置文件
  void readFromFile() {
    bookShelfMode = getConfig('us/book_shelf_mode', BookShelfMode.List);
    bookCatalogMode = getConfig('us/book_catalog_mode', BookCatalogMode.Tree);
    
    indentSpace = getInt('us/indent_space', 2);
    indentLine = getInt('us/indent_line', 1);
    
    smartQuote = getBool('us/smart_quote', true);
    smartSpace = getBool('us/smart_space', true);
    smartEnter = getBool('us/smart_enter', true);
    autoPunc = getBool('us/auto_punc', true);
    
    autoSave = getBool('us/auto_save', true);
    
    syncEnabled = getBool('us/sync_enabled', true);
    rankEnabled = getBool('us/rank_enabled', true);
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
    if (s is String)
      return int.parse(s);
    return s;
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
