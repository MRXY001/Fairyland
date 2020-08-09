import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class MyZefyrEditor extends ZefyrEditor {
  final ZefyrController controller;
  final FocusNode focusNode;

  MyZefyrEditor({Key key, this.controller, this.focusNode})
      : super(
          padding: EdgeInsets.all(16),
          controller: controller,
          focusNode: focusNode,
        );
}
