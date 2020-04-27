// 提供五套可选主题色
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

  static String cBookChapterPath(String id) =>
      cBookChaptersPathD() + id + ".chpt";

  static String rBookPathD(String name) => recyclesBooksPath + name + '/';

  static String rBookPath(String name) => recyclesBooksPath + name;

  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;

  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  // 设置
  static SharedPreferences sp;
  static Config config;

  static void setConfig(String key, value) {
    if (key.contains('/')) {
      int pos = key.indexOf('/');
      String name = key.substring(0, pos);
      String option = key.substring(pos + 1);
      if (!config.hasSection(name)) {
        config.addSection(name);
      }
      config.set(name, option, value);
    } else {
      config.set('', key, value);
    }
    FileUtil.writeText(dataPath + 'settings.ini', config.toString());
  }

  static dynamic getConf(String key) {
    if (key.contains('/')) {
      int pos = key.indexOf('/');
      String name = key.substring(0, pos);
      String option = key.substring(pos + 1);
      return config.get(name, option);
    } else {
      return config.get('', key);
    }
  }

  static dynamic getConfig(String key, def) {
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

  // 运行中

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    sp = await SharedPreferences.getInstance();

    storagePath = (await getExternalStorageDirectory()).path;
    dataPath = (await getApplicationDocumentsDirectory()).path + '/data/';
    booksPath = dataPath + 'books/';
    recyclesPath = dataPath + 'recycles/';
    recyclesBooksPath = recyclesPath + 'books/';

    if (FileUtil.isFileExists(dataPath + 'settings.ini')) {
      String content = FileUtil.readText(dataPath + 'settings.ini');
      config = Config.fromString(content);
    } else {
      config = new Config();
    }
  }
}
