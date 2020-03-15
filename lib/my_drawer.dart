
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('这是什么神仙写作'),
            accountEmail: Text('未登录'),
          ),
        ],
      ),
    );
  }

}