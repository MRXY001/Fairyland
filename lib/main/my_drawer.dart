import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('创作仙国'),
            accountEmail: Text('云同步：未登录'),
            onDetailsPressed: () {}, // 会导致账号右边出现箭头
            currentAccountPicture: null,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.golf_course),
                  title: Text('码字风云榜'),
                  onTap: (){},
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('强制码字'),
                  onTap: (){},
                ),
              ],
            )
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  print('打开设置');
                },
                child: Text('设置'),
              )
            ],
          )
        ],
      ),
    );
  }
}
