import 'package:fairyland/directory/book_beans.dart';
import 'package:fairyland/editor/chatper_editor.dart';
import 'package:fairyland/main/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class EditorPage extends StatefulWidget {
  EditorPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _EditPageState();
  }
}

class _EditPageState extends State<EditorPage> {
  TextEditingController _editController;

  VCItem currentChapter; // 当前打开的章节

  @override
  void initState() {
    super.initState();
    
    _editController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer.globalDrawer,
        appBar: new AppBar(title: Text('编辑'), actions: <Widget>[
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
                child: getChapterEditor(),
              ),
            ),
            getQuickInputBar()
          ],
        ));
  }

  PopupMenuButton getEditMenu() {
    if (currentChapter == null) {
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
              break;
          }
        },
      );
    }
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext content) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: "word_count",
          child: Text('字数统计'),
        ),
      ],
      onSelected: (String value) {
        switch (value) {
          default:
            {}
            break;
        }
      },
    );
  }

  Widget getChapterEditor() {
    // 输入框教程：https://flutterchina.club/text-input/
    return ChapterEditor(controller: _editController);
  }

  Widget getQuickInputBar() {
    return Row(
      children: <Widget>[
        // TODO: 快捷输入栏的ListView
        MaterialButton(
          onPressed: () {
            setState(() {
              print(_editController.selection.start);
              print(_editController.selection.end);
              
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
