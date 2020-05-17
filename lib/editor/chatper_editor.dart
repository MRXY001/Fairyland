import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'undo_redo_manager.dart';

// ignore: must_be_immutable
class ChapterEditor extends TextField {
  // 控制器
  final TextEditingController controller;
  final onViewTapped;
  final onContentChanged;
  final onEditSave;
  final onWordsChanged;
  OperatorManager undoRedoManager;
  int _systemChanging = 0;

  // 编辑属性
  String _text;
  int _pos;
  int _selectionStart;
  int _selectionEnd;
  bool _textChanged;
  bool _posChanged;

  ChapterEditor(
      {this.controller,
      this.onViewTapped,
      this.onContentChanged,
      this.onWordsChanged,
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
    _systemChanging++;
  }

  /// 结束系统批量改变
  void endSystemChanging() {
    _systemChanging--;
    if (_systemChanging < 0) {
      _systemChanging = 0;
    }
  }

  /// 是否是系统引起的变化
  bool isSystemChanging() => _systemChanging > 0;

  /// =====================================================
  ///                       原生事件
  /// =====================================================

  /// 当 TextField 内容变化、焦点变动，都会触发
  /// 但是移动光标位置，不一定触发（编辑完再点击会触发）
  /// 并且先于 contentChangedEvent 触发
  void onChangedListener() {}

  /// 点击时触发
  void viewTappedEvent() {}

  /// 纯内容改变时触发
  void contentChangedEvent(String text) {
    if (isSystemChanging()) {
      return;
    }
    // 判断输入的内容
    beginSystemChanging();
    prepareAnalyze();

    // 开始分析
    insertText('o');

    finishAnalyze();
    endSystemChanging();

    // 保存
    undoRedoManager.onTextChanged(controller);
    if (onEditSave != null) onEditSave(getText());
    if (onWordsChanged != null) onWordsChanged();
  }

  /// =====================================================
  ///                       整体操作
  /// =====================================================

  /// 设置文本
  void setText(String text, {undoable: true, pos: -1}) {
    beginSystemChanging();
    controller.text = text;
    if (pos > -1) {
      setPosition(pos);
    }
    if (!undoable) {
      clearUndoRedo();
      initUndoRedo();
    }
    endSystemChanging();
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

  /// 设置光标位置
  void setPosition(int pos, {aim: -1}) {
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: pos));
  }

  /// 是否选中了文本
  bool hasSelection() {
    return controller.selection.start != controller.selection.end;
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

  void clear() {
    setText('');
  }

  /// =====================================================
  ///                       修改操作
  /// =====================================================

  /// 捕获编辑器所有数据
  void prepareAnalyze() {
    _text = getText();
    _selectionStart = _pos = getSelection().start;
    _selectionEnd = getSelection().end;
    _textChanged = _posChanged = false;
  }

  /// 设置本次修改的变化
  void finishAnalyze() {
    if (_textChanged) {
      setText(_text, pos: _pos);
    } else if (_posChanged) {
      setPosition(_pos);
    }
  }

  /// 插入指定文本
  void insertText(String text, {pos: -1}) {
    if (pos == -1) {
      // 使用光标位置
      pos = _pos;
      // 清除选中内容
      if (_selectionStart != _selectionEnd) {
        pos = controller.selection.start;
        text = text.substring(0, controller.selection.start) +
            text.substring(controller.selection.end);
        _selectionStart = _selectionEnd = _pos;
      }
    }
    _text = _text.substring(0, pos) + text + _text.substring(pos);
    if (_pos >= pos) {
      _pos += text.length;
    }
    _textChanged = true;
  }

  /// 末尾插入指定文本
  void appendText(String text, {newLine: false}) {
    if (newLine && !_text.endsWith('\n')) text = '\n' + text;
    insertText(text, pos: _text.length);
  }

  /// 删掉指定位置的内容
  void removeText(int start, int end) {
    if (_pos >= end) {
      _pos -= (end - start);
    } else if (_pos >= start) {
      _pos = start;
    }
    _text = _text.substring(0, start) + _text.substring(end);
    _textChanged = true;
  }

  void movePos(int delta) {
    _pos = _pos + delta;
    if (_pos < 0) {
      _pos = 0;
    } else if (_pos > _text.length) {
      _pos = _text.length;
    }
    _posChanged = true;
  }

  /// =====================================================
  ///                       文件操作
  /// =====================================================

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
  
  /// 智能引号
  void activeSmartQuote() {
  
  }
  
  /// 智能空格
  void activeSmartSpace() {
  
  }
  
  /// 智能回车
  void activeSmartEnter() {
  
  }
  
  /// 自动标点
  bool activeAutoPunc() {
    
    
    return false;
  }
}
