import 'package:fairyland/main/my_main_page.dart';
import 'package:flutter/material.dart';

class SquarePage extends MainPageBase {
  SquarePage({Key key, BuildContext context}) : super(key: key, context: context);

  @override
  State<StatefulWidget> createState() {
    return new _SquarePageState();
  }

}

class _SquarePageState extends State<SquarePage> {
  @override
  Widget build(BuildContext context) {
    return Text('广场');
  }

}