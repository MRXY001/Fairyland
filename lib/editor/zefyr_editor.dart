import 'dart:convert';
import 'dart:io';

import 'package:fairyland/editor/editor_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';

// ignore: must_be_immutable
class MyZefyrEditor extends ZefyrEditor implements EditorInterface {
  ZefyrController controller;
  FocusNode focusNode;

  MyZefyrEditor({Key key, this.controller, this.focusNode})
      : super(
          padding: EdgeInsets.all(16),
          controller: controller,
          focusNode: focusNode,
        ) {
    
  }

  @override
  void initContent(String content) {
    // TODO: implement initContent
  }

  @override
  void disableContent() {
    // TODO: implement disableContent
  }

  /// 设置为纯文本
  /// 这不是Markdown！
  /// 而且要设置的话，需要在外面使用setState
  @override
  void setText(String text, {undoable = true, pos = -1}) {
    final Delta delta = Delta()..insert(text);
    NotusDocument document = NotusDocument.fromDelta(delta);
    controller = ZefyrController(document);
  }

  /// 从JSON（文件）中恢复数据
  void setJson(String json) {
    NotusDocument document = NotusDocument.fromJson(jsonDecode(json));
    controller = ZefyrController(document);
  }

  @override
  String getText() => controller.document.toString();
  
  String toPlainText() => controller.document.toPlainText();

  @override
  int getPosition() {
    
    // TODO: implement getPosition
    throw UnimplementedError();
  }

  @override
  void setPosition(int pos, {aim = -1}) {
    // TODO: implement setPosition
  }

  @override
  String getSelectionOrFull() {
    // TODO: implement getSelectionOrFull
    throw UnimplementedError();
  }

  @override
  bool hasSelection() {
    // TODO: implement hasSelection
    throw UnimplementedError();
  }

  @override
  int selectionStart() {
    // TODO: implement selectionStart
    throw UnimplementedError();
  }

  @override
  int selectionEnd() {
    // TODO: implement selectionEnd
    throw UnimplementedError();
  }

  @override
  String selectionText() {
    // TODO: implement selectionText
    throw UnimplementedError();
  }

  @override
  void setSelection(int start, int end) {
    // TODO: implement setSelection
  }

  @override
  void selectAll() {
    // TODO: implement selectAll
  }

  @override
  void copy() {
    // TODO: implement copy
  }

  @override
  void cut() {
    // TODO: implement cut
  }

  @override
  void paste() {
    // TODO: implement paste
  }

  @override
  void clear() {
    setText('');
  }

  @override
  void insertTextByPos(String text, {pos = -1}) {
    // TODO: implement insertTextByPos
  }

  /// 这里保存的是JSON文件，而不是纯文本
  @override
  void saveToFile(String path) {
    final contents = jsonEncode(controller.document);
    // 临时路径：Directory.systemTemp.path + "/quick_start.json"
    final file = File(path);
    // And show a snack bar on success.
    file.writeAsString(contents).then((_) {
      // 保存结束
    });
  }

  @override
  void loadFromFile(String path) {
    final file = File(path);
    if (file.existsSync()) {
      final contents = file.readAsStringSync();
      setJson(contents);
    } else {
      // 没有数据，使用默认值
      setText('　　');
    }
  }

  @override
  void initUndoRedo() {
    // TODO: implement initUndoRedo
  }

  @override
  void undo() {
    // TODO: implement undo
  }

  @override
  void redo() {
    // TODO: implement redo
  }

  @override
  bool canUndo() => false;

  @override
  bool canRedo() => false;
}
