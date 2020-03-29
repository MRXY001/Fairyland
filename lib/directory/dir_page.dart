import 'package:fairyland/common/global.dart';
import 'package:fairyland/directory/book_beans.dart';
import 'package:fairyland/directory/bookshelf/bookshelf.dart';
import 'package:fairyland/main/my_drawer.dart';
import 'package:fairyland/utils/file_util.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class DirPage extends StatefulWidget {
  DirPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _DirPageState();
  }
}

class _DirPageState extends State<DirPage> {
  XmlDocument catalogXml; // 整个目录树的XML对象
  List<VCItem> vcList; // 当前分卷下的子分卷/子章节的list

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: Builder(
            builder: (BuildContext context) {
              // 获取context后才能跳转页面
              return new GestureDetector(
                child: new Text(Global.currentBookName ?? '创建或切换作品'),
                onTap: () {
                  Navigator.push<String>(context,
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return new Bookshelf();
                  })).then((String result) {
                    if (result.isEmpty) {
                      // 按返回键返回是没有传回的参数的
                      return;
                    }

                    // 判断有没有切换作品
                    if (Global.currentBookName == result) {
                      // 没有切换作品
                      return;
                    }

                    // 读取作品
                    openBook(result);
                  });
                },
              );
            },
          ),
          actions: <Widget>[
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
                  case 'book_new_roll':
                    {}
                    break;
                  default:
                    {}
                    break;
                }
              },
            )
          ]),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: getVolumeAndChapterListView(),
          ),
        ],
      ),
      drawer: MyDrawer.globalDrawer,
    );
  }

  void openBook(String name) {
    print('打开Book：' + name);
    setState(() {
      Global.currentBookName = name;
      catalogXml = null;

      // 判断作品路径
      String path = Global.novelPath + name;
      // 如果目录不存在或者文件有错误，弹出警告
      if (FileUtil.isDirNotExists(path) ||
          FileUtil.isFileNotExist(path + '/catalog.xml')) {
        showDialog(
          builder: (context) => AlertDialog(
            title: Text('无法读取作品：《' + name + '》所在数据'),
            actions: <Widget>[
              FlatButton(
                child: Text('确定'),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
          context: context,
        );
        return;
      }
      // 读取作品目录
    });
  }

  Widget getVolumeAndChapterListView() {
    if (catalogXml == null || vcList == null)
      return new Center(
          child: new Text('↑ ↑ ↑\n请点击上方标题\n创建或切换作品',
              style: TextStyle(fontSize: 20)));
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: vcList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: new Text(vcList[index].name),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return new Divider();
      },
    );
  }
}
