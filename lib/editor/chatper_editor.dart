import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'undo_redo_manager.dart';

// ignore: must_be_immutable
class ChapterEditor extends TextField {
  final TextEditingController controller;
  final onViewTapped;
  final onContentChanged;
  final onEditSave;
  OperatorManager undoRedoManager;
  bool _systemChanging = false;

  ChapterEditor(
      {this.controller,
      this.onViewTapped,
      this.onContentChanged,
      @required this.onEditSave})
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
    undoRedoManager = new OperatorManager();
    undoRedoManager.enable().initUndoRedo(controller);
  }

  /// =====================================================
  ///                       外部操作
  /// =====================================================
  void initContent(String content) {
    // TODO: 删除可撤销操作
    undoRedoManager.clearUndoRedo();

    // 设置文本
    beginSystemChanging();
    setText(content);
    undoRedoManager.enable().initUndoRedo(controller);
    endSystemChanging();
  }

  void disableContent() {
    beginSystemChanging();
    controller.clear();
    undoRedoManager.clearUndoRedo();
    endSystemChanging();
  }

  /// 开始系统批量改变
  void beginSystemChanging() {
    _systemChanging = true;
  }

  /// 结束系统批量改变
  void endSystemChanging() {
    _systemChanging = false;
  }

  /// 是否是系统引起的变化
  bool isSystemChanging() => _systemChanging;

  /// =====================================================
  ///                       原生事件
  /// =====================================================

  /// 当 TextField 内容变化、焦点变动，都会触发
  /// 但是移动光标位置，不一定触发（编辑完再点击会触发）
  /// 并且先于 contentChangedEvent 触发
  void onChangedListener() {
    if (isSystemChanging()) {
      return;
    }
    // 判断输入的内容
    beginSystemChanging();

    endSystemChanging();

    // 保存
    undoRedoManager.onTextChanged(controller);
    onEditSave(getText());
  }

  /// 点击时触发
  void viewTappedEvent() {
    //    print('viewTappedEvent');
  }

  /// 纯内容改变时触发
  void contentChangedEvent(String text) {
    //    print('contentChangedEvent');
  }

  /// =====================================================
  ///                       原生操作
  /// =====================================================

  /// 设置文本
  void setText(String text, {undoable: true, pos: -1}) {
    controller.text = text;
    if (pos > -1) {
      setPosition(pos);
    }
    if (!undoable) {
      clearUndoRedo();
      initUndoRedo();
    }
  }

  /// 获取文本
  String getText() {
    return controller.text;
  }

  /// 转成纯文本
  String toPlainText() => getText();

  /// 插入指定文本
  void insertText(String text, {pos: -1}) {
    int cursor = getPosition();
    String orig = controller.text;
    if (pos == -1) {
      // 使用光标位置
      pos = cursor;
      // 清除选中内容
      if (hasSelection()) {
        pos = controller.selection.start;
        orig = orig.substring(0, controller.selection.start) +
            orig.substring(controller.selection.end);
      }
    }
    String curr = orig.substring(0, pos) + text + orig.substring(pos);
    if (pos <= cursor) {
      pos += text.length;
    }
    setText(curr, pos: pos);
  }

  /// 末尾插入指定文本
  void appendText(String text, {newLine: false}) {
    String total = controller.text;
    if (newLine && !total.endsWith('\n')) text = '\n' + text;
    insertText(text, pos: total.length);
  }

  /// 删掉指定位置的内容
  void removeText(int start, int end) {
    String ori = controller.text;
    int cursor = getPosition();
    if (cursor >= end) {
      cursor -= (end - start);
    } else if (cursor >= start) {
      cursor = start;
    }
    setText(ori.substring(0, start) + ori.substring(end), pos: cursor);
  }

  /// 获取光标位置
  int getPosition() {
    return controller.selection.start;
  }

  /// 设置光标位置
  /// TODO: 设置光标位置
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

  /// 保存到文件
  void saveToFile(String path) {}

  /// 从文件读入
  void loadFromFile(String path) {}

  /// =====================================================
  ///                       撤销重做
  /// =====================================================

  void undo() {
    undoRedoManager.undo(controller);
  }

  void redo() {
    undoRedoManager.redo(controller);
  }

  void initUndoRedo() {}

  void clearUndoRedo() {}

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


