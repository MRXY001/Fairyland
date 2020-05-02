import 'package:fairyland/utils/file_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:ini/ini.dart';

class UserSettings {
  UserSettings({@required this.iniPath}) {
    if (FileUtil.isFileExists(iniPath)) {
      String content = FileUtil.readText(iniPath);
      config = Config.fromString(content);
    } else {
      config = new Config();
    }
  }

  Config config;
  String iniPath;

  // 配置
  int catalog_mode;

  // 快捷方法
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
    FileUtil.writeText(rt.dataPath + 'settings.ini', config.toString());
  }

  dynamic getConf(String key) {
    if (key.contains('/')) {
      int pos = key.indexOf('/');
      String name = key.substring(0, pos);
      String option = key.substring(pos + 1);
      return config.get(name, option);
    } else {
      return config.get('', key);
    }
  }

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
