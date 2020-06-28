import 'package:fairyland/common/global.dart';
import 'package:fairyland/editor/novel_ai.dart';
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
  NovelAI ai = new NovelAI();
  OperatorManager undoRedoManager;
  int _systemChanging = 0;

  // 编辑属性
  String _text;
  int _pos;
  int _length;
  int _selectionStart;
  int _selectionEnd;
  bool _textChanged;
  bool _posChanged;
  String _left1, _left2, _left3, _right1;

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
  ///                       状态操作
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

  String deb(String str) {
    print(str);
    return str;
  }

  /// =====================================================
  ///                       事件监听
  /// =====================================================

  /// 当 TextField 内容变化、焦点变动，都会触发
  /// 但是移动光标位置，不一定触发（编辑完再点击会触发）
  /// 并且先于 contentChangedEvent 触发
  void onChangedListener() {}

  /// 点击时触发
  void viewTappedEvent() {}

  /// 纯内容改变时触发
  void contentChangedEvent(String text) {
    deb('contentChanged: ' + text + ' ' + isSystemChanging().toString());
    if (isSystemChanging()) {
      return;
    }

    // 先记录变化
    EditOperator oper = undoRedoManager.onTextChanged(controller);

    // 正在输入的时候生效，并判断输入的内容
    if (oper != null && !isSystemChanging()) {
      //    if (oper == null || oper.isInput()) {
      beginSystemChanging();
      prepareAnalyze();

      // 开始分析
      //      textAnalyze();
      if (oper.isInput()) {
        onTextInput(oper.dst, oper.dstEnd);
      } else if (oper.isDelete()) {
        onTextDeleted(oper.src, oper.srcStart);
      }

      // setText 有个操蛋的问题（也可能是输入法的原因）
      // 会延迟触发 onChanged，而且传的参数又是 setText 之前的旧文本
      // 以及只会触发第二次，不会再三触发……
      // 因此需要想个办法解决
      finishAnalyze();
      endSystemChanging();
    }

    // 保存
    if (onEditSave != null) onEditSave(getText());
    if (onWordsChanged != null) onWordsChanged();
  }

  /// =====================================================
  ///                       用户事件
  /// =====================================================

  /// 文字输入事件
  /// 输入text，修改后的位置为pos（原位置为pos-text.length）
  /// 已经在 SystemChanging 里面，可以任意修改文本
  void onTextInput(String text, int pos) {
    var undoInput = () {
      _deleteText(pos - text.length, pos);
      updateSurround();
    };

    // 检测符号
    if (text.length == 1) {
      if (text == " " && G.us.smartSpace) {
        undoInput();
        _smartSpace();
        return;
      } else if ((text == "“" || text == "”" || text == "\"") &&
          G.us.smartQuote) {
        undoInput();
        activeSmartQuote();
        return;
      } else if (text == "\n" && G.us.smartEnter) {
        undoInput();
        activeSmartEnter();
        return;
      }
    }

    // 自动标点
    if (G.us.autoPunc && _autoPunc()) {
      return;
    }
  }

  /// 文字删除事件
  /// 删掉text，修改后的位置为pos（原位置=pos+text.length）
  /// 已经在 SystemChanging 里面，可以任意修改文本
  void onTextDeleted(String text, int pos) {
    // 删除一个字符（可能是符号）
    if (text.length == 1) {}
  }

  /// =====================================================
  ///                       Editor APIs
  /// =====================================================

  /// 设置文本
  void setText(String text, {undoable: true, pos: -1}) {
    beginSystemChanging();
    controller.text = text;
    if (pos > -1) {
      setPosition(pos);
    }
    if (!undoable) {
      initUndoRedo();
    }
    endSystemChanging();
  }

  /// 获取文本
  String getText() {
    return controller.text;
  }

  /// 获取文本
  /// 如果有选中，则返回选中文本
  /// 如果没有选中，则返回全部文本
  String getSelectionOrFull() {
    if (hasSelection()) {
      return selectionText();
    } else {
      return getText();
    }
  }

  /// 转成纯文本
  String toPlainText() => getText();

  /// 获取光标位置
  int getPosition() {
    return controller.selection.start;
  }

  /// 设置光标位置
  void setPosition(int pos, {aim: -1}) {
    controller.selection = TextSelection.fromPosition(TextPosition(
        affinity: TextAffinity.upstream, // 必须要上游，downstream不行
        offset: pos));
  }

  /// 是否选中了文本
  bool hasSelection() {
    return controller.selection.start != controller.selection.end;
  }

  int selectionStart() {
    return controller.selection.start;
  }

  int selectionEnd() {
    return controller.selection.end;
  }

  String selectionText() {
    _selectionStart = getSelection().start;
    _selectionEnd = getSelection().end;
    _text = controller.text;
    return _text.substring(_selectionStart, _selectionEnd);
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
    _length = _text.length;
    _pos = _selectionStart = getSelection().start;
    _selectionEnd = getSelection().end;
    _textChanged = _posChanged = false;
    updateSurround();
  }
  
  /// 更新光标附近的字符
  /// 通常用于增删光标附近的文字后，更新局部内容
  void updateSurround() {
    _left1 = _pos > 0 ? _text.substring(_pos - 1, _pos) : '';
    _left2 = _pos > 1 ? _text.substring(_pos - 2, _pos - 1) : '';
    _left3 = _pos > 2 ? _text.substring(_pos - 3, _pos - 2) : '';
    _right1 = _pos < _text.length ? _text.substring(_pos, _pos + 1) : '';
  }

  /// 文本分析过程
  /// 自动标点、标点替换、同音词替换、快捷输入等等
  void textAnalyze() {}

  /// 设置本次修改的变化
  bool finishAnalyze() {
    if (_textChanged) {
      setText(_text, pos: _pos);
    } else if (_posChanged) {
      setPosition(_pos);
    }
    return _textChanged;
  }

  void onlyInsertText(String text, {pos: -1}) {
    prepareAnalyze();
    _insertText(text, pos: pos);
    finishAnalyze();
  }

  /// 插入指定文本
  void _insertText(String text, {pos: -1}) {
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
    _length = _text.length;
    _textChanged = true;
  }

  /// 末尾插入指定文本
  void appendText(String text, {newLine: false}) {
    if (newLine && !_text.endsWith('\n')) text = '\n' + text;
    _insertText(text, pos: _text.length);
  }

  /// 删掉指定位置的内容
  void _deleteText(int start, int end) {
    if (_pos >= end) {
      _pos -= (end - start);
    } else if (_pos >= start) {
      _pos = start;
    }
    _text = _text.substring(0, start) + _text.substring(end);
    _length = _text.length;
    _textChanged = true;
  }

  void _moveCursor(int delta) {
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
  /// 键盘事件，检测不到，已废弃
  void onKeyEnterClicked() {}

  /// 空格键事件
  void onKeySpaceClicked() {}

  /// 双引号事件
  void onKeyQuoteClicked() {}

  /// =====================================================
  ///                       小说AI.actions
  /// =====================================================

  void activeAutoPunc() {
    prepareAnalyze();
    _autoPunc();
    finishAnalyze();
  }

  /// 智能空格
  void activeSmartSpace() {
    prepareAnalyze();
    _smartSpace();
    finishAnalyze();
  }

  /// 智能引号
  void activeSmartQuote() {
    prepareAnalyze();
    _smartQuote();
    finishAnalyze();
  }

  /// 智能回车
  void activeSmartEnter() {
    prepareAnalyze();
    _smartEnter();
    finishAnalyze();
  }

  /// =====================================================
  ///                       小说AI.APIs
  /// =====================================================

  /// 自动标点
  /// 如果末尾是语气词，则自动添加标点
  bool _autoPunc() {
    if (!ai.isChinese(_left1) || !ai.isAutoPunc(_left1)) {
      return false;
    }
    // 右边是句子末尾或空的才自动添加标点
    if (_right1 != "”" && _right1 != "\n" && _right1 != "") {
      return false;
    }
    return _insertAIPunc();
  }

  /// 插入标点
  bool _insertAIPunc() {
    String punc;

    if (_left1 == "么") {
      if ("那这怎什多么".contains(_left2)) return false;
      punc = getCursorSentPunc(dot: true);
    } else if (_left1 == "呵") {
      if (_left2 == "呵" && !ai.isChinese(_left3))
        punc = "！";
      else
        return false;
    } else if (_left1 == "哈") {
      if (_left2 == "哈") {
        punc = "！";
      } else
        return false;
    } else if (_left1 == "诶") {
      if (!ai.isChinese(_left2)) {
        punc = "？";
      } else
        return false;
    } else if (_left1 == "呸") {
      if (!ai.isChinese(_left2) || (_left2 == "我" && !ai.isChinese(_left3))) {
        punc = "！";
      } else
        return false;
    } else if (_left1 == "滚") {
      if (!ai.isChinese(_left2)) {
        punc = "！";
      } else
        return false;
    } else {
      // 白名单内的其他词，使用智能获取标点
      punc = getCursorSentPunc(dot: true);
    }
    if (punc.isNotEmpty) {
      _insertText(punc);
      /*ac->addUserWords();
  
      if (punc == "！")
        us->addClimaxValue(true);
      else if (punc == "！")
        us->addClimaxValue(false);*/

      return true;
    }
    return false;
  }

  bool _smartQuote() {
    return false;
  }

  bool _smartSpace() {
    // 先判断黑名单
    bool blackLeft = false, blackRight = false;
    int leftN = _text.lastIndexOf("\n", _pos) + 1;
    String leftText = _text.substring(leftN, _pos);
    int rightN = _text.indexOf("\n", _pos);
    if (rightN == -1) rightN = _text.length;
    String rightText = _text.substring(_pos, rightN);
    if (G.us.smartSpaceSpaceLeft.isNotEmpty &&
        ai.canRegExp(leftText, G.us.smartSpaceSpaceLeft))
      blackLeft = true;
    else if (G.us.smartSpaceSpaceRight.isNotEmpty &&
        ai.canRegExp(rightText, G.us.smartSpaceSpaceRight)) blackRight = true;
    if (blackLeft || blackRight) return false;

    if (_left1 == "" || _left1 == "\n") {
      // 增加缩进
      String insText = "";
      for (int i = 0; i < G.us.indentSpace; i++) insText += "　";
      _insertText(insText);
    } else if (_left1 == "“" && _right1 == "”") {
      // 空的引号中间
      _deleteText(_pos - 1, _pos + 1);
      if (_left2 == "：") {
        _deleteText(_pos - 1, _pos);
      }
      if (ai.isChinese(_left1)) {
        String punc = getPunc();
        _insertText(punc);
        // ac->addUserWords();
      }
    } else if (_right1 == "，") {
      _moveCursor(1);
    } else if (_left1 == "，") {
      // 逗号变句号
      if (_right1 == "“") {
        _moveCursor(1);
      } else {
        _deleteText(_pos - 1, _pos);
        String punc = getPunc2();
        _insertText(punc);
        // ac->addUserWords();

        /*if (punc == "！")
          G.us.addClimaxValue(true);
        else if (punc == "！")
          G.us.addClimaxValue(false);*/
      }
    } else if (ai.isSentPunc(_right1)) {
      // 跳过标点
      _moveCursor(1);
    } else if (ai.isEnglish(_left1) ||
        ai.isNumber(_left1) ||
        ai.isEnglish(_right1) ||
        ai.isNumber(_right1)) {
      _insertText(" ");
    } else if (ai.isASCIIPunc(_left1)) {
      _insertText(" ");
    } else if (ai.isChinese(_left1)) {
      // 添加标点
      if (_right1 == "”") {
        // 判断需不需要插入一个标点
        bool usePunc = true;
        int qPos = _text.lastIndexOf("“", _pos);
        int nPos = _text.lastIndexOf("\n", _pos > 0 ? _pos - 1 : _pos);
        if (qPos > nPos + 1) {
          // 前引号左边是中文时不增加
          String cha = _text.substring(qPos - 1, qPos);
          if (ai.isChinese(cha)) {
            usePunc = false;
          }
        }
        if (usePunc) {
          // 需要插入标点
          String punc = getPunc();
          _insertText(punc);
          // ac->addUserWords();

          /*if (punc == "！")
            G.us.addClimaxValue(true);
          else if (punc == "！")
            G.us.addClimaxValue(false);*/
        } else {
          // 直接跳过引号
          _moveCursor(1);
        }
      } else {
        // 插入一个标点
        String punc = getPunc();
        _insertText(punc);
        // ac->addUserWords();

        /* if (punc == "！")
            	G.us.addClimaxValue(true);
            else if (punc == "！")
            	G.us.addClimaxValue(false); */
      }
    } else if (_right1 == "”") {
      _moveCursor(1);
    } else if (ai.isSentPunc(_left1) &&
        _left1 != "，" &&
        (_right1 != "" && ai.isSymPairRight(_right1))) {
      _moveCursor(1);
    } else if (G.us.spaceQuotes &&
        (_left1 == "　" || ai.isSentPunc(_left1)) &&
        _right1 != "”") {
      // 空格引号
      _insertText("“”");
      _moveCursor(-1);
      // ac->addUserWords(2);
    } else if (ai.isSentPunc(_left1) && _left1 != "，") {
      // 句末标点 变成 逗号，或者跳转
      _deleteText(_pos - 1, _pos);
      _insertText("，");
      // ac->addUserWords();
    } else if (_left1 == "　") {
      _insertText("　");
    } else {
      // 普通空格
      _insertText(" ");
    }
    return true;
  }

  bool _smartEnter() {
    return false;
  }

  /// 获取当前句子的标点
  /// 句号转变为逗号
  String getPunc() => getCursorSentPunc(dot: true);

  /// 获取当前句子的标点
  /// 不使用小段落，强制断句
  String getPunc2() => getCursorSentPunc();

  /// 获取光标所在句子的标点
  String getCursorSentPunc({bool dot: false}) {
    int left = _pos, right = _pos;
    while (left > 0 && _text.substring(left - 1, left) != "\n") {
      left--;
    }
    while (right < _length && _text.substring(right, right + 1) != "\n") {
      right++;
    }
    String para = _text.substring(left, right);
    int pos = _pos;

    // 调AI获取标点
    String punc = ai.getPuncInPara(para, pos);
    if (dot && punc == '。') return '，';
    return punc;
  }

  /// 获取光标所在左边的句子
  /// 如果在句子中间，也只取左边部分，不管右边
  String getCursorFrontSent() {
    int left = _pos;
    while (left > 0 && !ai.isSentSplit(_text.substring(left - 1, left))) {
      left--;
    }
    return _text.substring(left, _pos);
  }

  /// 一键排版
  /// 如果有选中文字，则只排版选中文字
  void activeTypeset() {
    prepareAnalyze();

    // TODO: 一键排版

    finishAnalyze();
  }
}
