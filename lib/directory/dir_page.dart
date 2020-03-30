import 'package:fairyland/common/global.dart';
import 'package:fairyland/directory/book_beans.dart';
import 'package:fairyland/directory/bookshelf/bookshelf.dart';
import 'package:fairyland/main/my_drawer.dart';
import 'package:fairyland/utils/file_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xml/xml.dart' as xml;

class DirPage extends StatefulWidget {
  DirPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _DirPageState();
  }
}

class _DirPageState extends State<DirPage> {
  String currentBookName;
  xml.XmlDocument catalogXml; // 整个目录树的XML对象
  xml.XmlElement currentXml; // 当前所在的element，用来操作增删改查等
  List<VCItem> catalogTree; // 整个目录下的分卷/章节的list
  List<xml.XmlElement> currentRoute = []; // 当前列表所在路径，一开始length =0
  List<VCItem> currentList; // 当前分卷下的子分卷/子章节的list

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
                    closeCurrentBook();
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
              onPressed: () => actionAppendChapter(),
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

  /// 获取 ListView
  Widget getVolumeAndChapterListView() {
    if (catalogXml == null || currentList == null) {
      return new Center(
        // todo: 点击出现俏皮晃头晃脑动画
          child: new Text('↑ ↑ ↑\n请点击上方标题\n创建或切换作品',
              style: TextStyle(fontSize: 20)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: currentList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: new Text(currentList[index].name),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return new Divider();
      },
    );
  }

  /// 从头打开作品
  /// 如果已经有打开的了，需要先调用 closeCurrentBook()
  void openBook(String name) {
    print('打开作品:' + name);
    // 如果目录不存在或者文件有错误，弹出警告
    String path = Global.booksPath + name + '/';
    if (FileUtil.isDirNotExists(path) ||
        FileUtil.isFileNotExist(path + 'catalog.xml')) {
      Fluttertoast.showToast(
        msg: '无法读取作品：《' + name + '》所在数据',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
      return;
    }

    // 读取作品目录
    Global.currentBookName = currentBookName = name;
    currentRoute = [];
    String str = FileUtil.readText(path + 'catalog.xml');
    try {
      catalogXml = xml.parse(str);
      currentXml = catalogXml.findElements('BOOK').first;
      catalogTree = getVCItemsFromXml(
          currentXml.children.whereType<xml.XmlElement>().toList());
      currentList = catalogTree;
    } catch (e) {
      Fluttertoast.showToast(msg: '解析目录树错误');
    }

    setState(() {});
  }

  /// 递归获取分卷/章节列表
  List<VCItem> getVCItemsFromXml(List<xml.XmlElement> elements) {
    List<VCItem> vcItems = [];
    int indexInList = 1;
    elements.forEach((element) {
      if (element.toString().trim().isEmpty) return;
      VCItem item;

      // 遍历单独数据
      if (element.name.toString() == 'VOLUME') {
        // 读取分卷信息，继续遍历
        item = new VolumeItem();
        item.isChapter = false;
        (item as VolumeItem).vcList = getVCItemsFromXml(
            element.children.whereType<xml.XmlElement>().toList());

        // 读取分卷属性
        element.attributes.forEach((xml.XmlAttribute attr) {
          if (attr.name.toString() == "vid") {
            (item as VolumeItem).vid = attr.value.toString();
          }
        });
      } else if (element.name.toString() == 'CHAPTER') {
        // 读取章节信息
        item = new ChapterItem();
        item.isChapter = true;
        (item as ChapterItem).cid = element.text;

        // 读取章节属性
        element.attributes.forEach((xml.XmlAttribute attr) {
          if (attr.name.toString() == "cid") {
            (item as ChapterItem).cid = attr.value.toString();
          } else if (attr.name.toString() == "wc") {
            (item as ChapterItem).wordCount = int.parse(attr.value.toString());
          }
        });
      } else {
        // 出现了奇怪的标签
        return;
      }

      // 遍历所有共有固定属性
      element.attributes.forEach((xml.XmlAttribute attr) {
        if (attr.name.toString() == "name") {
          item.name = attr.value.toString();
        }
      });

      // 遍历所有共有列表属性
      item.indexInList = indexInList++;

      vcItems.add(item);
    });
    return vcItems;
  }

  /// 关闭当前一打开的作品
  /// 并且保存一些状态变量，以便下次打开时恢复
  void closeCurrentBook() {
    Global.currentBookName = currentBookName = null;
    catalogXml = null;
    currentXml = null;
    currentRoute = null;
    currentList = null;
  }
  
  /// 添加新的分卷
  void actionAppendVolume() {
  
  }
  
  /// 添加新的章节
  void actionAppendChapter() {
    print('> 添加新章');
    if (currentBookName==null || currentBookName.isEmpty) {
      Fluttertoast.showToast(msg: '请点击左上方标题创建一部作品');
      return ;
    }
    
    // 添加新章
    
    
    print(currentXml.toString());
  }
  
  /// 保存目录为XML
  void saveCatalog() {
  
  }
}
