import 'package:fairyland/main/my_main_page.dart';
import 'package:flutter/material.dart';

class DirPage extends MainPageBase {
  DirPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _DirPageState();
  }

  @override
  Widget getAppBarTitle() {
    return Text('目录');
  }
}

class _DirPageState extends State<DirPage> {
  String currentNovelName;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new ExpansionPanelPage(),
          ),
        ],
      )
    );
  }
}

class ChapterItem {
  String id;
  String name;
  String fullName; // 带有章序的章节名
  DateTime time;
  String content;
  int wordCount;
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = true,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

/// Expansion参考
class ExpansionPanelPage extends StatefulWidget {
  ExpansionPanelPage({Key key}) : super(key: key);

  @override
  _ExpansionPanelPageState createState() => _ExpansionPanelPageState();
}

class _ExpansionPanelPageState extends State<ExpansionPanelPage> {
  List<Item> _data = List.generate(8, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList.radio(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanelRadio(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
              title: Text(item.expandedValue),
              subtitle: Text('To delete this panel, tap the trash can icon'),
              trailing: Icon(Icons.delete),
              onTap: () {
                setState(() {
                  _data.removeWhere((currentItem) => item == currentItem);
                });
              }),
          value: item.headerValue,
        );
      }).toList(),
    );
  }
}
