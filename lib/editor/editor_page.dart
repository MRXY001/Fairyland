import 'dart:convert';

import 'package:fairyland/common/global.dart';
import 'package:fairyland/directory/book_beans.dart';
import 'package:fairyland/editor/chatper_editor.dart';
import 'package:fairyland/editor/editor_interface.dart';
import 'package:fairyland/main/my_drawer.dart';
import 'package:fairyland/utils/file_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zefyr/zefyr.dart';
import 'novel_ai.dart';
import 'package:fairyland/editor/zefyr_editor.dart';
import 'package:quill_delta/quill_delta.dart';

// 输入框教程：https://flutterchina.club/text-input/

// ignore: must_be_immutable
class EditorPage extends StatefulWidget {
  EditorPage({Key key}) : super(key: key) {
    if (!G.us.enableMarkdown) {
      _editController = new TextEditingController();
      editor = chapterEditor = new ChapterEditor(
        controller: _editController,
        onViewTapped: () => chapterEditor.viewTappedEvent(),
        onContentChanged: (text) => chapterEditor.contentChangedEvent(text),
        onEditSave: onEditSave,
      );
    } else {
      final document = _loadDocument();
      _zefyrController = ZefyrController(document);
      _zefyrFocusNode = FocusNode();
      editor = zefyrEditor = new MyZefyrEditor(
        controller: _zefyrController,
        focusNode: _zefyrFocusNode,
        onEditSave: onEditSave,
      );
    }
  }

  EditorInterface editor; // 包含用到的多种编辑器的API
  // 普通编辑器
  TextEditingController _editController;
  ChapterEditor chapterEditor;
  VCItem currentChapter; // 当前打开的章节
  String savedPath;
  _EditPageState myState;

  // Markdown编辑器
  ZefyrEditor zefyrEditor;
  ZefyrController _zefyrController;
  FocusNode _zefyrFocusNode;

  @override
  State<StatefulWidget> createState() {
    return (myState = new _EditPageState());
  }

  /// 打开一个章节
  /// 根据传入的章节对象，获取章节路径，并设置初始值
  void openChapter(VCItem chapter) {
    currentChapter = chapter;
    savedPath = G.rt.cBookChapterPath(chapter.id);
    String content = FileUtil.readText(savedPath);
    if (!G.us.enableMarkdown ||
        !content.startsWith('[') ||
        !content.endsWith(']')) {
      editor.initContent(content);
    } else {
      myState.resetByJson(content);
      //      NotusDocument document = NotusDocument.fromJson(jsonDecode(content));
      //      _zefyrController = ZefyrController(document);
      //      _zefyrFocusNode = FocusNode();
      //      editor = zefyrEditor = new MyZefyrEditor(
      //        controller: _zefyrController,
      //        focusNode: _zefyrFocusNode,
      //        onEditSave: onEditSave,
      //      );
    }
  }

  /// 关闭章节
  void closeChapter() {
    currentChapter = null;
    savedPath = null;
    editor.clear(); // 可撤销
  }

  /// 保存章节
  void onEditSave(String text) {
    if (savedPath != null) {
      FileUtil.writeText(savedPath, text);
    }
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert('Zefyr Quick Start\n');
    return NotusDocument.fromDelta(delta);
  }
}

class _EditPageState extends State<EditorPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            leading: Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu), //自定义图标
                onPressed: () {
                  // 打开抽屉菜单
                  G.rt.mainHomeKey.currentState.openDrawer();
                },
              );
            }),
            title: Text('编辑'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                tooltip: '综合搜索',
                onPressed: () {},
              ),
              getEditMenu()
            ]),
        body: getEditorWidget());
  }

  Widget getEditorWidget() {
    if (widget.chapterEditor != null) {
      return Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (RawKeyEvent event) {
                  // RawKeyDownEvent rawKeyDownEvent = event;
                  RawKeyEventDataAndroid rawKeyEventDataAndroid = event.data;
                  int keyCode = rawKeyEventDataAndroid.keyCode;
                  // print("键盘 keyCode: $keyCode");
                },
                child: Container(child: widget.chapterEditor),
              ),
            ),
          ),
          getQuickInputBar()
        ],
      );
    } else {
      return ZefyrScaffold(child: widget.zefyrEditor);
      /*return Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
              child: ZefyrScaffold(child: widget.zefyrEditor),
            ),
          ),
          getQuickInputBar()
        ],
      );*/
    }
  }

  PopupMenuButton getEditMenu() {
    if (widget.currentChapter == null) {
      return PopupMenuButton<String>(
        itemBuilder: (BuildContext content) => <PopupMenuItem<String>>[
          PopupMenuItem<String>(
            value: "need_chapter",
            child: Text('请从目录打开章节'),
          ),
        ],
        onSelected: (String value) {
          switch (value) {
            case 'need_chapter':
              setState(() {});
              break;
          }
        },
      );
    }
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext content) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: "undo",
          child: Text('撤销'),
          enabled: widget.editor.canUndo(),
        ),
        PopupMenuItem<String>(
          value: "redo",
          child: Text('重做'),
          enabled: widget.editor.canRedo(),
        ),
        PopupMenuItem<String>(
          value: "paste",
          child: Text('粘贴'),
        ),
        PopupMenuItem<String>(
          value: "copy",
          child: Text('一键复制'),
        ),
        PopupMenuItem<String>(
          value: "typeset",
          child: Text('一键排版'),
        ),
        PopupMenuItem<String>(
          value: "word_count",
          child: Text('字数统计'),
        ),
        PopupMenuItem<String>(
          value: "share",
          child: Text('单章分享'),
        ),
      ],
      onSelected: (String value) {
        switch (value) {
          case 'word_count':
            actionWordCount(widget.editor.getSelectionOrFull());
            break;
          case 'undo':
            widget.editor.undo();
            break;
          case 'redo':
            widget.editor.redo();
            break;
          case 'paste':
            actionInsertTextInCursor(
                Clipboard.getData(Clipboard.kTextPlain).toString());
            break;
          case 'copy':
            Clipboard.setData(ClipboardData(text: widget.editor.getText()));
            Fluttertoast.showToast(msg: '复制成功');
            break;
          case 'typeset':
            // TODO: 一键排版
            break;
          case 'share':
            // TODO: 单章分享
            break;
          default:
            {}
            break;
        }
      },
    );
  }

  Widget getQuickInputBar() {
    return Row(
      children: <Widget>[
        // TODO: 快捷输入栏的ListView
        MaterialButton(
          onPressed: () {
            setState(() {
              actionInsertTextInCursor('输入1');
            });
          },
          child: Text('输入1'),
        ),
      ],
    );
  }

  void resetByJson(String content) {
    NotusDocument document = NotusDocument.fromJson(jsonDecode(content));
    widget._zefyrController = ZefyrController(document);
    widget._zefyrFocusNode = FocusNode();
    widget.editor = widget.zefyrEditor = new MyZefyrEditor(
      controller: widget._zefyrController,
      focusNode: widget._zefyrFocusNode,
      onEditSave: widget.onEditSave,
    );

    setState(() {});
  }

  /// 字数统计操作
  void actionWordCount(String text) {
    String result = NovelAI.wordCount(text).toString();
    final popup = BeautifulPopup(
      context: context,
      template: TemplateCoin,
    );
    final newColor = Color.fromARGB(127, 0xFF, 0x82, 0x68);
    popup.recolor(newColor);
    popup.show(title: '字数统计', content: '　　当前字数为：' + result, actions: [
      popup.button(
          label: '确定',
          onPressed: () {
            Navigator.of(context).pop();
          })
    ]);
  }

  /// 在当前光标的位置插入文字
  /// warning: 插入的文字似乎无法撤销
  void actionInsertTextInCursor(String text) {
    setState(() {
      widget.editor.insertTextByPos(text);
    });
  }
}
