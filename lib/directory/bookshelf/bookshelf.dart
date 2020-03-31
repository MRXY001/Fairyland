import 'dart:io';

import 'package:fairyland/common/global.dart';
import 'package:fairyland/directory/bookshelf/book_fields.dart';
import 'package:fairyland/utils/file_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookBean {
  String name; // 名字
  Image cover; // 封面
  int wordCount; // 字数
  String description; // 简介
  String lastModify;

  BookBean(this.name) {
    // 读取作品
    String path = Global.booksPath + name + '/';
    if (FileUtil.isFileExists(path + 'cover.png')) {
      cover = Image.file(File(path + 'cover.png'));
    } else {
      cover = Image.asset('assets/covers/default.png');
    }
  }
}

class Bookshelf extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _BookshelfState();
  }
}

class _BookshelfState extends State<Bookshelf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的书架'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: '添加新章',
            onPressed: () => gotoCreate(),
          ),
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        // 读取目录里的数据
        List<String> bookFiles = FileUtil.entityDirNames(Global.booksPath);

        // 如果没有作品的话，只居中显示一个“新建作品”
        if (bookFiles.length == 0) {
          return new Center(
            child: OutlineButton.icon(
              icon: Icon(
                Icons.add,
                size: 32,
              ),
              label: Text(
                '新建作品',
                textScaleFactor: 2,
              ),
              onPressed: () => gotoCreate(),
            ),
          );
        }

        // 显示书架列表
        List<BookBean> books = [];
        bookFiles.forEach((element) {
          books.add(BookBean(element));
        });

        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: books.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  clipBehavior: Clip.antiAlias,
                  color: Theme.of(context).cardColor,
                  elevation: 16,
                  margin: EdgeInsets.all(16),
                  semanticContainer: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    onTap: () => openBook(books[index].name),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          new Container(
                            child: books[index].cover,
                            constraints: BoxConstraints(
                                maxWidth: 100,
                                minWidth: 100,
                                minHeight: 150,
                                maxHeight: 150),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(books[index].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25)),
                              new Text('作者：您'),
                              new Text('字数：待统计'),
                              new Text('最近：待统计'),
                              new Text('简介：待输入'),
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
            });
      }),
    );
  }

  void gotoCreate() {
    Navigator.push<String>(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new BookFields();
    })).then((String result) {
      if (result.isEmpty) {
        return;
      }

      // 刷新列表
      setState(() {});
    });
  }

  void openBook(String name) {
    Navigator.pop(context, name);
  }
}
