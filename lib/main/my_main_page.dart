import 'package:flutter/material.dart';

abstract class MainPageBase extends StatefulWidget {
  MainPageBase({Key key}) : super(key: key);
  
  Widget getAppBarTitle() {
    return new Text('这是什么神仙写作');
  }

  List<Widget> getAppBarActions() {
//    return <Widget>[];
    return <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        tooltip: '添加',
        onPressed: () {},
      ),
      PopupMenuButton<String>(
        itemBuilder: (BuildContext content) =>
        <PopupMenuItem<String>>[
          PopupMenuItem<String>(
            value: "item1",
            child: Text('item1 value'),
          ),
          PopupMenuItem<String>(
            value: "item2",
            child: Text('item2 value'),
          ),
        ],
      )
    ];
  }

}
