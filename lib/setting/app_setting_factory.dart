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

  void initAppSettingItems() {
    AppSettingGroups asg = G.asg;

    asg.addGroup('界面设置');

    AppSettingGroups appearanceGroups = new AppSettingGroups();
    asg.addItem(new AppSettingItem(
        'appearance', null, '通用界面', UserDataType.U_Next,
        description: '书架、目录', nextGroups: appearanceGroups));
    initAppearanceItems(appearanceGroups);
  }

  void initAppearanceItems(AppSettingGroups asg) {
    var bookShelfModeToString = (BookShelfMode val) {
      switch (val) {
        case BookShelfMode.List:
          return '列表';
        case BookShelfMode.Page:
          return '页面';
        case BookShelfMode.Grid:
          return '网格';
        default:
          return '未知';
      }
    };
    asg.addItem(new AppSettingItem(
        'book_shelf_mode', Icon(Icons.apps), '书架风格', UserDataType.U_Enum,
        showedValue: () {
          return bookShelfModeToString(us.bookShelfMode);
        },
        data: BookShelfMode.values,
        getter: bookShelfModeToString,
        setter: (val) {
          if (val is BookShelfMode) {
          G.us.bookShelfMode = val;
          } else {
            print('无法设置的属性：');
            print(val);
          }
        }));

    var bookCatalogModeToString = (BookCatalogMode val) {
      switch (val) {
        case BookCatalogMode.Tree:
          return '树状';
        case BookCatalogMode.Flat:
          return '单层';
        default:
          return '未知';
      }
    };
    asg.addItem(new AppSettingItem(
        'book_catalog_mode', Icon(Icons.list), '目录风格', UserDataType.U_Enum,
        showedValue: () {
          return bookCatalogModeToString(us.bookCatalogMode);
        },
        getter: bookCatalogModeToString,
        setter: (val) {
          G.us.bookCatalogMode = val;
        }));
  }
}
