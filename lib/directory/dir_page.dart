import 'package:fairyland/common/global.dart';
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
  
}

class _DirPageState extends State<DirPage> {
  
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

  Widget getAppBarTitle() {
    var s = Global.currentBookName ?? '创建或切换作品';
    return Builder(
      builder: (BuildContext context) {
        // 获取context后才能跳转页面
        return new GestureDetector(
          child: new Text(s),
          onTap: () {
            Navigator.push<String>(context,
                new MaterialPageRoute(builder: (BuildContext context) {
                  return new Bookshelf();
                })).then((String result) {
              if (result.isEmpty) {
                // 按返回键返回是没有传回的参数的
                return ;
              }
            
              // 判断有没有切换作品
              if (Global.currentBookName == result) {
                // 没有切换作品
                return ;
              }
            
              // 读取作品
              openBook(result);
            });
          },
        );
      },
    );
  }

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
            value: "book_export",
            child: Text('导出作品'),
          ),
          PopupMenuItem<String>(
            value: "book_duplicate",
            child: Text('暂存作品'),
          ),
          PopupMenuItem<String>(
            value: "book_delete",
            child: Text('删除作品'),
          ),
          PopupMenuItem<String>(
            value: "book_settings",
            child: Text('目录设置'),
          ),
          PopupMenuItem<String>(
            value: "book_recycles",
            child: Text('回收站'),
          ),
        ],
        onSelected: (String value) {
          switch (value) {
            case 'book_new_roll': {
            
            }
            break;
            default: {
            
            }
            break;
          }
        },
      )
    ];
  }

  void openBook(String name) {
    print('打开Book：' + name);
    setState(() {
      Global.currentBookName = name;
      widget.getAppBarTitle();
      widget.getAppBarActions();
    });
  
  }
}
