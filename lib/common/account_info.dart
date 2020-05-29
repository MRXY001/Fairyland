import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:fairyland/utils/file_util.dart';
import 'package:fairyland/utils/string_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'global.dart';

class AccountInfo {
  // 用户账号
  String _userID;
  String _username;
  String _password;
  String _nickname;
  bool _VIP; // ignore: non_constant_identifier_names
  int _VIP_Deadline;
  int _rank;

  // 用户数据
  int _allWords;
  int _allTimes;
  int _allUseds;
  int _allBonus;
  String _roomID;
  String _roomname;

  // 运行数据
  String dataPath; // 用户数据文件路径
  String serverPath; // 后台网址

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

    // 获取运行数据
    dataPath = G.rt.dataPath + 'account';
    serverPath = G.SERVER_PATH;

    // 读取秘钥内容
    Future.sync(() => getKeys());

    // 因为有多线程的存在，所以需要延迟读取，唉
    Future.delayed(Duration(seconds: 3)).then((value) {
      restoreAccountInfo();
      tryLogin();
    });
  }

  void getKeys() {
    FileUtil.loadAsset('assets/keys/MOD.key')
        .then((value) => _____ = int.parse(value));
    FileUtil.loadAsset('assets/keys/MOD2.key')
        .then((value) => ______ = int.parse(value));
    FileUtil.loadAsset('assets/keys/LOW.key')
        .then((value) => _______ = int.parse(value));
  }

  /// 保存用户数据
  void saveAccountInfo() {
    // 转换为字符串
    String text = jsonEncode(toJson());

    // TODO: 加密字符串

    // 保存到文件
    FileUtil.writeText(dataPath, text);
  }

  /// 读取用户数据
  void restoreAccountInfo() {
    String text = FileUtil.readText(dataPath);
    if (text != null && text.isNotEmpty) {
      fromJson(json.decode(text));
    }
  }

  Map<String, dynamic> toJson() => {
        'username': _username,
        'password': _password,
        'nickname': _nickname,
        'allWords': _allWords,
        'allTimes': _allTimes,
        'allUseds': _allUseds,
        'allBonus': _allBonus,
      };

  void fromJson(Map<String, dynamic> json) {
    _username = json['username'];
    _password = json['password'];
    _nickname = json['nickname'];
    _allWords = json['allWords'];
    _allTimes = json['allTimes'];
    _allUseds = json['allUseds'];
    _allBonus = json['allBonus'];
  }

  /// 尝试自动登录
  void tryLogin() async {
    // 如果没有账号信息
    if (_username == null ||
        _password == null ||
        _username.isEmpty ||
        _password.isEmpty) {
      return;
    }

    // 开始登录
    login(_username, _password);
  }

  /// 手动登录
  Future login(String username, String password) async {
    try {
      List<String> params = [
        'username',
        _username,
        'password',
        _password,
        'version',
        G.APP_VERSION.toString(),
        'vericode',
        enVerity(),
        'allwords',
        getAllWords().toString(),
        'alltimes',
        getAllTimes().toString(),
        'alluseds',
        getAllUseds().toString(),
        'allbonus',
        getAllBonus().toString()
      ];
      Response response = await Dio().get(G.SERVER_PATH +
          'account_login.php?' +
          StringUtil.listToUrlParam(params));
      String result = response.toString();
      var xml = (String tag) => StringUtil.getXml(result, tag);
      var xmlI = (String tag) => StringUtil.getXmlInt(result, tag);
      if (xml('state').toUpperCase() == 'OK') {
        // 登录成功
        setAccount(xml('userID'), xml('username'), xml('password'), xml('nickname'));
        setIntegral(xmlI('allwords'), xmlI('alltimes'), xmlI('alluseds'), xmlI('allbonus'));
        setVIP(xmlI('VIP'), xmlI('VIP_deadline'));
        setRoom(xml('roomID'), xml('roomname'));
        setRank(xmlI('rank'));
        saveAccountInfo();
        print('登录成功：' + _username);
      } else {
        String error = xml('ERROR');
        Fluttertoast.showToast(msg: error);
      }
    } catch (e) {
      print('login connect error:' + e.toString());
    }
  }

  /// 注册
  Future register(String username, String password,
      {String tel: '', String mail: '', String qq: '', String wx: ''}) async {}

  bool isLogin() => _userID != null && _userID.isNotEmpty;

  bool isVIP() => _VIP;

  int getLevel() =>
      sqrt((_allWords + _allTimes + _allUseds / 10 + _allBonus) ~/ 100).toInt();

  String getUserID() => _userID;

  String getUsername() => _username;

  String getNickname() =>
      (_nickname != null && _nickname.isEmpty) ? _username : _nickname;

  int getAllWords() => _allWords;

  int getAllTimes() => _allTimes;

  int getAllUseds() => _allUseds;

  int getAllBonus() => _allBonus;

  int getRank() => _rank;

  String getSimpleInfo() {
    if (!isLogin()) {
      return '';
    }
    return 'Lv.' +
        getLevel().toString() +
        ' (第' +
        _rank.toString() +
        ') ' +
        _allWords.toString() +
        '字';
  }

  /// 登录结束设置用户账号
  void setAccount(
      String userID, String username, String password, String nickname) {
    this._userID = userID;
    this._username = username;
    this._password = password;
    this._nickname = nickname;
  }

  /// 设置用户数据
  void setIntegral(int words, int times, int useds, int bonus) {
    this._allWords = words;
    this._allTimes = times;
    this._allUseds = useds;
    this._allBonus = bonus;
  }

  void setRank(int rank) {
    this._rank = rank;
  }

  void setVIP(int level, int deadline) {
    this._VIP = (level > 0);
    this._VIP_Deadline = deadline;
  }

  void setRoom(String id, String name) {
    this._roomID = id;
    this._roomname = name;
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
