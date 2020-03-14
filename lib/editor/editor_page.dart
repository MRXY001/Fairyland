import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _EditPageState();
  }

}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Text('写作');
  }

}