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

    AppSettingGroups appearanceGroups = new AppSettingGroups();
    asg.addItem(new AppSettingItem(
        'appearance', null, '通用界面', UserDataType.U_Next,
        description: '书架、目录', nextGroups: appearanceGroups));
    initAppearanceItems(appearanceGroups);
  }

  /// 初始化界面部分
  void initAppearanceItems(AppSettingGroups asg) {
    var initAppearanceItems = (index) => ['列表', '页面', '网格'][index.index];
    asg.addItem(new AppSettingItem(
        'book_catalog_mode', Icon(Icons.list), '目录风格', UserDataType.U_Enum,
        showedValue: () => initAppearanceItems(us.bookShelfMode),
        data: BookShelfMode.values,
        getter: initAppearanceItems,
        setter: (val) => G.us.bookShelfMode = val));

    var bookCatalogModeToString = (index) => ['树状', '单层'][index.index];
    asg.addItem(new AppSettingItem(
        'book_catalog_mode', Icon(Icons.list), '目录风格', UserDataType.U_Enum,
        showedValue: () => bookCatalogModeToString(us.bookCatalogMode),
        data: BookCatalogMode.values,
        getter: bookCatalogModeToString,
        setter: (val) => G.us.bookCatalogMode = val));
  }
}
