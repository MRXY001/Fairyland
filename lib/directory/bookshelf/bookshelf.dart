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
    String path = Global.novelPath + name + '/';
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
      ),
      body: Builder(builder: (BuildContext context) {
        // 读取目录里的数据
        List<String> bookFiles = FileUtil.entityDirNames(Global.novelPath);

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
              onPressed: () {
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
              },
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
              return Row(
                children: <Widget>[
                  new Container(
                    constraints: BoxConstraints(maxWidth: 100, minWidth: 100),
                    child: books[index].cover,
                  ),
                  new Text(books[index].name)
                ],
              );
            }
        );
      }),
    );
  }
}
