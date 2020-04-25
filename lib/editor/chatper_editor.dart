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

  /// =====================================================
  ///                       原生事件
  /// =====================================================

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

  /// =====================================================
  ///                       原生操作
  /// =====================================================

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

  /// 插入指定文本
  void insertText(String text, {pos: -1}) {
    pos = getPosition();
    String orig = controller.text;
    setText(orig.substring(0, pos) + text + orig.substring(pos));
  }

  /// 末尾插入指定文本
  void appendText(String text, {newLine: false}) {
    String total = controller.text;
    if (newLine && !total.endsWith('\n')) total += '\n';
    setText(total + newLine);
  }

  /// 删掉指定位置的内容
  void removeText(int start, int end) {
    String ori = controller.text;
    setText(ori.substring(0, start) + ori.substring(end));
  }

  /// 获取光标位置
  int getPosition() {
    return controller.selection.start;
  }

  /// 设置光标位置
  void setPosition(int pos, {aim: -1}) {
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: pos));
  }

  /// 移动光标位置
  void movePosition(int delta) {
    setPosition(getPosition() + delta);
  }

  /// 移动光标位置
  void moveCursor(int delta) => movePosition(delta);

  /// 是否选中了文本
  bool hasSelection() {
    return controller.selection.start == controller.selection.end;
  }

  /// 设置选中范围
  void setSelection(int start, int end) {
    controller.selection = TextSelection(baseOffset: start, extentOffset: end);
  }

  /// 全选文本
  void selectAll() {
    setSelection(0, getText().length);
  }

  /// 获取选中情况
  TextSelection getSelection() {
    return controller.selection;
  }

  void copy() {}

  void cut() {}

  void paste() {}

  void clear() {}

  void undo() {}

  void redo() {}

  /// 保存到文件
  void saveToFile(String path) {}

  /// 从文件读入
  void loadFromFile(String path) {}

  /// =====================================================
  ///                       高级操作
  /// =====================================================

  /// 获取光标所在单词
  String currentWord({pos: -1}) {
    if (pos == -1) pos = getPosition();
    return '';
  }

  /// 获取光标所在句子
  String currentSentence({pos: -1}) {
    if (pos == -1) pos = getPosition();
    return '';
  }

  /// 获取光标所在段落
  String currentParagraph({pos: -1}) {
    if (pos == -1) pos = getPosition();
    return '';
  }

  /// =====================================================
  ///                       手动事件
  /// =====================================================

  /// 回车键事件
  void onKeyEnterClicked() {}

  /// 空格键事件
  void onKeySpaceClicked() {}

  /// 双引号事件
  void onKeyQuoteClicked() {}

  /// =====================================================
  ///                       简单动作
  /// =====================================================

  /// =====================================================
  ///                       小说AI
  /// =====================================================
}
