import 'dart:convert';
import 'dart:io';

import 'package:fairyland/editor/editor_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';

// ignore: must_be_immutable
class MyZefyrEditor extends ZefyrEditor implements EditorInterface {
  // 控制
  ZefyrController controller;
  FocusNode focusNode;
  final onEditSave;

  // 编辑属性
  String _text;
  int _pos;
  int _length;
  int _selectionStart;
  int _selectionEnd;
  bool _textChanged;
  bool _posChanged;
  String _left1, _left2, _left3, _right1, _right2;

  MyZefyrEditor({Key key, this.controller, this.focusNode, this.onEditSave})
      : super(
          padding: EdgeInsets.all(16),
          controller: controller,
          focusNode: focusNode,
        ) {}

  @override
  void initContent(String content) {
    print('init content, but skip');
    //    setText(content);
  }

  @override
  void disableContent() {
    // TODO: implement disableContent
  }

  /// 设置为纯文本
  /// 这不是Markdown！
  @override
  void setText(String text, {undoable = true, pos = -1}) {
    if (pos == -1) {
      controller.replaceText(0, toPlainText().length, '');
    } else {
      insertTextByPos(text, pos: pos);
    }
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
    return controller.selection.start;
  }

  @override
  void setPosition(int pos, {sel = 0}) {
    if (sel == -1) {
      controller.updateSelection(TextSelection.fromPosition(TextPosition(
          affinity: TextAffinity.upstream, // 必须要上游，downstream不行
          offset: pos)));
    } else {
      controller
          .updateSelection(TextSelection(baseOffset: pos, extentOffset: sel));
    }
  }

  @override
  String getSelectionOrFull() {
    if (hasSelection()) return selectionText();
    return toPlainText();
  }

  @override
  bool hasSelection() {
    TextSelection sel = controller.selection;
    return sel.start != sel.end;
  }

  @override
  int selectionStart() => controller.selection.start;

  @override
  int selectionEnd() => controller.selection.end;

  @override
  String selectionText() {
    _selectionStart = controller.selection.start;
    _selectionEnd = controller.selection.end;
    _text = controller.document.toPlainText();
    return _text.substring(_selectionStart, _selectionEnd);
  }

  @override
  void setSelection(int start, int end) {
    controller
        .updateSelection(TextSelection(baseOffset: start, extentOffset: end));
  }

  @override
  void selectAll() {
    setSelection(0, controller.document.length);
  }

  @override
  void copy() => Clipboard.setData(ClipboardData(text: selectionText()));

  @override
  void cut() {
    if (!hasSelection()) return;
    String text = selectionText();
    _selectionStart = selectionStart();
    _selectionEnd = selectionEnd();
    deleteTextByPos(_selectionStart, _selectionEnd);
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  void paste() =>
      insertTextByPos(Clipboard.getData(Clipboard.kTextPlain).toString());

  @override
  void clear() {
    setText('');
  }

  /// 若不指定位置，则在光标或选择处插入文字
  @override
  void insertTextByPos(String text, {pos = -1}) {
    if (pos == -1) {
      pos = getPosition();
      controller.replaceText(pos, selectionText().length, text);
      setPosition(pos + text.length);
    } else {
      controller.replaceText(pos, 0, text);
    }
  }

  @override
  void deleteTextByPos(int start, int end) {
    controller.replaceText(start, end - start, '');
  }

  @override
  void replaceTextByPos(int start, int length, String text) {
    controller.replaceText(start, length, text);
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
      setPosition(2);
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
