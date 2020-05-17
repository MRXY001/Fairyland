import 'package:fairyland/common/global.dart';
import 'package:fairyland/directory/book_beans.dart';
import 'package:fairyland/editor/chatper_editor.dart';
import 'package:fairyland/main/my_drawer.dart';
import 'package:fairyland/utils/file_util.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

// 输入框教程：https://flutterchina.club/text-input/

// ignore: must_be_immutable
class EditorPage extends StatefulWidget {
  EditorPage({Key key}) : super(key: key) {
    _editController = new TextEditingController();
    chapterEditor = new ChapterEditor(
      controller: _editController,
      onViewTapped: () => chapterEditor.viewTappedEvent(),
      onContentChanged: (text) => chapterEditor.contentChangedEvent(text),
      
      onEditSave: onEditSave,
    );
  }

  TextEditingController _editController;
  ChapterEditor chapterEditor;
  VCItem currentChapter; // 当前打开的章节
  String savedPath;
  State<StatefulWidget> myState;

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
    chapterEditor.initContent(content);
  }

  /// 关闭章节
  void closeChapter() {
    currentChapter = null;
    savedPath = null;
    chapterEditor.clear(); // 可撤销
  }

  /// 保存章节
  void onEditSave(String text) {
    if (savedPath != null) {
      FileUtil.writeText(savedPath, text);
    }
  }
}

class _EditPageState extends State<EditorPage> {
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
        body: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                child: widget.chapterEditor,
              ),
            ),
            getQuickInputBar()
          ],
        ));
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
          enabled: widget.chapterEditor.undoRedoManager.canUndo(),
        ),
        PopupMenuItem<String>(
          value: "redo",
          child: Text('重做'),
          enabled: widget.chapterEditor.undoRedoManager.canRedo(),
        ),
        PopupMenuItem<String>(
          value: "word_count",
          child: Text('字数统计'),
        ),
      ],
      onSelected: (String value) {
        switch (value) {
          case 'word_count':
            break;
          case 'undo':
            widget.chapterEditor.undo();
            break;
          case 'redo':
            widget.chapterEditor.redo();
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
              widget.chapterEditor.insertText('输入1');
            });
          },
          child: Text('输入1'),
        ),
      ],
    );
  }
}

class _ZefyrState extends State<EditorPage> {
  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('编辑'),
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(16),
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),
    );
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert('Zefyr Quick Start\n');
    return NotusDocument.fromDelta(delta);
  }

  void save() {}
}
