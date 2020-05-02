// 提供五套可选主题色
import 'package:fairyland/common/runtime_info.dart';
import 'package:fairyland/common/user_settings.dart';
import 'package:fairyland/utils/file_util.dart';
import 'package:flutter/material.dart';
import 'package:ini/ini.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class G {
  static RuntimeInfo rt;
  static UserSettings us;

  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;

  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  // 设置
  static SharedPreferences sp;

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    rt = new RuntimeInfo(
        dataPath: (await getApplicationDocumentsDirectory()).path + '/data/',
        storagePath: (await getExternalStorageDirectory()).path);

    us = new UserSettings(iniPath: rt.dataPath + 'settings.ini');

    sp = await SharedPreferences.getInstance();
  }
}
