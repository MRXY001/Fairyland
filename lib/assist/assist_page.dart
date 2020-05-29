import 'package:fairyland/common/global.dart';
import 'package:flutter/material.dart';

class AssistPage extends StatefulWidget {
  AssistPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _AssistPageState();
  }
}

class _AssistPageState extends State<AssistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            leading: Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu), //自定义图标
                onPressed: () {
                  // 打开抽屉菜单
                  G.rt.mainHomeKey.currentState.openDrawer();
                },
              );
            }),
            title: Text('助手'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.announcement),
                tooltip: '综合搜索',
                onPressed: () {},
              ),
              getAssistMenu()
            ]),
        body: Column(
          children: <Widget>[],
        ));
  }

  PopupMenuButton getAssistMenu() {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext content) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: "new",
          child: Text('新建名片库'),
        ),
      ],
      onSelected: (String value) {
        switch (value) {
          default:
            {}
            break;
        }
      },
    );
  }
}
