import 'package:fairyland/common/global.dart';
import 'package:fairyland/setting/app_setting_window.dart';
import 'package:fairyland/user/login.dart';
import 'package:fairyland/user/profile.dart';
import 'package:fairyland/utils/web_util.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyDrawerState();
  }
}

class MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(G.ac.isLogin() ? G.ac.getNickname() : G.APP_NAME),
            accountEmail:
                Text(G.ac.isLogin() ? G.ac.getSimpleInfo() : '云同步：未登录'),
            onDetailsPressed: () {
              // 切换登录
              if (G.ac.isLogin()) {
                // 已登录，打开用户页面
                Navigator.pop(context); // 隐藏侧边栏
                Navigator.push<String>(context,
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return new ProfileWindow();
                }));
              } else {
                // 未登录，打开登录页面
                Navigator.pop(context); // 隐藏侧边栏
                Navigator.push<String>(context,
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return new LoginWindow();
                }));
              }
            },
            // 会导致账号右边出现箭头
            currentAccountPicture: null,
            otherAccountsPictures: <Widget>[],
          ),
          Expanded(
              child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.golf_course),
                title: Text('码字风云榜'),
                onTap: () {WebUtil.launchURL('http://writerfly.cn/rank');},
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('小黑屋'),
                onTap: () {},
              ),
            ],
          )),
          Row(
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.settings),
                label: Text('设置'),
                onPressed: () {
                  Navigator.pop(context); // 隐藏侧边栏
                  Navigator.push<String>(context,
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return new AppSettingWindow();
                  }));
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
