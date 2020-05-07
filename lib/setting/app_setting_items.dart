import 'package:fairyland/common/runtime_info.dart';
import 'package:fairyland/common/user_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum UserDataType {
  U_Null,
  U_Bool,
  U_Int,
  U_Range,
  U_Double,
  U_String,
  U_StringList,
  U_DataList,
}

class AppSettingItem {
  String key; // 唯一key
  Icon icon; // 图标
  String title; // 描述
  String description; // 介绍
  UserDataType dataType; // 数据种类
  var showedValue; // 显示的值
  var onClicked; // 点击后的操作

  List<String> groupNames;
  List<List<AppSettingItem>> groupItems;

  AppSettingItem(this.key, this.icon, this.title, this.description,
      this.dataType, this.showedValue, this.onClicked) {
    if (showedValue == null) {
      showedValue = () {
        return description;
      };
    }
  }
}

class AppSettingGroups {
  List<String> names;
  List<List<AppSettingItem>> items;

  /// 添加一个分组
  List<AppSettingItem> addGroup(String name) {
    names.add(name);
    List<AppSettingItem> list = [];
    items.add(list);
    return list;
  }

  /// 添加一个分组的项目
  /// 如果没有项目，则添加一个默认的分组
  List<AppSettingItem> addItem(AppSettingItem item) {
    if (names.length == 0) {
      addGroup('');
    }
    items.last.add(item);
    return items.last;
  }

  /// 是否有多个分组
  /// 如果只有一个分组，则可能不特别分开显示分组
  bool isMultiGroups() {
    return names.length <= 1;
  }
}
