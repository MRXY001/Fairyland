import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fairyland/square/square_page.dart';
import 'package:fairyland/directory/dir_page.dart';
import 'package:fairyland/editor/editor_page.dart';
import 'package:fairyland/assist/assist_page.dart';

import 'navigation_bar_widget.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  static List<PageBean> _pages = <PageBean>[
    PageBean(title: '目录', icon: Icons.list, widget: ExpansionPanelPage()),
    PageBean(title: '写作', icon: Icons.edit, widget: EditPage()),
    PageBean(title: '助手', icon: Icons.school, widget: AssistPage()),
  ];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _pages.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _pages.length,
      child: new Scaffold(
        appBar: new AppBar(
          title: Text(widget.title),

        ),
        body: new TabBarView(
          controller: _tabController,
          children: _pages.map((PageBean page) {
            return new Padding(
              padding: const EdgeInsets.all(16.0),
              child: page.widget,
            );
          }).toList(),
        ),
        bottomNavigationBar: TitledBottomNavigationBar(items: _pages, controller: _tabController),
      ),
    );
  }
}

