import 'package:flutter/material.dart';
import 'package:fairyland/square/square_page.dart';
import 'package:fairyland/directory/dir_page.dart';
import 'package:fairyland/editor/editor_page.dart';
import 'package:fairyland/assist/assist_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static List<PageBean> _pages = <PageBean>[
    PageBean(title: '目录', icon: Icons.list, widget: ExpansionPanelPage()),
    PageBean(title: '写作', icon: Icons.edit, widget: EditPage()),
    PageBean(title: '助手', icon: Icons.school, widget: AssistPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _pages.length,
      child: new Scaffold(
        appBar: new AppBar(
          title: Text(widget.title),

        ),
        body: new TabBarView(
          children: _pages.map((PageBean page) {
            return new Padding(
              padding: const EdgeInsets.all(16.0),
              child: page.widget,
            );
          }).toList(),
        ),
        bottomNavigationBar: TitledBottomBarWidget(pages: _pages),
      ),
    );
  }
}

class TitledBottomBarWidget extends StatefulWidget {
  TitledBottomBarWidget({Key key, this.pages}) : super();

  final List<PageBean> pages;

  @override
  State createState() => _TitledBottomBarWidgetState();
}


class _TitledBottomBarWidgetState extends State<TitledBottomBarWidget> {
  @override
  Widget build(BuildContext context) {
    return TitledBottomNavigationBar(
      items: widget.pages,
    );
  }
}

class TitledBottomNavigationBar extends StatefulWidget {
  final List<PageBean> items;

  const TitledBottomNavigationBar({Key key, this.items}) : super(key: key);

  @override
  _TitledBottomNavigationBarState createState() => _TitledBottomNavigationBarState();
}

class _TitledBottomNavigationBarState extends State<TitledBottomNavigationBar> with SingleTickerProviderStateMixin {
  List<PageBean> get items => widget.items;
  int selectedIndex = 0;
  static const double BAR_HEIGHT = 60;
  static const double INDICATOR_HEIGHT = 2;
  static const double INDICATOR_WIDTH = 10;
  double width = 0;
  double indicatorAlignX = 0;

  Duration duration = Duration(milliseconds: 270);

  @override
  void initState() {
    _select(selectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width - 32;
    return Container(
      height: BAR_HEIGHT,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
//        overflow: Overflow.visible,// Debug使用
        children: <Widget>[
          Positioned(
            top: INDICATOR_HEIGHT,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: items.map((item) {
                var index = items.indexOf(item);
                return GestureDetector(
                  onTap: () => setState(() {
                    _select(index);
                  }),
                  child: _buildItemWidget(item, index == selectedIndex),
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: 0,
            width: width,
            child: AnimatedAlign(
              alignment: Alignment(indicatorAlignX, 0),
              curve: Curves.linear,
              duration: duration,
              child: Container(
                color: Colors.black,
                width: width / items.length,
                height: INDICATOR_HEIGHT,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _select(int index) {
    selectedIndex = index;
    indicatorAlignX = -1 + (2 / (items.length - 1) * index);
  }

  Widget _buildItemWidget(PageBean item, bool isSelected) {
    return Container(
      color: Colors.white,
      height: BAR_HEIGHT,
      width: width / items.length,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          AnimatedOpacity(
            opacity: isSelected ? 0.0 : 1.0,
            duration: duration,
            curve: Curves.linear,
            child: Text(item.title),
          ),
          AnimatedAlign(
            duration: duration,
            alignment: isSelected ? Alignment.center : Alignment(0, 2.6),
            child: Icon(item.icon),
          ),
        ],
      ),
    );
  }
}

class PageBean {
  PageBean({this.title, this.icon, this.widget});

  String title;
  IconData icon;
  Widget widget;
}