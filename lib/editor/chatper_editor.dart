import 'package:fairyland/common/global.dart';
import 'package:fairyland/editor/novel_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'editor_interface.dart';
import 'undo_redo_manager.dart';

// ignore: must_be_immutable
class ChapterEditor extends TextField implements EditorInterface {
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
  String _left1, _left2, _left3, _right1, _right2;

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
  @override
  void initContent(String content) {
    initUndoRedo();

    // 设置文本
    beginSystemChanging();
    setText(content);
    undoRedoManager.enable().initUndoRedo(controller);
    endSystemChanging();
  }

  @override
  void disableContent() {
    beginSystemChanging();
    controller.clear();
    initUndoRedo();
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
    //    print(str);
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
      // 记录新变化至undoRedo，以便于连续的修改（不然变化会断层）
      undoRedoManager.initUndoRedo(controller);
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
      } else if ((text == "“" || text == "”" || text == "‘" || text == "’") &&
          G.us.smartQuote) {
        undoInput();
        _smartQuote();
        return;
      } else if (text == "\n" && G.us.smartEnter) {
        undoInput();
        _smartEnter();
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
  @override
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
  @override
  String getText() {
    return controller.text;
  }

  /// 获取文本
  /// 区别于 selectionText
  /// 如果有选中，则返回选中文本
  /// 如果没有选中，则返回全部文本
  @override
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
  @override
  int getPosition() {
    return controller.selection.start;
  }

  /// 设置光标位置
  @override
  void setPosition(int pos, {aim: -1}) {
    controller.selection = TextSelection.fromPosition(TextPosition(
        affinity: TextAffinity.upstream, // 必须要上游，downstream不行
        offset: pos));
  }

  /// 是否选中了文本
  @override
  bool hasSelection() {
    return controller.selection.start != controller.selection.end;
  }

  @override
  int selectionStart() {
    return controller.selection.start;
  }

  @override
  int selectionEnd() {
    return controller.selection.end;
  }

  @override
  String selectionText() {
    _selectionStart = getSelection().start;
    _selectionEnd = getSelection().end;
    _text = controller.text;
    return _text.substring(_selectionStart, _selectionEnd);
  }

  /// 设置选中范围
  @override
  void setSelection(int start, int end) {
    controller.selection = TextSelection(baseOffset: start, extentOffset: end);
  }

  /// 全选文本
  @override
  void selectAll() {
    setSelection(0, getText().length);
  }

  /// 获取选中情况
  TextSelection getSelection() {
    return controller.selection;
  }

  @override
  void copy() {}

  @override
  void cut() {}

  @override
  void paste() {}

  @override
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
    _right2 =
        _pos < _text.length - 1 ? _text.substring(_pos + 1, _pos + 2) : '';
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

  /// 在指定光标位置插入文字
  /// 任意非计算时都可调用
  @override
  void insertTextByPos(String text, {pos: -1}) {
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
  @override
  void saveToFile(String path) {}

  /// 从文件读入
  @override
  void loadFromFile(String path) {}

  /// =====================================================
  ///                       撤销重做
  /// =====================================================

  @override
  void undo() {
    undoRedoManager.undo(controller);
  }

  @override
  void redo() {
    undoRedoManager.redo(controller);
  }

  @override
  void initUndoRedo() {
    undoRedoManager.clearUndoRedo();
  }

  @override
  bool canUndo() => undoRedoManager.canUndo();

  @override
  bool canRedo() => undoRedoManager.canRedo();

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

  void _smartQuote() {
    // 判断是否为人物的第二句话（即双引号前面是逗号而不是冒号）
    bool isSecondSaid = false;
    if (ai.isChinese(_left1) ||
        _left1 == "“" ||
        _right1 == "“" ||
        _right2 == "“") {
      int pos = _pos;
      if (pos > 4) {
        if (pos == _text.length || _text.substring(pos, pos + 1) == "\n") pos--;
        int nPos = _text.lastIndexOf("\n", pos);
        if (nPos == -1) nPos = 0;
        if (_left1 == "”")
          pos -= 2;
        else if (_right1 == "”") pos--;
        int qPos = _text.lastIndexOf("”", pos);
        if (qPos > nPos) // 前面有对双引号
        {
          int i = qPos;
          bool isSent = true;
          while (++i < pos) {
            String cha = _text.substring(i, i + 1);
            if (ai.isSentPunc(cha)) // 句中标点，不是连续的话，就没有必要用逗号了
            {
              isSent = false;
              break;
            }
          }
          if (isSent) {
            isSecondSaid = true;
          }
        }
      }
    }

    // 左右前后引号的位置
    int qll, qlr, qrl, qrr, nl, nr;
    qll = _text.lastIndexOf("“", _pos);
    qlr = _text.lastIndexOf("”", _pos);
    qrl = _text.indexOf("“", _pos);
    qrr = _text.indexOf("”", _pos);
    nl = _text.lastIndexOf("\n", _pos);
    nr = _text.indexOf("\n", _pos);
    if (nl > -1 && qll < nl) qll = -1;
    if (nl > -1 && qlr < nl) qlr = -1;
    if (nr > -1 && qrl > nr) qrl = -1;
    if (nr > -1 && qrr > nr) qrr = -1;
    bool isInQuotes = qlr > qrr;

    // ==== 分析标点 ====
    if (_left1 == "“") {
      // ，“|    ：“|    汉“|    “|”    “|
      if (_left2 == "，") {
        _deleteText(_pos - 2, _pos - 1);
        _insertText("：", pos: _pos - 1);
        // ac->addUserWords();
      } else if (_left2 == "：") {
        _deleteText(_pos - 2, _pos - 1);
      } else if (ai.isChinese(_left2)) {
        _insertText("：", pos: _pos - 1);
        // ac->addUserWords();
      } else if (_right1 == "”") {
        // 空引号
        if (ai.isBlankChar(_left2) ||
            ai.isBlankChar(_right2)) if (_left2 == "，" || _left2 == "：")
          _deleteText(_pos - 2, _pos);
        else
          _deleteText(_pos - 1, _pos + 1);
        else
          _deleteText(_pos - 1, _pos);
      } else if (ai.isBlankChar(_right1)) {
        _insertText("”");
        _moveCursor(-1);
        // ac->addUserWords();
      } else {
        _moveCursor(-1);
      }
    } else if (_left1 == "”") {
      // 。”|    汉”|     ”|
      if (ai.isSentPunc(_left2)) {
        _deleteText(_pos - 2, _pos - 1);
        _moveCursor(-1);
      } else if (ai.isChinese(_left2)) {
        String punc = getCursorSentPunc(pos: _pos - 1);
        _insertText(punc, pos: _pos - 1);
        // ac->addUserWords();
      } else {
        int lPos = _pos - 1;
        bool isOperator = false;
        while (lPos-- > 0 && _text.substring(lPos, lPos + 1) != "\n")
          if (_text.substring(lPos, lPos + 1) == "“") {
            // 有前引号，则只是移动位置
            _moveCursor(-1);
            isOperator = true;
            break;
          } else if (_text.substring(lPos, lPos + 1) == "”") break;
        if (!isOperator) {
          // 如果什么都没有操作，可能前面就是空的内容，补全一个前引号
          _moveCursor(-1);
          _insertText("“");
          // ac->addUserWords();
        }
      }
    } else if (_right1 == "“") {
      // 汉|“    ，|“    ：|“    |“
      if (ai.isChinese(_left1)) {
        if (isSecondSaid) {
          _insertText("，");
          // ac->addUserWords();
        } else {
          _insertText("：");
          // ac->addUserWords();
        }
        if (_right2 == "”") {
          _moveCursor(1);
        }
      } else if (_left1 == "，") {
        _deleteText(_pos - 1, _pos);
        _insertText("：");
        if (_right2 == "”") {
          _moveCursor(1);
        }
      } else if (_left1 == "；") {
        _deleteText(_pos - 1, _pos);
      } else if (ai.isBlankChar(_left1)) {
        _moveCursor(1);
      } else {
        _moveCursor(1);
      }
    } else if (_right1 == "”") {
      // 汉|”    。|”    ，|”
      if (ai.isChinese(_left1)) {
        bool usePunc = true;
        int qPos = _text.lastIndexOf("“", _pos);
        int nPos = _text.lastIndexOf("\n", _pos);
        if (qPos > nPos + 1) {
          // 前引号左边是中文时不增加标签
          String cha = _text.substring(qPos - 1, qPos);
          if (ai.isChinese(cha)) {
            usePunc = false;
          }
        }
        if (usePunc) // 需要插入标点
        {
          _insertText(getPunc2());
          // ac->addUserWords();
        }
        _moveCursor(1);
      } else if (_left1 == "。") {
        _moveCursor(1);
      } else if (_left1 == "，") {
        _deleteText(_pos - 1, _pos);
        _insertText(getPunc2());
        _moveCursor(1);
      } else {
        _moveCursor(1);
      }
    } else if (qll <= qlr && qrl == -1 && qrr != -1) {
      // 缺 前引号
      _insertText("“");
      // ac->addUserWords();
    } else if (qll <= qlr && qrl > -1 && qrl > qrr) {
      // 缺 前引号
      _insertText("“");
      // ac->addUserWords();
    } else if (qll > qlr && qrl > -1 && qrr > qrl) {
      // 缺 后引号
      if (ai.isChinese(_left1)) {
        if (ai.isSentPunc(_right1) && ai.isBlankChar(_right2))
          _moveCursor(1);
        else {
          _insertText(getPunc2());
          // ac->addUserWords();
        }
      }
      _insertText("”");
      // ac->addUserWords();
    } else if (qll > qlr && qrr == -1) {
      // 缺 后引号
      if (ai.isChinese(_left1)) {
        if (ai.isSentPunc(_right1) && ai.isBlankChar(_right2))
          _moveCursor(1);
        else {
          _insertText(getPunc2());
          // ac->addUserWords();
        }
      } else if (_left1 == "，") {
        // 句子结尾
        _deleteText(_pos - 1, _pos);
        _insertText(getPunc2());
        // ac->addUserWords();
      }
      _insertText("”");
      // ac->addUserWords();
    } else if (isInQuotes) {
      // 添加或者删除单引号
      qll = _text.lastIndexOf("‘", _pos);
      qlr = _text.lastIndexOf("’", _pos);
      qrl = _text.indexOf("‘", _pos);
      qrr = _text.indexOf("’", _pos);
      nl = _text.lastIndexOf("\n", _pos);
      nr = _text.indexOf("\n", _pos);
      if (nl > -1 && qll < nl) qll = -1;
      if (nl > -1 && qlr < nl) qlr = -1;
      if (nr > -1 && qrl > nr) qrl = -1;
      if (nr > -1 && qrr > nr) qrr = -1;

      if (_right1 == "’" || _right1 == "‘" || _right1 == "'") {
        _moveCursor(1);
      } else if (_left1 == "‘" || _left1 == "’") {
        _moveCursor(-1);
      } else if (qll <= qlr && qrl == -1 && qrr != -1) {
        // 缺 前引号
        _insertText("‘");
        // ac->addUserWords();
      } else if (qll <= qlr && qrl > -1 && qrl > qrr) {
        // 缺 前引号
        _insertText("‘");
        // ac->addUserWords();
      } else if (qll > qlr && qrl > -1 && qrr > qrl) {
        // 缺 后引号
        _insertText("’");
        // ac->addUserWords();
      } else if (qll > qlr && qrr == -1) {
        // 缺 后引号
        if (_left1 == "，") {
          _deleteText(_pos - 1, _pos);
          _insertText(getPunc2());
          // ac->addUserWords();
        }
        _insertText("’");
        // ac->addUserWords();
      } else {
        _insertText("‘’");
        _moveCursor(-1);
        // ac->addUserWords();
      }
    } else if (_left1 == "，") {
      // ，|
      _insertText("“”");
      _moveCursor(-1);
      // ac->addUserWords();
    } else if (_left1 == "：") {
      // ：|
      _insertText("“”");
      _moveCursor(-1);
      // ac->addUserWords();
    } else if (_right1 == "，" && _right2 == "“") {
      // |，“
      _deleteText(_pos, _pos + 1);
      _insertText("：");
      // ac->addUserWords();
    } else if (_right1 == "：" && _right2 == "“") {
      // |：“
      _deleteText(_pos, _pos + 1);
    } else if (ai.isChinese(_left1)) {
      // 汉|    =>    汉：“”    汉，“”    汉“”
      if (ai.isQuoteColon(_left1)) {
        if (isSecondSaid)
          _insertText("，");
        else
          _insertText("：");
        // ac->addUserWords();
      }
      _insertText("“”");
      _moveCursor(-1);
      // ac->addUserWords();
    } else {
      _insertText("“”");
      _moveCursor(-1);
      // ac->addUserWords(2);
    }
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

  void _smartEnter() {
    bool blankLineCut = false; // 空行后面暂时减少一行

    // ==== 删除前后空白 ====
    int blankStart = _pos, blankEnd = _pos;
    while (blankStart > 0 &&
        ai.isBlankChar2(_text.substring(blankStart - 1, blankStart)))
      blankStart--;
    while (blankEnd < _text.length &&
        ai.isBlankChar2(_text.substring(blankEnd, blankEnd + 1))) blankEnd++;
    if (blankEnd > blankStart) _deleteText(blankStart, blankEnd);

    // ==== 智能引号 ====
    if (_left1 == "“" && _right1 == "”") {
      // 空的双引号中间，删除
      _deleteText(_pos - 1, _pos + 1);
      updateSurround();
      if (_left1 == "，" || _left1 == "：") {
        _deleteText(_pos - 1, _pos);
      }
      updateSurround();
      if (ai.isChinese(_left1)) {
        String punc = getPunc2();
        _insertText(punc);
        // ac->addUserWords();
      }
    } else if (_left1 == "“" || _right1 == "“") {
      // 左1 是 前引号
      if (_left1 == "“") {
        _moveCursor(-1);
        updateSurround();
      }
      if (ai.isChinese(_left1)) {
        // 中文|”“
        _insertText(":");
        // ac->addUserWords();
      } else if (_left1 == "，") {
        // 中文，|”“
        _deleteText(_pos - 1, _pos);
        _insertText(":");
        // ac->addUserWords();
      }
    } else if (ai.isChinese(_left1) ||
        (_left1 == "，" && ai.isChinese(_left2))) {
      // 左1 是中文
      if (_left1 == "，") {
        // 逗号变成句末标点，先删除
        _deleteText(_pos - 1, _pos);
        updateSurround();
      }
      if (ai.isSentPunc(_right1)) {
        // 右1是句末标点，移动一位
        _moveCursor(1);
        if ("-—…~".indexOf(_right1) > -1 && _right1 == _right2) {
          // 双标点，继续移动一位
          _moveCursor(1);
        }
        updateSurround();
      } else {
        // 添加一个标点
        bool enablePunc = true;
        if (G.us.smartEnterNoPunc.isNotEmpty) {
          int leftN = _text.lastIndexOf("\n", _pos - 1) + 1;
          String para = _text.substring(leftN, _pos);
          if (ai.canRegExp(para, G.us.smartEnterNoPunc)) enablePunc = false;
        }

        if (enablePunc) {
          String punc = getPunc2();
          _insertText(punc);
          // ac->addUserWords();

          /* if (punc == "！")
                    G.us.addClimaxValue(true);
                else if (punc == "。" || punc == "？")
                    G.us.addClimaxValue(false); */
        }
      }
    } else if (_left2 != "\n" && _left1 == "\n" && ai.isBlankChar(_right1)) {
      // 段落下一行的空行，很可能是不小心点错了位置
      blankLineCut = true;
    } else if (_right1 != "" &&
        ai.isSymPairRight(_right1) &&
        (_right2 == "" || _right2 == "\n")) {
      _moveCursor(1);
      updateSurround();
    }

    // ==== 跳过还是填充引号 ====
    if (_right1 == "”") {
      // 右1 是 右引号
      _moveCursor(1);
    } else if (isCursorInQuote(_text, _pos)) {
      // 自动填充双引号
      if (G.us.paraAfterQuote) // 多段后引号：插入后引号
        _insertText("”“");
      else // 只插入前引号
        _insertText("“");
      _moveCursor(-1);
      // ac->addUserWords();
    }

    // ==== 修改缩进 ====
    String insText = "";
    int blankLineNum = G.us.indentLine;
    if (blankLineCut && blankLineNum > 0) blankLineNum--;
    for (int i = 0; i <= blankLineNum; i++) insText += "\n";
    for (int i = 0; i < G.us.indentSpace; i++) insText += "　";
    _insertText(insText);
  }

  /// 获取当前句子的标点
  /// 句号转变为逗号
  String getPunc() => getCursorSentPunc(dot: true);

  /// 获取当前句子的标点
  /// 不使用小段落，强制断句
  String getPunc2() => getCursorSentPunc();

  /// 获取光标所在句子的标点
  String getCursorSentPunc({bool dot: false, int pos: -1}) {
    if (pos == -1) {
      pos = _pos;
    }
    int left = pos, right = pos;
    while (left > 0 && _text.substring(left - 1, left) != "\n") {
      left--;
    }
    while (right < _length && _text.substring(right, right + 1) != "\n") {
      right++;
    }
    String para = _text.substring(left, right);

    // 调AI获取标点
    String punc = ai.getPuncInPara(para, pos - left);
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

  /// 光标是否在引号内
  bool isCursorInQuote(String text, int pos) {
    if (pos > 0 && text.substring(pos - 1, pos) == "“") return true;
    if (pos < text.length && text.substring(pos, pos + 1) == "”") return true;

    // 获取段落的文本
    int lPos = text.lastIndexOf("\n", pos);
    int rPos = text.indexOf("\n", pos);
    // if (l_pos == -1) l_pos = 0;
    lPos++; // 不包括第一个前引号
    if (rPos == -1) rPos = text.length;
    if (rPos - lPos < 2) return false;
    text = text.substring(lPos, rPos);
    pos -= lPos;

    // 搜索左右两边的最近的前后引号
    int llPos = text.lastIndexOf("“", pos);
    int lrPos = text.lastIndexOf("”", pos);
    int rlPos = text.indexOf("“", pos);
    int rrPos = text.indexOf("”", pos);
    if (llPos == -1) return false; // 没有前引号
    if (rrPos == -1) return false; // 没有后引号
    if (llPos <= lrPos) return false; // “”|
    if (rlPos > -1 && rlPos < rrPos) return false; // |“”
    //if (lr_pos < ll_pos && rl_pos <= rr_pos) return true; // 接着前引号，但是没有后引号

    return true;
  }

  /// 一键排版
  /// 如果有选中文字，则只排版选中文字
  void activeTypeset() {
    prepareAnalyze();

    // TODO: 一键排版

    finishAnalyze();
  }
}
