import 'package:dio/dio.dart';
import 'package:fairyland/dialogs/loading_dialog.dart';
import 'package:fairyland/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:fairyland/common/global.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginWindow extends StatelessWidget {
  String _username;
  String _password;
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('登录/注册'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 80,
              width: 80,
              margin: EdgeInsets.only(top: 50),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/icons/writerfly_appicon.png'),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                '帐号登录',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 30,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '手机/邮箱/帐号',
                  labelText: '帐号',
                ),
                onChanged: (val) => _username = val,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 30,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '请输入您的帐号密码',
                  labelText: '密码',
                ),
                onChanged: (val) => _password = val,
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 30,
              ),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '登录',
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  _goLogin(context);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 30,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(flex: 1, child: Text('忘记密码')),
                  Expanded(flex: 0, child: Text('注册帐号')),
                ],
              ),
            ),
            Expanded(flex: 1, child: Container()),
            Container(
              margin: EdgeInsets.only(
                left: 30,
                right: 30,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Text('快速登录'),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 30,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goLogin(BuildContext context) async {
    var dialogContext;
    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
      dialogContext = context;
      return new LoadingDialog(text: '正在登录中...');
    });
    try {
      List<String> params = [
        'username',
        _username,
        'password',
        _password,
        'version',
        G.APP_VERSION.toString(),
        'vericode',
        G.ac.enVerity(),
        'allwords',
        G.ac.getAllWords().toString(),
        'alltimes',
        G.ac.getAllTimes().toString(),
        'alluseds',
        G.ac.getAllUseds().toString(),
        'allbonus',
        G.ac.getAllBonus().toString()
      ];
      Response response = await Dio().get(G.SERVER_PATH +
          'account_login.php?' +
          StringUtil.listToUrlParam(params));
      String result = response.toString();
//      print('response:' + result);
      var xml = (String tag) => StringUtil.getXml(result, tag);
      var xmlI = (String tag) => StringUtil.getXmlInt(result, tag);
      if (xml('state').toUpperCase() == 'OK') {
        // 登录成功
        G.ac.setAccount(xml('userID'), xml('username'), _password, xml('nickname'));
        G.ac.setIntegral(xmlI('allwords'), xmlI('alltimes'), xmlI('alluseds'), xmlI('allbonus'));
        G.ac.setVIP(xmlI('VIP'), xmlI('VIP_deadline'));
        G.ac.setRoom(xml('roomID'), xml('roomname'));
        G.ac.setRank(xmlI('rank'));
        G.ac.saveAccountInfo();
        Fluttertoast.showToast(msg: '欢迎回来，' + G.ac.getNickname());
        Navigator.pop(context, G.ac.getUserID());
      } else {
        String error = xml('ERROR');
        Fluttertoast.showToast(msg: error);
      }
    } catch (e) {
      print('login connect error:' + e.toString());
    }
    Navigator.pop(dialogContext);
  }
}
