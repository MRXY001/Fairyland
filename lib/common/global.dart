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
  static String recyclesPath;
  static String recyclesBooksPath; // 回收站路径

  static String currentBookName;

  // 路径方法命名规则：PathD 结尾的带分割线（可以理解为 Dir，或 Divider）
  static String bookPathD(String name) => booksPath + name + '/';

  static String bookCatalogPathD(String name) =>
      booksPath + name + '/catalog.json';

  static String cBookPathD() => dataPath + 'books/' + currentBookName + '/';

  static String cBookCatalogPathD() => cBookPathD() + '/catalog.json';

  static String cBookChaptersPathD() => cBookPathD() + '/chapters/';

  static String rBookPathD(String name) => recyclesBooksPath + name + '/';

  static String rBookPath(String name) => recyclesBooksPath + name;

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
    recyclesPath = dataPath + 'recycles/';
    recyclesBooksPath = recyclesPath + 'books/';
  }
}
