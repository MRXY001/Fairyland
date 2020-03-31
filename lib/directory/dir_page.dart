import 'dart:convert';

import 'package:fairyland/common/global.dart';
import 'package:fairyland/directory/book_beans.dart';
import 'package:fairyland/directory/bookshelf/bookshelf.dart';
import 'package:fairyland/main/my_drawer.dart';
import 'package:fairyland/utils/file_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DirPage extends StatefulWidget {
  DirPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _DirPageState();
  }
}

class _DirPageState extends State<DirPage> with AutomaticKeepAliveClientMixin {
  BookObject currentBook;
  List<VCItem> currentRoute = []; // 当前列表所在路径的id集合，一开始length =0
  List<VCItem> currentList; // 当前分卷下的子分卷/子章节的list

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void dependOnInheritedWidgetOfExactType() {
    didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;//要点2

  @override
  Widget build(BuildContext context) {
    // 通过重载 AutomaticKeepAliveClientMixin 的
    // wantKeepAlive 成员，使页面在切换 tab 时不重绘
    super.build(context);
    
    return new Scaffold(
      appBar: new AppBar(
          title: Builder(
            builder: (BuildContext context) {
              // 获取context后才能跳转页面
              return new GestureDetector(
                child: new Text(
                    currentBook == null ? '创建或切换作品' : currentBook.name),
                onTap: () {
                  Navigator.push<String>(context,
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return new Bookshelf();
                  })).then((String result) {
                    if (result == null || result.isEmpty) {
                      // 按返回键返回是没有传回的参数的
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
          _getRouteView(),
          new Expanded(
            child: RefreshIndicator(
              onRefresh: actionSync,
              child: _getVCListView(),
            ),
          ),
        ],
      ),
      drawer: MyDrawer.globalDrawer,
    );
  }

  /// 获取路径分割线的view
  Widget _getRouteView() {
    if (currentRoute == null || currentRoute.length == 0) {
      return new Divider(
        height: 0,
      );
    }
    return new ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 30,
        maxHeight: 30,
      ),
      child: new Padding(
        padding: EdgeInsets.only(left: 16, top: 4, bottom: 4),
        child: new ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: currentRoute.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                enterVolume(currentRoute[index]);
              },
              child: new Text(currentRoute[index].name),
            );
          },
          separatorBuilder: (context, index) {
            return new Text('>', style: TextStyle(color: new Color(0x88888888)),);
          },
      )),
    );
  }

  /// 获取 ListView 整体
  /// 如果为空则显示一个添加按钮
  Widget _getVCListView() {
    if (currentBook == null) {
      return new Center(
          child: new InkWell(
        onTap: () {
          // todo: 点击出现俏皮晃头晃脑动画
        },
        child:
            new Text('↑ ↑ ↑\n请点击上方标题\n创建或切换作品', style: TextStyle(fontSize: 20)),
      ));
    }
    if (currentBook.catalog.length == 0) {
      return new Center(
          child: new InkWell(
        onTap: () => actionAppendChapter(),
        child: new Text('添加分卷', style: TextStyle(fontSize: 20)),
      ));
    }
    return AnimationLimiter( // 这个会报很多警告
      child: ListView.builder(
          itemCount: currentList.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _getVolumeChapterLine(currentList[index]),
                  ),
                ));
          }),
    );
    /*return ListView.separated(
      itemCount: currentList.length,
      itemBuilder: (BuildContext context, int index) {
        return _getVolumeChapterLine(currentList[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return new Divider(height: 2);
      },
    );*/
  }

  /// 获取目录的每一行
  Widget _getVolumeChapterLine(VCItem item) {
    String name = item.name; // item.getDisplayName();
    Image image = Image.asset(item.isVolume()
        ? 'assets/icons/volume.png'
        : 'assets/icons/chapter.png');

    // 显示修改时间
    String timeDisplayed = '';
    if (item.modifyTime ?? 0 > 0) {
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      int delta = timestamp - item.modifyTime;
      if (delta < 60 * 1000) {
        // 一分钟以内
        timeDisplayed = '刚刚';
      } else if (delta < 60 * 60 * 1000) {
        // 一小时以内修改的
        timeDisplayed = (delta ~/ 60000).toString() + ' 分钟前';
      } else if (delta < 24 * 60 * 60 * 1000) {
        // 一天以内
        timeDisplayed = (delta ~/ 3600000).toString() + ' 小时前';
      } else {
        DateTime time = DateTime.fromMillisecondsSinceEpoch(item.modifyTime);
        timeDisplayed = time.toString();
      }
    }
    return new ListTile(
      leading: new Container(
        child: image,
        constraints: BoxConstraints(
            maxWidth: 32, minWidth: 32, minHeight: 32, maxHeight: 32),
      ),
      title: new Text(name, style: TextStyle(fontSize: 16)),
      subtitle: timeDisplayed.isNotEmpty ? new Text(timeDisplayed) : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(item.isVolume()
              ? ((item.vcList != null ? item.vcList.length.toString() : '?') +
                  ' 章')
              : (item.wordCount.toString() + ' 字'))
        ],
      ),
      onTap: () {
        if (item.isVolume()) {
          enterVolume(item);
        } else if (item.isChapter()) {
          openChapter(item);
        }
      },
      onLongPress: () {},
    );
  }

  /// 从头打开作品
  /// 如果已经有打开的了，需要先调用 closeCurrentBook()
  void openBook(String name) {
    print('打开作品:' + name);
    // 如果目录不存在或者文件有错误，弹出警告
    String path = Global.bookPath(name);
    if (FileUtil.isDirNotExists(path) ||
        FileUtil.isFileNotExist(Global.bookCatalogPath(name))) {
      Fluttertoast.showToast(
        msg: '无法读取作品：《' + name + '》所在数据',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
      return;
    }

    // 读取作品目录
    Global.currentBookName = name;
    String str = FileUtil.readText(Global.cBookCatalogPath());
    try {
      // 解析JSON
      currentBook = BookObject.fromJson(json.decode(str));
    } catch (e) {
      Fluttertoast.showToast(msg: '解析目录树错误');
    } finally {
      currentRoute = [];
      currentList = currentBook.catalog;
    }

    setState(() {});
  }

  /// 关闭当前一打开的作品
  /// 并且保存一些状态变量，以便下次打开时恢复
  void closeCurrentBook() {
    Global.currentBookName = currentBook = null;
    currentRoute = null;
    currentList = null;
  }

  /// 添加新的分卷
  void actionAppendVolume() {}

  /// 添加新的章节
  void actionAppendChapter() {
    print('> 添加新章');
    if (currentBook == null) {
      Fluttertoast.showToast(msg: '请点击左上方标题创建一部作品');
      return;
    }

    // 添加新章

    // 保存修改
    saveCatalog();
  }

  /// 保存目录结构
  void saveCatalog() {
    if (currentBook == null) {
      return;
    }
    FileUtil.writeText(
        Global.cBookCatalogPath(), jsonEncode(currentBook.toJson()));
  }

  /// 打开某一分卷，并且加载这一卷的列表
  void enterVolume(VCItem volume) {
    // 遍历路径，如果没有，则表示是点击列表的
    bool inRoute = false;
    currentRoute.forEach((element) {
      if (element & volume) {
        inRoute = true;
      }
    });

    // 是否是当前列表
    bool inList = false;
    currentList.forEach((element) {
      if (element & volume) {
        inList = true;
      }
    });

    // 根据所在位置，判断路径的变化
    if (inRoute) {
      // 路径中，取消route后半部分
      while (currentRoute.length > 0) {
        VCItem last = currentRoute.last;
        currentRoute.removeLast();
        if (last & volume) {
          // 加载前一项
          if (currentRoute.length > 0) {
            volume = currentRoute.last;
          } else {
            volume = null;
          }
          break;
        }
      }
    } else if (inList) {
      // 列表中，加到route末尾
      currentRoute.add(volume);
    } else {
      // 不知道在哪里的，不操作
      return;
    }

    _loadVolume(volume);

    setState(() {});
  }

  /// 加载某一分卷
  void _loadVolume(VCItem volume) {
    // 如果是空的，则表示加载根目录
    if (volume == null) {
      currentList = currentBook.catalog;
    } else {
      currentList = volume.vcList;
    }
  }

  /// 编辑器打开章节
  void openChapter(VCItem chapter) {}
  
  /// 下拉刷新，快捷云同步方式
  Future<void> actionSync() async {
    // 模拟延迟（现在还是什么都不做的）
    await Future.delayed(Duration(seconds: 1), () {
      print('refresh finished');
      setState((){});
    });
  }
}
