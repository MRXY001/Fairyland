import 'dart:math';

class AccountInfo {
  String _userID;
  String _username;
  String _password;
  String _nickname;
  // ignore: non_constant_identifier_names
  bool _VIP;
  int _rank;

  int _allWords;
  int _allTimes;
  int _allUseds;
  int _allBonus;

  AccountInfo() {
    // TEST: 生成测试文本
    _userID = '00000000';
    _username = 'mrxy001';
    _password = '11111111';
    _nickname = '小乂';
    _VIP = true;
    _allWords = 37824;
    _allTimes = 2304;
    _allUseds = 4398;
    _allBonus = 783;
    _rank = 35;
  }

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
  void setAccount(String userID, String username, String password, String nickname) {
  
  }
  
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
}
