import 'dart:convert';
import 'package:fairyland/common/global.dart';
import 'package:fairyland/common/user_setting.dart';
import 'package:fairyland/directory/book_beans.dart';
import 'package:fairyland/directory/bookshelf/bookshelf.dart';
import 'package:fairyland/utils/file_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class DirPage extends StatefulWidget {
  BookObject currentBook;
  List<VCItem> currentRoute = []; // 当前列表所在路径的id集合，一开始length =0
  List<VCItem> currentList; // 当前分卷下的子分卷/子章节的list

  final openBookCallback;
  final renameBookCallback;
  final closeBookCallback;
  final openChapterCallback;
  final renameChapterCallback;
  final deleteChapterCallback;

  _DirPageState myState;

  DirPage(
      {Key key,
      this.openBookCallback,
      this.renameBookCallback,
      this.closeBookCallback,
      this.openChapterCallback,
      this.renameChapterCallback,
      this.deleteChapterCallback})
      : super(key: key) {
    _initRecent();
  }

  @override
  State<StatefulWidget> createState() {
    return myState = new _DirPageState();
  }

  void updateState() {
    if (myState != null) {
      // ignore: invalid_use_of_protected_member
      myState.setState(() {});
    }
  }

  void _initRecent() {
    // 恢复上次打开的作品
    String bookName = G.us.getConfig('recent/book_name', '');
    if (bookName.isNotEmpty && FileUtil.isDirExists(G.rt.bookPathD(bookName))) {
      openBook(bookName);
    }
  }

  /// 从头打开作品
  /// 如果已经有打开的了，需要先调用 closeCurrentBook()
  void openBook(String name) {
    // 如果目录不存在或者文件有错误，弹出警告
    String path = G.rt.bookPathD(name);
    if (FileUtil.isDirNotExists(path) ||
        FileUtil.isFileNotExist(G.rt.bookCatalogPathD(name))) {
      Fluttertoast.showToast(
        msg: '无法读取作品：《' + name + '》所在数据',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
      return;
    }

    // 读取作品目录
    G.rt.currentBookName = name;
    String str = FileUtil.readText(G.rt.cBookCatalogPathD());
    try {
      // 解析JSON
      currentBook = BookObject.fromJson(json.decode(str));
      currentBook.setVCItemsContext();
      currentList = currentBook.catalog;

      if (openBookCallback != null) {
        openBookCallback(currentBook);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '解析目录树错误');
      currentList = [];
    } finally {
      currentRoute = [];
    }
    G.us.setConfig('recent/book_name', name);
    updateState();
  }

  /// 关闭当前一打开的作品
  /// 并且保存一些状态变量，以便下次打开时恢复
  void closeCurrentBook() {
    if (closeBookCallback != null) {
      closeBookCallback(currentBook);
    }

    G.rt.currentBookName = currentBook = null;
    currentRoute = null;
    currentList = null;
    G.us.setConfig('recent/book_name', '');

    updateState();
  }

  /// 重命名当前作品
  void renameCurrentBook(String newName) {
    if (newName == null || newName.isEmpty) {
      return;
    }
    if (FileUtil.isDirExists(G.rt.bookPathD(newName))) {
      Fluttertoast.showToast(msg: '作品《' + newName + '》已存在');
      return;
    }
    if (!BookObject.canBeBookName(newName)) {
      Fluttertoast.showToast(msg: '名字《' + newName + '》包含特殊字符，无法用作书名');
      return;
    }
    // 修改书名
    currentBook.name = newName;

    // 设置配置项
    G.us.setConfig('recent/book_name', newName);
  }

  /// 删除当前作品
  void deleteCurrentBook() {
    String name = currentBook.name.toString();
    closeCurrentBook();

    FileUtil.createDir(G.rt.recyclesBooksPath);
    String bookPath = G.rt.booksPath + name;
    String recyclePath = G.rt.rBookPath(name);
    int index = 0;
    String tempPath = recyclePath;
    while (FileUtil.isDirExists(tempPath)) {
      tempPath = recyclePath + '(' + (++index).toString() + ')';
    }
    if (index > 0) recyclePath = tempPath;
    FileUtil.moveDir(bookPath, recyclePath);
  }

  /// 获取当前查看的分卷
  /// 如果是根目录，返回 null
  VCItem getCurrentVolume() {
    if (currentRoute == null || currentRoute.length == 0) {
      return null;
    }
    return currentRoute.last;
  }

  /// 加载某一分卷
  void loadVolume(VCItem volume) {
    // 如果是空的，则表示加载根目录
    if (volume == null) {
      currentList = currentBook.catalog;
    } else {
      currentList = volume.vcList;
    }

    updateState();
  }

  /// 保存目录结构
  void saveCatalog() {
    if (currentBook == null) {
      return;
    }
    FileUtil.writeText(
        G.rt.cBookCatalogPathD(), jsonEncode(currentBook.toJson()));
  }

  /// 编辑器打开章节
  void openChapter(VCItem chapter) {
    if (chapter != null) {
      openChapterCallback(chapter);
    }
  }

  /// 根据ID打开章节
  void openChapterById(String id) {
    if (currentBook == null) return;
    VCItem chapter = currentBook.getChapterById(id);
    if (chapter != null) {
      openChapter(chapter);
    }
  }
}

enum VCItemActions {
  Rename,
  Insert,
  Delete,
  Restore,
  Publish,
  Information,
  MoveUp,
  MoveDown,
  MoveTop,
  MoveBottom
}

class _DirPageState extends State<DirPage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true; // 保持滑动Tab的时候不重绘

  @override
  Widget build(BuildContext context) {
    // 通过重载 AutomaticKeepAliveClientMixin 的
    // wantKeepAlive 成员，使页面在切换 tab 时不重绘
    super.build(context);

    return new Scaffold(
      //      drawer: MyDrawer.globalDrawer,
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
          title: Builder(
            builder: (BuildContext context) {
              // 获取context后才能跳转页面
              return new InkWell(
                child: new Text(widget.currentBook == null
                    ? '创建或切换作品'
                    : widget.currentBook.name),
                onTap: () {
                  actionOpenBookShelf();
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
            _buildBookMenu()
          ]),
      body: _buildCatalogGroup(),
    );
  }

  /// 根据类型获取不同的列表
  Widget _buildCatalogGroup() {
    if (G.us.bookCatalogMode == BookCatalogMode.Tree) {
      if (widget.currentBook == null || widget.currentBook.catalog == null) {
        return new Text('请创建作品');
      }
      // 树状模式
      var showedList = widget.currentBook.catalog
          .where((element) => G.us.showCatalogRecycle || !element.deleted)
          .toList();
      return ListView.builder(
        itemCount: showedList.length,
        itemBuilder: (context, index) {
          return _buildCatalogTreeTiles(showedList[index]);
        },
      );
    } else if (G.us.bookCatalogMode == BookCatalogMode.Flat) {
      // 显示单层模式
      return new Column(
        children: <Widget>[
          _buildCatalogFlatRouteView(),
          new Expanded(
            child: RefreshIndicator(
              onRefresh: actionSync,
              child: _buildCatalogFlatVCListView(),
            ),
          ),
        ],
      );
    } else {
      // 其他模式
      return Text("待开发的目录视图");
    }
  }

  /// 构建 Tree 模式的每一项
  Widget _buildCatalogTreeTiles(VCItem item) {
    if (item.isChapter()) {
      return _buildVolumeChapterTile(item);
    }

    // 分卷，构建树状列表
    return ExpansionTile(
      key: PageStorageKey<VCItem>(item),
      title: Text(item.getDisplayName()),
      children: item.vcList
          .where((element) => G.us.showCatalogRecycle || !element.deleted)
          .toList()
          .map(_buildCatalogTreeTiles)
          .toList(),
      onExpansionChanged: (bool exp) {
        if (exp) {
          // 展开
          widget.currentList = item.vcList;
        } else {
          // 收起
          // 如果有父分卷，则聚焦至父分卷
          // 如果没有父分卷，则使用全书最外层分卷
          widget.currentList = item.parent != null
              ? item.parent.vcList
              : widget.currentBook.catalog;
        }
      },
    );
  }

  /// 获取 Flat 模式路径分割线的view
  Widget _buildCatalogFlatRouteView() {
    /*if (currentRoute == null || currentRoute.length == 0) {
      return new Padding(
        padding: EdgeInsets.only(bottom: 30),
      );
    }*/
    return new ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 24,
          maxHeight: 24,
        ),
        child: new Padding(
          padding: EdgeInsets.only(left: 16, top: 4),
          child: (widget.currentRoute == null ||
                  widget.currentRoute.length == 0)
              ? new Text(
                  '总字数：待统计',
                )
              : new ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.currentRoute.length + 1,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: index == 0
                            ? new Text(' / ')
                            : new Text(widget.currentRoute[index - 1].name),
                      ),
                      onTap: () => actionEnterParentVolume(
                          index == 0 ? null : widget.currentRoute[index - 1]),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return new Text(
                      '>',
                      style: TextStyle(color: new Color(0x88888888)),
                    );
                  },
                ),
        ));
  }

  /// 获取 Flat 模式下 ListView 整体
  /// 如果为空则显示一个添加按钮
  Widget _buildCatalogFlatVCListView() {
    if (widget.currentBook == null) {
      return new Center(
          child: new InkWell(
        onTap: () {
          // todo: 点击出现俏皮晃头晃脑动画
        },
        child:
            new Text('↑ ↑ ↑\n请点击上方标题\n创建或切换作品', style: TextStyle(fontSize: 20)),
      ));
    }
    if (widget.currentBook.catalog.length == 0) {
      return new Center(
          child: new InkWell(
        onTap: () => actionAppendChapter(),
        child: new Text('添加分卷', style: TextStyle(fontSize: 20)),
      ));
    }
    return AnimationLimiter(
      // 这个会报很多警告
      child: ListView.builder(
          itemCount: widget.currentList.length,
          itemBuilder: (context, index) {
            return Offstage(
              offstage: !G.us.showCatalogRecycle &&
                      widget.currentList[index].deleted ??
                  false,
              child: AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildVolumeChapterTile(widget.currentList[index]),
                    ),
                  )),
            );
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
  Widget _buildVolumeChapterTile(VCItem item) {
    String name = item.getDisplayName();
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
        child: !item.deleted ? image : null,
        constraints: BoxConstraints(
            maxWidth: 32, minWidth: 32, minHeight: 32, maxHeight: 32),
      ),
      title: Row(
        children: <Widget>[
          !item.deleted
              ? new Text(name ?? '', style: TextStyle(fontSize: 16))
              : new Text(name ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
          new Spacer(
            flex: 1,
          ),
          new Text(
            item.isVolume()
                ? ((item.vcList != null ? item.vcList.length.toString() : '?') +
                    ' 章')
                : (G.us.bookCatalogWordCount
                    ? item.wordCount.toString() + ' 字'
                    : ''),
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
      subtitle: timeDisplayed.isNotEmpty ? new Text(timeDisplayed) : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[_buildVCItemPopupMenuButton(item)],
      ),
      onTap: () {
        if (item.isVolume()) {
          actionEnterChildVolume(item);
        } else if (item.isChapter()) {
          widget.openChapter(item);
        }
      },
      onLongPress: () => {},
    );
  }

  PopupMenuButton _buildVCItemPopupMenuButton(VCItem item) {
    return PopupMenuButton<VCItemActions>(
        icon: Icon(Icons.more_vert),
        itemBuilder: (BuildContext context) => item.isVolume()
            ? _buildVolumeActions(context, item)
            : _buildChapterActions(context, item),
        onSelected: (VCItemActions result) =>
            _handleVCItemAction(item, result));
  }

  List<PopupMenuEntry<VCItemActions>> _buildVolumeActions(
      BuildContext context, VCItem item) {
    return <PopupMenuEntry<VCItemActions>>[
      const PopupMenuItem<VCItemActions>(
        child: Text('重命名'),
        value: VCItemActions.Rename,
      ),
      const PopupMenuItem<VCItemActions>(
        child: Text('插入章节'),
        value: VCItemActions.Insert,
      ),
      item.deleted
          ? const PopupMenuItem<VCItemActions>(
              child: Text('从回收站恢复'),
              value: VCItemActions.Restore,
            )
          : const PopupMenuItem<VCItemActions>(
              child: Text('移到回收站'),
              value: VCItemActions.Delete,
            ),
      PopupMenuItem<VCItemActions>(
        child: Text('上移'),
        value: VCItemActions.MoveUp,
        enabled: item.indexInList > 0,
      ),
      PopupMenuItem<VCItemActions>(
          child: Text('下移'),
          value: VCItemActions.MoveDown,
          enabled: item.indexInList <
              (item.parent == null
                      ? widget.currentBook.catalog.length
                      : item.parent.vcList.length) -
                  1),
    ];
  }

  List<PopupMenuEntry<VCItemActions>> _buildChapterActions(
      BuildContext context, VCItem item) {
    return <PopupMenuEntry<VCItemActions>>[
      const PopupMenuItem<VCItemActions>(
        child: Text('重命名'),
        value: VCItemActions.Rename,
      ),
      const PopupMenuItem<VCItemActions>(
        child: Text('插入章节'),
        value: VCItemActions.Insert,
      ),
      const PopupMenuItem<VCItemActions>(
        child: Text('发布'),
        value: VCItemActions.Publish,
        enabled: false,
      ),
      const PopupMenuItem<VCItemActions>(
        child: Text('字数详情'),
        value: VCItemActions.Publish,
        enabled: false,
      ),
      item.deleted
          ? const PopupMenuItem<VCItemActions>(
              child: Text('从回收站恢复'),
              value: VCItemActions.Restore,
            )
          : const PopupMenuItem<VCItemActions>(
              child: Text('移到回收站'),
              value: VCItemActions.Delete,
            ),
      PopupMenuItem<VCItemActions>(
        child: Text('上移'),
        value: VCItemActions.MoveUp,
        enabled: item.indexInList > 0,
      ),
      PopupMenuItem<VCItemActions>(
          child: Text('下移'),
          value: VCItemActions.MoveDown,
          enabled: item.indexInList <
              (item.parent == null
                      ? widget.currentBook.catalog.length
                      : item.parent.vcList.length) -
                  1),
    ];
  }

  void _handleVCItemAction(VCItem item, VCItemActions result) {
    switch (result) {
      case VCItemActions.Rename:
        inputName('修改名字', item.isVolume() ? '卷名' : '章名', item.name,
            (String result) {
          setState(() {
            item.name = result;
            widget.currentBook.setVCItemsContext();
            saveCatalog();
            if (widget.renameBookCallback != null) {
              widget.renameBookCallback(item);
            }
          });
        });
        break;
      case VCItemActions.Insert:
        inputName('插入章节', '章名', '', (String result) {
          int index = widget.currentList.indexOf(item);
          if (index < 0) // 出错了，没找到
            return;
          _insertVCItemInCurrentList(
              index, new VCItem(name: result, type: VCItemType.ChapterType));
          widget.currentBook.setVCItemsContext();
          saveCatalog();
        });
        break;
      case VCItemActions.Delete:
        setState(() {
          item.deleted = true;
          item.deleteTime = DateTime.now().millisecondsSinceEpoch;
          widget.currentBook.setVCItemsContext();
          saveCatalog();
          if (widget.deleteChapterCallback != null) {
            widget.deleteChapterCallback(item);
          }
        });
        break;
      case VCItemActions.Restore:
        setState(() {
          item.deleted = false;
          widget.currentBook.setVCItemsContext();
          saveCatalog();
        });
        break;
      case VCItemActions.Publish:
        // TODO: Handle this case.
        break;
      case VCItemActions.Information:
        // TODO: Handle this case.
        break;
      case VCItemActions.MoveUp:
        setState(() {
          int index = widget.currentList.indexOf(item);
          if (index <= 0) return;
          widget.currentList.removeAt(index);
          int target = index - 1;
          if (!G.us.showCatalogRecycle) {
            while (target > 0 && widget.currentList[target].deleted) {
              target--;
            }
          }
          widget.currentList.insert(target, item);
          widget.currentBook.setVCItemsContext();
          saveCatalog();
        });
        break;
      case VCItemActions.MoveDown:
        setState(() {
          int index = widget.currentList.indexOf(item);
          if (index < 0 || index >= widget.currentList.length) return;
          widget.currentList.removeAt(index);
          int target = index;
          if (!G.us.showCatalogRecycle) {
            while (target < widget.currentList.length &&
                widget.currentList[target].deleted) {
              target++;
            }
          }
          if (target >= widget.currentList.length - 1)
            widget.currentList.add(item);
          else
            widget.currentList.insert(target + 1, item);
          widget.currentBook.setVCItemsContext();
          saveCatalog();
        });
        break;
      case VCItemActions.MoveTop:
        setState(() {
          int index = widget.currentList.indexOf(item);
          if (index < 0 || index >= widget.currentList.length) return;
          widget.currentList.removeAt(index);
          widget.currentList.insert(0, item);
          widget.currentBook.setVCItemsContext();
          saveCatalog();
        });
        break;
      case VCItemActions.MoveBottom:
        setState(() {
          int index = widget.currentList.indexOf(item);
          if (index < 0 || index >= widget.currentList.length) return;
          widget.currentList.removeAt(index);
          widget.currentList.add(item);
          widget.currentBook.setVCItemsContext();
          saveCatalog();
        });
        break;
    }
  }

  PopupMenuButton _buildBookMenu() {
    if (widget.currentBook == null) {
      return PopupMenuButton<String>(
        itemBuilder: (BuildContext content) => <PopupMenuItem<String>>[
          PopupMenuItem<String>(
            value: "book_shelf",
            child: Text('查看书架'),
          ),
        ],
        onSelected: (String value) {
          switch (value) {
            case 'book_shelf':
              actionOpenBookShelf();
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
        PopupMenuItem<String>(
          value: "book_recycles",
          child: Text(G.us.showCatalogRecycle ? '隐藏回收站' : '显示回收站'),
        ),
      ],
      onSelected: (String value) {
        switch (value) {
          case 'append_volume':
            actionAppendVolume();
            break;
          case 'book_recycles':
            setState(() {
              G.us.showCatalogRecycle = !G.us.showCatalogRecycle;
              if (widget.currentBook != null) {
                widget.currentBook.setVCItemsContext();
              }
            });
            break;
          case 'book_delete':
            actionDeleteBook();
            break;
          default:
            {}
            break;
        }
      },
    );
  }

  void saveCatalog() => widget.saveCatalog();

  void actionOpenBookShelf() {
    Navigator.push<String>(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new Bookshelf();
    })).then((String result) {
      if (result == null || result.isEmpty) {
        // 按返回键返回是没有传回的参数的
        return;
      }

      // 读取作品
      widget.closeCurrentBook();
      widget.openBook(result);
    });
  }

  /// 打开当前分卷下的子分卷
  void actionEnterChildVolume(VCItem volume) {
    if (widget.currentBook == null) {
      return;
    }
    // 加到route末尾
    widget.currentRoute.add(volume);
    widget.loadVolume(volume);
  }

  /// 打开上一层或者某一层的分卷
  void actionEnterParentVolume(VCItem volume) {
    if (widget.currentBook == null) {
      return;
    }
    if (volume == null) {
      widget.currentRoute = [];
      widget.loadVolume(null);
    } else if (widget.currentRoute.length > 0 &&
        widget.currentRoute.last == volume) {
      // 如果打开的当前分卷，则相当于刷新
      widget.loadVolume(volume);
    } else {
      // 路径中，取消route后半部分
      while (widget.currentRoute.length > 0) {
        if (widget.currentRoute.last == volume) {
          break;
        }
        widget.currentRoute.removeLast();
      }
      widget.loadVolume(volume);
    }
  }

  /// 添加新的章节
  void actionAppendChapter() {
    if (widget.currentBook == null) {
      Fluttertoast.showToast(msg: '请点击左上方标题创建一部作品');
      return;
    }

    // 添加新章
    inputName('添加新章', '章名', '', (String result) {
      // 添加章节到末尾
      _insertVCItemInCurrentList(
          -1, new VCItem(name: result, type: VCItemType.ChapterType));
      widget.currentBook.setVCItemsContext();
      saveCatalog();
    });
  }

  /// 添加新的分卷
  void actionAppendVolume() {
    if (widget.currentBook == null) {
      Fluttertoast.showToast(msg: '请点击左上方标题创建一部作品');
      return;
    }

    // 添加新卷
    inputName('添加新卷', '卷名', '', (String result) {
      // 添加分卷到末尾
      _insertVCItemInCurrentList(-1,
          new VCItem(name: result, type: VCItemType.VolumeType, vcList: []));
      widget.currentBook.setVCItemsContext();
      saveCatalog();
    });
  }

  void _insertVCItemInCurrentList(int index, VCItem item) {
    if (widget.currentBook == null) {
      Fluttertoast.showToast(msg: '请点击左上方标题创建一部作品');
      return;
    }
    if (item.id == null) {
      // 获取唯一ID
      item.id = widget.currentBook.createRandomID();
      if (item.id.isEmpty) {
        Fluttertoast.showToast(msg: '章节过多，请将该需求反馈给开发者');
        return;
      }
    }
    if (item.isVolume() && item.vcList == null) {
      item.vcList = [];
    }
    if (index > 0 && index < widget.currentList.length) {
      widget.currentList.insert(index, item);
    } else {
      widget.currentList.add(item);
    }
    setState(() {});
  }

  /// 输入一行名字的操作（非空）
  void inputName(String title, String label, String def, var resultFunc) {
    var inputString = new TextEditingController();
    inputString.text = def;
    inputString.selection =
        new TextSelection(baseOffset: 0, extentOffset: def.length);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: inputString,
              decoration: InputDecoration(
                hintText: def,
                hintMaxLines: 1,
                border: OutlineInputBorder(),
                labelText: label,
                prefixIcon: Icon(Icons.create),
              ),
              autofocus: true,
              onSubmitted: (value) {
                if (value != null && value.isNotEmpty) {
                  resultFunc(value.trim());
                  Navigator.of(context).pop();
                }
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  if (inputString.text != null &&
                      inputString.text.trim().isNotEmpty) {
                    resultFunc(inputString.text);
                    Navigator.of(context).pop();
                  }
                },
              ),
              FlatButton(
                child: Text(
                  '取消',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  /// 下拉刷新，快捷云同步方式
  Future<void> actionSync() async {
    // 模拟延迟（现在还是什么都不做的）
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });
  }

  void actionRenameBook() {
    if (widget.currentBook == null) {
      return;
    }
    inputName('修改书名', '书名', widget.currentBook.name, (String result) {
      widget.renameCurrentBook(result);
    });
  }

  /// 删除作品操作
  void actionDeleteBook() {
    if (widget.currentBook == null) {
      return;
    }
    final popup = BeautifulPopup(
      context: context,
      template: TemplateFail,
    );
    final newColor = Colors.red.withOpacity(0.5);
    popup.recolor(newColor);
    popup.show(title: '警告', content: '是否删除该作品？\n\n将删除所有内容，不可恢复', actions: [
      popup.button(
          label: '我已想好，确定删除',
          onPressed: () {
            widget.deleteCurrentBook();
            Navigator.of(context).pop();
          })
    ]);
  }
}
