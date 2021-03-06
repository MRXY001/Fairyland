import 'package:fairyland/common/runtime_info.dart';
import 'package:fairyland/common/user_setting.dart';
import 'package:fairyland/common/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'app_setting_item_bean.dart';

class AppSettingFactory {
  final RuntimeInfo rt;
  final UserSetting us;

  AppSettingFactory(this.rt, this.us);

  /// 初始化所有外层分组
  void initAppSettingItems() {
    AppSettingGroups asg = G.asg;

    asg.addGroup('界面设置');

    asg.addItem(new AppSettingItem('theme', null, '主题色彩', UserDataType.U_Next,
        description: '背景色、点缀色', nextGroups: getColorsGroup()));

    asg.addItem(new AppSettingItem(
        'appearance', null, '通用界面', UserDataType.U_Next,
        description: '书架、目录', nextGroups: getAppearanceGroup()));

    asg.addGroup('编辑');

    asg.addItem(new AppSettingItem(
        'appearance', null, '编辑器', UserDataType.U_Next,
        description: '自动缩进、自动分段、字数提醒', nextGroups: getEditorGroup()));

    asg.addItem(new AppSettingItem(
        'appearance', null, '智能编辑', UserDataType.U_Next,
        description: '智能标点、同音词覆盖、标点覆盖', nextGroups: getEditorAIGroup()));

    asg.addItem(new AppSettingItem(
        'appearance', null, '内容感知', UserDataType.U_Next,
        description: '情绪滤镜、高潮模式', nextGroups: getEditorAIGroup()));

    asg.addGroup('其他');

    asg.addItem(new AppSettingItem(
        'appearance', null, '数据安全', UserDataType.U_Next,
        description: '自动保存、章节快照', nextGroups: getDataGroup()));

    asg.addItem(new AppSettingItem(
        'appearance', null, '云同步', UserDataType.U_Next,
        description: '数据自动同步', nextGroups: getSyncGroup()));

    asg.addItem(new AppSettingItem(
        'lexicon', null, '素材与排版', UserDataType.U_Next,
        description: '词语、句子、一键排版', nextGroups: getLexiconGroup()));
  }

  /// 初始化主题设置
  AppSettingGroups getColorsGroup() {
    AppSettingGroups group = new AppSettingGroups();

    group.addItem(new AppSettingItem('accent_color', Icon(Icons.all_inclusive),
        '主题色', UserDataType.U_Color));

    group.addItem(new AppSettingItem('window_background_color',
        Icon(Icons.font_download), '背景颜色', UserDataType.U_Color));

    group.addItem(new AppSettingItem('window_font_color',
        Icon(Icons.description), '文字颜色', UserDataType.U_Color));

    return group;
  }

  /// 初始化界面部分
  AppSettingGroups getAppearanceGroup() {
    AppSettingGroups group = new AppSettingGroups();
    
    var initAppearanceItems = (index) => ['列表', '页面', '网格'][index.index];
    group.addItem(new AppSettingItem(
        'book_catalog_mode', Icon(Icons.list), '书架风格', UserDataType.U_Enum,
        showedValue: () => initAppearanceItems(us.bookShelfMode),
        data: BookShelfMode.values,
        getter: initAppearanceItems,
        setter: (val) {
          us.bookShelfMode = val;
        }));

    var bookCatalogModeToString = (index) => ['树状', '单层'][index.index];
    group.addItem(new AppSettingItem(
        'book_catalog_mode', Icon(Icons.list), '目录风格', UserDataType.U_Enum,
        showedValue: () => bookCatalogModeToString(us.bookCatalogMode),
        data: BookCatalogMode.values,
        getter: bookCatalogModeToString,
        setter: (val) {
          us.bookCatalogMode = val;
        }));

    var restartPageIndex = (index) => ['自动', '目录', '写作', '助手'][index.index];
    group.addItem(new AppSettingItem(
      'restart_page_index', Icon(Icons.pages), '默认页面', UserDataType.U_Enum,
      showedValue: ()=>restartPageIndex(us.restartPageIndex),
      data: RestartPageIndex.values,
      getter: restartPageIndex,
      setter: (val) {
        us.restartPageIndex = val;
      }
    ));

    return group;
  }

  /// 初始化编辑器部分
  AppSettingGroups getEditorGroup() {
    AppSettingGroups group = new AppSettingGroups();

    group.addItem(new AppSettingItem(
        'enable_markdown', Icon(Icons.format_quote), '使用Markdown', UserDataType.U_Bool,
        description: '切换为Markdown编辑器（重启生效）',
        getter: () => us.getBool('enable_markdown', false),));
    
    group.addItem(new AppSettingItem(
        'indent_space', Icon(Icons.space_bar), '行首缩进', UserDataType.U_Int,
        getter: () => us.indentSpace,
        setter: (val) =>
            us.setConfig('us/indent_space', us.indentSpace = val)));
    group.addItem(new AppSettingItem('indent_line',
        Icon(Icons.format_line_spacing), '段落空行', UserDataType.U_Int,
        getter: () => us.indentLine,
        setter: (val) => us.setConfig('us/indent_line', us.indentLine = val)));

    return group;
  }

  /// 初始化智能编辑部分
  AppSettingGroups getEditorAIGroup() {
    AppSettingGroups group = new AppSettingGroups();
    
    group.addItem(new AppSettingItem(
        'smart_quote', Icon(Icons.format_quote), '智能引号', UserDataType.U_Bool,
        getter: () => us.smartQuote,
        setter: (val) => us.smartQuote = val));

    group.addItem(new AppSettingItem(
        'smart_space', Icon(Icons.space_bar), '智能空格', UserDataType.U_Bool,
        getter: () => us.smartSpace,
        setter: (val) => us.smartSpace = val));

    group.addItem(new AppSettingItem('smart_enter',
        Icon(Icons.transit_enterexit), '智能回车', UserDataType.U_Bool,
        getter: () => us.smartEnter,
        setter: (val) => us.smartEnter = val));

    group.addItem(new AppSettingItem(
        'auto_punc', Icon(Icons.bubble_chart), '自动句末标点', UserDataType.U_Bool,
        getter: () => us.autoPunc,
        setter: (val) => us.autoPunc = val));

    return group;
  }
  
  /// 初始化内容感知部分
  AppSettingGroups getContentPerceptionGroup() {
    AppSettingGroups group = new AppSettingGroups();
    
    return group;
  }

  /// 初始化数据部分
  AppSettingGroups getDataGroup() {
    AppSettingGroups group = new AppSettingGroups();

    group.addItem(new AppSettingItem(
        'auto_save', Icon(Icons.format_quote), '自动保存', UserDataType.U_Bool,
        description: '每修改一个字就保存',
        getter: () => us.autoSave,
        setter: (val) => us.autoSave = val));

    return group;
  }

  /// 初始化同步部分
  AppSettingGroups getSyncGroup() {
    AppSettingGroups group = new AppSettingGroups();

    group.addItem(new AppSettingItem(
        'sync_enabled', Icon(Icons.format_quote), '同步作品', UserDataType.U_Bool,
        description: '据说有人担心投稿？',
        getter: () => us.syncEnabled,
        setter: (val) =>
            us.syncEnabled = val));

    group.addItem(new AppSettingItem(
        'rank_enabled', Icon(Icons.format_quote), '参与排行榜', UserDataType.U_Bool,
        description: '传说大神都是默默无闻的',
        getter: () => us.rankEnabled,
        setter: (val) =>
            us.rankEnabled = val));

    return group;
  }

  /// 初始化词库部分
  AppSettingGroups getLexiconGroup() {
    AppSettingGroups group = new AppSettingGroups();

    return group;
  }
}
