import 'package:flutter/material.dart';

class ChapterEditor extends TextField {
  final TextEditingController controller;

  ChapterEditor({this.controller})
      : super(
          controller: controller,
          decoration: new InputDecoration.collapsed(hintText: "正文君"),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          autofocus: true,
          onTap: onViewTapped,
          onChanged: onContentChanged,
        ) {
    controller.addListener(onChangedListener);
  }

  /// 点击时触发
  static void onViewTapped() {
    print('onViewTapped');
  }
  
  /// 纯内容改变时触发
  static void onContentChanged(String text) {
    print('onContentChanged');
  }

  /// 当 TextField 内容变化、焦点变动，都会触发
  /// 但是移动光标位置，不一定触发（编辑完再点击会触发）
  void onChangedListener() {
    print('onContentChangedListener');
  }

  /// 设置文本
  void setText(String text, {undoable: false}) {
    controller.text = text;
  }

  /// 获取文本
  String getText() {
    return controller.text;
  }

  /// 转成纯文本
  String toPlainText() => getText();

  /// 获取光标位置
  int getPosition() {
    return controller.selection.start;
  }

  /// 获取选中情况
  TextSelection getSelection() {
    return controller.selection;
  }

  void insertText(String text, {pos: -1}) {
    pos = getPosition();
    String orig = controller.text;
    controller.text = orig.substring(0, pos) + text + orig.substring(pos);
  }
}
