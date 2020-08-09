import 'package:fairyland/editor/editor_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class MyZefyrEditor extends ZefyrEditor implements EditorInterface {
  final ZefyrController controller;
  final FocusNode focusNode;

  MyZefyrEditor({Key key, this.controller, this.focusNode})
      : super(
          padding: EdgeInsets.all(16),
          controller: controller,
          focusNode: focusNode,
        );

  @override
  void clear() {
    setText('');
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
  void disableContent() {
    // TODO: implement disableContent
  }

  @override
  int getPosition() {
    // TODO: implement getPosition
    throw UnimplementedError();
  }

  @override
  String getSelectionOrFull() {
    // TODO: implement getSelectionOrFull
    throw UnimplementedError();
  }

  @override
  String getText() {
    // TODO: implement getText
    throw UnimplementedError();
  }

  @override
  bool hasSelection() {
    // TODO: implement hasSelection
    throw UnimplementedError();
  }

  @override
  void initContent(String content) {
    // TODO: implement initContent
  }

  @override
  void initUndoRedo() {
    // TODO: implement initUndoRedo
  }

  @override
  void insertTextByPos(String text, {pos = -1}) {
    // TODO: implement insertTextByPos
  }

  @override
  void loadFromFile(String path) {
    // TODO: implement loadFromFile
  }

  @override
  void paste() {
    // TODO: implement paste
  }

  @override
  void redo() {
    // TODO: implement redo
  }

  @override
  bool canUndo() => false;

  @override
  bool canRedo() => false;

  @override
  void saveToFile(String path) {
    // TODO: implement saveToFile
  }

  @override
  void selectAll() {
    // TODO: implement selectAll
  }

  @override
  int selectionEnd() {
    // TODO: implement selectionEnd
    throw UnimplementedError();
  }

  @override
  int selectionStart() {
    // TODO: implement selectionStart
    throw UnimplementedError();
  }

  @override
  String selectionText() {
    // TODO: implement selectionText
    throw UnimplementedError();
  }

  @override
  void setPosition(int pos, {aim = -1}) {
    // TODO: implement setPosition
  }

  @override
  void setSelection(int start, int end) {
    // TODO: implement setSelection
  }

  @override
  void setText(String text, {undoable = true, pos = -1}) {
    // TODO: implement setText
  }

  @override
  void undo() {
    // TODO: implement undo
  }
}
