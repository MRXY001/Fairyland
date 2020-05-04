import 'package:flutter/widgets.dart';

enum UserDataType {
	U_Null,
	U_Bool,
	U_Int,
	U_Range,
	U_Double,
	U_String,
	U_StringList,
	U_List,
}

class AppSettingItem {
	String key; // 唯一key
	Icon icon; // 图标
	String title; // 描述
	String description; // 介绍
	UserDataType dataType; // 数据种类
	var getter;
	var setter;
	var onClicked;
	
	AppSettingItem(this.key, this.icon, this.title, this.description,
			this.dataType, this.getter, this.setter, this.onClicked);
};

class AppSettingManager {
	List<String> areaNames;
	List<List<AppSettingItem>> areaGroups;
}
