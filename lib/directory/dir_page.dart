import 'package:fairyland/directory/bookshelf/bookshelf.dart';
import 'package:fairyland/main/my_main_page.dart';
import 'package:flutter/material.dart';
import 'chapter_list.dart';

class DirPage extends MainPageBase {
  DirPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _DirPageState();
  }

  @override
  Widget getAppBarTitle() {
    var s = _DirPageState.currentNovelName;
    if (s.isEmpty) s = '目录';
    return Builder(
      builder: (BuildContext context) {
        // 获取context后才能跳转页面
        return new GestureDetector(
          child: new Text(s),
          onTap: () {
            Navigator.push<String>(context,
                new MaterialPageRoute(builder: (BuildContext context) {
              return new Bookshelf();
            })).then((value) => (String result) {});
          },
        );
      },
    );
  }

  @override
  List<Widget> getAppBarActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        tooltip: '添加新章',
        onPressed: () {},
      ),
      PopupMenuButton<String>(
        itemBuilder: (BuildContext content) => <PopupMenuItem<String>>[
          PopupMenuItem<String>(
            value: "book_new_roll",
            child: Text('添加新卷'),
          ),
          PopupMenuItem<String>(
            value: "book_info",
            child: Text('全书统计'),
          ),
          PopupMenuItem<String>(
            value: "book_rename",
            child: Text('修改书名'),
          ),
          PopupMenuItem<String>(
            value: "book_delete",
            child: Text('删除作品'),
          ),
          PopupMenuItem<String>(
            value: "book_export",
            child: Text('导出作品'),
          ),
          PopupMenuItem<String>(
            value: "book_settings",
            child: Text('目录设置'),
          ),
          PopupMenuItem<String>(
            value: "book_duplicate",
            child: Text('复制作品'),
          ),
          PopupMenuItem<String>(
            value: "book_recycles",
            child: Text('回收站'),
          ),
        ],
      )
    ];
  }
}

class _DirPageState extends State<DirPage> {
  static String currentNovelName = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Column(
      children: <Widget>[
        new Expanded(
          child: new ExpansionPanelPage(),
        ),
      ],
    ));
  }
}
