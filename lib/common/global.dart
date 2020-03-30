// 提供五套可选主题色
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

class Global {
  // 路径相关
  static String storagePath; // 外部存储目录
  static String dataPath; // 应用数据路径
  static String booksPath; // 小说路径

  static String currentBookName;
  static String bookPath(String name) => booksPath + name + '/';
  static String bookCatalogPath(String name) => booksPath + name + '/';
  static String cBookPath() => dataPath + 'books/' + currentBookName + '/';
  static String cBookCatalogPath() => cBookPath() + '/catalog.json';
  static String cBookChaptersPath() => cBookPath() + '/chapters/';

  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;

  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  // 设置
  static SharedPreferences sp;
  static Config config;
  
  // 运行中
  

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    sp = await SharedPreferences.getInstance();
    config = new Config();

    storagePath = (await getExternalStorageDirectory()).path;
    dataPath = (await getApplicationDocumentsDirectory()).path + '/data/';
    booksPath = dataPath + 'books/';
  }
}
