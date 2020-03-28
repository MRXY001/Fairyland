import 'package:flutter/material.dart';

abstract class MainPageBase extends StatefulWidget {
  MainPageBase({Key key}) : super(key: key);
  
  Widget getAppBarTitle() {
    return new Text('这是什么神仙写作');
  }

  List<Widget> getAppBarActions() {
    return <Widget>[];
  }

}
