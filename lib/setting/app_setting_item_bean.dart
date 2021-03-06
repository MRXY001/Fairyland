import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum UserDataType {
  U_Null,
  U_Bool,
  U_Enum,
  U_Int,
  U_Range,
  U_Double,
  U_String,
  U_Color,
  U_StringList,
  U_Next,
}

class AppSettingItem {
  String key; // 唯一key
  Icon icon; // 图标
  String title; // 描述
  String description; // 介绍
  UserDataType dataType; // 数据种类
  var data;
  var showedValue; // 显示的值
  var onClicked; // 点击后的操作
  var setter;
  var getter;
  AppSettingGroups nextGroups; // 下一个group

  List<String> groupNames;
  List<List<AppSettingItem>> groupItems;

  AppSettingItem(this.key, this.icon, this.title, this.dataType,
      {this.showedValue,
      this.onClicked,
      this.nextGroups,
      this.description,
      this.data,
      this.setter,
      this.getter}) {
    if (showedValue == null) {
      showedValue = () {
        // 如果没有简介，也没有需要显示的值，则使用 null
        if (description == null || description.isEmpty) {
          return null;
        }
        return description;
      };
    }
  }
}

class AppSettingGroups {
  List<String> names = [];
  List<List<AppSettingItem>> items = [];

  /// 添加一个分组
  AppSettingGroups addGroup(String name) {
    names.add(name);
    List<AppSettingItem> list = [];
    items.add(list);
    return this;
  }

  /// 添加一个分组的项目
  /// 如果没有项目，则添加一个默认的分组
  AppSettingGroups addItem(AppSettingItem item) {
    if (names.length == 0) {
      addGroup('');
    }
    items.last.add(item);
    return this;
  }

  /// 是否有多个分组
  /// 如果只有一个分组，则可能不特别分开显示分组
  bool isMultiGroups() {
    return names.length <= 1;
  }

  /// 获取分组的总数量
  int length() {
    return names.length;
  }

  /// 清空所有数据线（用来重新设置）
  void clear() {
    names.clear();
    items.forEach((element) {
      element.clear();
    });
    items.clear();
  }
}
