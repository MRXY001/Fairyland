import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

/// 撤销重做原子操作
class EditOperator {
  // 删除操作
  String src;
  int srcStart;
  int srcEnd;

  // 输入操作
  String dst;
  int dstStart;
  int dstEnd;

  EditOperator(
      {this.src,
      this.srcStart,
      this.srcEnd,
      this.dst,
      this.dstStart,
      this.dstEnd});

  void undo(TextEditingController controller) {
    String text = controller.text;

    int idx = -1;
    // 删除输入内容
    if (dstEnd != null && dstEnd > 0) {
      print('delete input: ' + dst);
      text = text.substring(0, dstStart) + text.substring(dstEnd);
      if (src == null) {
        idx = dstStart;
      }
    }
    // 插入删掉内容
    if (src != null) {
      print('insert delete: ' + src);
      text = text.substring(0, srcStart) + src + text.substring(srcStart);
    }

    controller.text = text;
    // 恢复光标位置
    if (idx >= 0) {
      controller.selection =
          TextSelection.fromPosition(TextPosition(offset: idx));
    }
  }

  void redo(TextEditingController controller) {
    String text = controller.text;

    int idx = -1;
    // 删除输入内容
    if (srcEnd != null && srcEnd > 0) {
      print('delete delete: ' + src);
      text = text.substring(0, srcStart) + text.substring(srcEnd);
      if (dst == null) {
        idx = srcStart;
      }
    }
    // 插入输入内容
    if (dst != null) {
      print('insert insert: ' + dst);
      text = text.substring(0, dstStart) + dst + text.substring(dstStart);
      idx = dstStart + dst.length;
    }

    controller.text = text;
    // 恢复光标位置
    if (idx >= 0) {
      controller.selection =
          TextSelection.fromPosition(TextPosition(offset: idx));
    }
  }
}

/// 撤销重做管理器
class OperatorManager {
  bool _enable = true;
  final List<EditOperator> undoOpts = [];
  final List<EditOperator> redoOpts = [];
  String preText; // 上一次变化的文本
  int preLength; // 上一次的文本长度
  int preStart; // 上一次变化的光标位置
  int preEnd; // 上一次变化的选中位置。如果是-1，则表示没有选中

  OperatorManager enable() {
    _enable = true;
    return this;
  }

  OperatorManager disable() {
    _enable = false;
    return this;
  }

  bool canUndo() {
    return undoOpts.length > 0;
  }

  bool canRedo() {
    return redoOpts.length > 0;
  }

  void clearUndoRedo() {
    undoOpts.clear();
    redoOpts.clear();
    preText = null;
    preStart = null;
    preEnd = null;
    _enable = false;
  }

  void initUndoRedo(TextEditingController controller) {
    preText = controller.text;
    preLength = preText.length;
    preStart = controller.selection.start;
    preEnd = controller.selection.end;
  }

  void onTextChanged(TextEditingController controller) {
    if (!_enable) { // 可能是在撤销的时候
      return;
    }
    print('=====================onTextChanged');
    String text = controller.text;
    int length = text.length;
    int start = controller.selection.start;
    int end = controller.selection.end;

    // 保存记录
    if (length == preLength) {
      // 一样长，可能是选中后输入
      print('---------------------same-----------------');
      return ;
    } else if (length > preLength) {
      // 输入新内容；也可能是选中后替换为新内容
      print('---------------------insert-----------------');
      int delta = length - preLength;
      preStart = start - delta;
      String src = text.substring(preStart, start);
      undoOpts.add(EditOperator(
          dst: src,
          dstStart: preStart,
          dstEnd: start));
      print(src + '  ' + preStart.toString() + '~' + start.toString());
      redoOpts.clear();
    } else {
      // 变短，比如是删除一部分
      print('---------------------delete-----------------');
      int delta = preLength - length;
      preStart = start;
      preEnd = start + delta;
      print('deletettttte: ' + start.toString() + ' ' + preStart.toString()
      + ' ' + preEnd.toString() + ' ' + delta.toString());
      String dst = preText.substring(preStart, preEnd);
      undoOpts.add(EditOperator(
          src: dst,
          srcStart: preStart,
          srcEnd: preEnd));
      print(dst + '  ' + preStart.toString() + '~' + preEnd.toString());
      redoOpts.clear();
    }

    // 保存至下一次使用
    preText = text;
    preLength = length;
    preStart = start;
    preEnd = end;
  }

  bool undo(TextEditingController controller) {
    if (canUndo()) {
      EditOperator opt = undoOpts.removeLast();
      print('===================================================disable');
      disable();
      opt.undo(controller);
      enable();
      initUndoRedo(controller);
      print('====================================================enable');
      redoOpts.add(opt);
      return true;
    }
    return false;
  }

  bool redo(TextEditingController controller) {
    if (canRedo()) {
      EditOperator opt = redoOpts.removeLast();
      disable();
      opt.redo(controller);
      enable();
      initUndoRedo(controller);
      undoOpts.add(opt);
      return true;
    }
    return false;
  }
}
