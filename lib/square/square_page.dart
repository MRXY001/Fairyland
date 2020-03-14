import 'package:flutter/material.dart';

class SquarePage extends StatefulWidget {
  SquarePage({Key key}) : super(key: key);

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