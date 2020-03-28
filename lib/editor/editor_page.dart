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

}