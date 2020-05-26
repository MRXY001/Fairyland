import 'dart:math';
import 'package:fairyland/utils/file_util.dart';
import 'package:flutter/services.dart';

import 'global.dart';

class AccountInfo {
  // 用户账号
  String _userID;
  String _username;
  String _password;
  String _nickname;
  bool _VIP; // ignore: non_constant_identifier_names
  int _rank;

  // 用户数据
  int _allWords;
  int _allTimes;
  int _allUseds;
  int _allBonus;

  // 同步秘钥
  final _________ = 1000; // ignore: non_constant_identifier_names
  final DELTA_MIN_SECOND = 30; // ignore: non_constant_identifier_names
  final BYTE_MOVE_COUNT = 2; // ignore: non_constant_identifier_names
  int _____, ______, _______; // ignore: non_constant_identifier_names

  AccountInfo() {
    // TEST: 生成测试文本
    /*_userID = '00000000';
    _username = 'mrxy001';
    _password = '11111111';
    _nickname = '小乂';
    _VIP = true;
    _allWords = 37824;
    _allTimes = 2304;
    _allUseds = 4398;
    _allBonus = 783;
    _rank = 35;*/

    // 读取秘钥内容
    Future.sync(() => getKeys());

    Future.delayed(Duration(seconds: 3)).then((value) => tryLogin());
  }

  void getKeys() {
    FileUtil.loadAsset('assets/keys/MOD.key')
        .then((value) => _____ = int.parse(value));
    FileUtil.loadAsset('assets/keys/MOD2.key')
        .then((value) => ______ = int.parse(value));
    FileUtil.loadAsset('assets/keys/LOW.key')
        .then((value) => _______ = int.parse(value));
  }

  /// 尝试自动登录
  void tryLogin() async {
    // 读取存储的内容
    String username = '', password = '';
    
    // 如果没有账号信息
    if (username.isEmpty || password.isEmpty) {
      return ;
    }
    
    // 开始登录
    login(username, password);
  }

  /// 手动登录
  Future login(String username, String password) async {}

  /// 注册
  Future register(String username, String password,
      {String tel: '', String mail: '', String qq: '', String wx: ''}) async {}

  bool isLogin() => _userID != null && _userID.isNotEmpty;

  bool isVIP() => _VIP;

  int getLevel() =>
      sqrt((_allWords + _allTimes + _allUseds / 10 + _allBonus) ~/ 100).toInt();

  String getUserID() => _userID;

  String getUsername() => _username;

  String getNickname() => _nickname;

  int getAllWords() => _allWords;

  int getAllTimes() => _allTimes;

  int getAllUseds() => _allUseds;

  int getRank() => _rank;

  /// 登录结束设置用户账号
  void setAccount(
      String userID, String username, String password, String nickname) {}

  /// 设置用户数据
  void setIntegral(int words, int times, int useds, int bonus) {
    _allWords = words;
    _allTimes = times;
    _allUseds = useds;
    _allBonus = bonus;
  }

  /// 修改数据
  void addIntegral({words: 0, times: 0, useds: 0, bonus: 0}) {
    if (words != 0) {
      _allWords += words;
    }
    if (times != 0) {
      _allTimes += times;
    }
    if (useds != 0) {
      _allUseds += useds;
    }
    if (bonus != 0) {
      _allBonus += bonus;
    }
  }

  /// 获取13位时间戳
  int getTimestamp() => DateTime.now().millisecondsSinceEpoch;

  /// 传输加密算法
  String enVerity() {
    int __________ = getTimestamp();
    int ___________ = Random().nextInt(89999) + 10000;
    int ____________ = __________ ~/ _________ % ______;
    int _____________ = __________ % _________;
    _____________ =
        _____________ * _____________ * G.APP_VERSION % _____ + _______;
    int ______________ = _____________ *
            _____________ %
            _____ *
            _____________ *
            G.APP_VERSION %
            _____ +
        _______; // 突然发现好像多了一步，啧啧
    ____________ = ____________ * (______________ >> BYTE_MOVE_COUNT);
    return ___________.toString() +
        ____________.toString() +
        ______________.toString() +
        _____________.toString();
  }

  /// 传输解密算法
  bool deVerity(String ________) {
    int __________ = ________.length;
    if (__________ < 16) return false;
    int ___________ = int.parse(________.substring(5, __________ - 6));
    int ____________ =
        int.parse(________.substring(__________ - 6, __________ - 3));
    int _____________ =
        int.parse(________.substring(__________ - 3, __________));
    if (_____________ *
                _____________ %
                _____ *
                _____________ *
                G.APP_VERSION %
                _____ +
            _______ !=
        ____________) return false;

    int ______________ = ___________ ~/ (____________ >> BYTE_MOVE_COUNT);
    int _______________ = getTimestamp() ~/ _________ % ______;
    bool ________________ =
        _______________ - ______________ < DELTA_MIN_SECOND &&
            _______________ - ______________ > -DELTA_MIN_SECOND;
    return ________________;
  }
}
