import 'file:///E:/Flutter/fairyland/lib/main/my_drawer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fairyland/square/square_page.dart';
import 'package:fairyland/directory/dir_page.dart';
import 'package:fairyland/editor/editor_page.dart';
import 'package:fairyland/assist/assist_page.dart';

import 'my_navigation_bar.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<PageBean> _pages = <PageBean>[
    PageBean(title: '目录', icon: Icons.list, widget: DirPage()),
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

    // 页面切换
    _tabController.addListener(() {
      setState(() {
      
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _getAppBarTitle() {
    print('刷新标题');
    return _pages[_tabController.index].widget.getAppBarTitle();
//    return Text('这是什么神仙写作');
  }

  List<Widget> _getAppBarActions() {
    return _pages[_tabController.index].widget.getAppBarActions();
    //    return <Widget>[];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _pages.length,
        child: new Scaffold(
          appBar: AppBar(
            title: _getAppBarTitle(),
            actions: _getAppBarActions(),
          ),
          body: new TabBarView(
            controller: _tabController,
            children: _pages.map((PageBean page) => page.widget).toList(),
          ),
          drawer: MyDrawer(),
          bottomNavigationBar: new TitledBottomNavigationBar(
              items: _pages, controller: _tabController),
        ));
  }
}