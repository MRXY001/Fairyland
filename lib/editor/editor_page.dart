import 'package:fairyland/directory/book_beans.dart';
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
  TextEditingController _textController;

  VCItem currentChapter; // 当前打开的章节

  @override
  void initState() {
    super.initState();

    _textController = new TextEditingController();
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
          value: "append_volume",
          child: Text('添加新卷'),
        ),
        PopupMenuItem<String>(
          value: "book_info",
          child: Text('全书统计'),
          enabled: false,
        ),
        PopupMenuItem<String>(
          value: "book_rename",
          child: Text('修改书名'),
        ),
        PopupMenuItem<String>(
          value: "book_export",
          child: Text('导出作品'),
          enabled: false,
        ),
        PopupMenuItem<String>(
          value: "book_duplicate",
          child: Text('复制作品'),
          enabled: false,
        ),
        PopupMenuItem<String>(
          value: "book_delete",
          child: Text('删除作品'),
        ),
        PopupMenuItem<String>(
          value: "book_settings",
          child: Text('目录设置'),
          enabled: false,
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
    return TextField(
      controller: _textController,
      decoration: new InputDecoration.collapsed(hintText: "正文君"),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      onTap: () => (e) {},
      autofocus: true, // 自动获取焦点
      //      onChanged: ,
    );
  }

  Widget getQuickInputBar() {
    return Row(
      children: <Widget>[
        MaterialButton(
          onPressed: () {},
          child: Text('输入1'),
        ),
        MaterialButton(
          onPressed: () {},
          child: Text('输入2'),
        ),
        MaterialButton(
          onPressed: () {},
          child: Text('输入3'),
        ),
        // TODO: 一排按钮
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
