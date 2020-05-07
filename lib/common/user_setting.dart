import 'package:fairyland/utils/file_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:ini/ini.dart';

enum BookShelfMode { List, Page, Grid }
enum CatalogMode { Tree, Flat }

class UserSetting {
  UserSetting({@required this.iniPath}) {
    if (FileUtil.isFileExists(iniPath)) {
      String content = FileUtil.readText(iniPath);
      config = Config.fromString(content);
    } else {
      config = new Config();
    }

    readFromFile();
  }

  Config config;
  String iniPath;

  // 用户配置
  BookShelfMode bookShelfMode; // 书架模式
  CatalogMode catalogMode; // 目录模式
  
  // 运行时设置
  bool showCatalogRecycle = false; // 显示目录回收站

  /// 读取已有的配置文件
  void readFromFile() {
    bookShelfMode = getConfig('us/book_shelf_mode', BookShelfMode.List);
    catalogMode = getConfig('us/catalog_mode', CatalogMode.Tree);
  }

  /// 保存设置到文件
  void setConfig(String key, value) {
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
    FileUtil.writeText(iniPath, config.toString());
  }

  /// 读取设置，不存在则为空
  dynamic getValue(String key) {
    if (key.contains('/')) {
      int pos = key.indexOf('/');
      String name = key.substring(0, pos);
      String option = key.substring(pos + 1);
      return config.get(name, option);
    } else {
      return config.get('', key);
    }
  }

  /// 读取设置，不存在则返回默认值
  dynamic getConfig(String key, def) {
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
}
