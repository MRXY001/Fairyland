import 'package:fairyland/main/my_main_page.dart';
import 'package:flutter/material.dart';

class EditPage extends MainPageBase {
  EditPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _EditPageState();
  }
  
  @override
  Widget getAppBarTitle() {
    return Text('编辑');
  }

}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Text('写作');
  }

}