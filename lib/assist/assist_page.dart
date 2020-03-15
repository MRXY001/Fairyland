import 'package:fairyland/main/my_main_page.dart';
import 'package:flutter/material.dart';

class AssistPage extends MainPageBase {
  AssistPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _AssistPageState();
  }

  @override
  Widget getAppBarTitle() {
    return Text('辅助');
  }

}

class _AssistPageState extends State<AssistPage> {
  @override
  Widget build(BuildContext context) {
    return Text('辅助');
  }

}