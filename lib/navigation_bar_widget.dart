import 'package:flutter/material.dart';

/// 保存页面的List
class PageBean {
  PageBean({this.title, this.icon, this.widget});

  String title;
  IconData icon;
  Widget widget;
}

/// 底部导航栏
class TitledBottomNavigationBar extends StatefulWidget {
  final List<PageBean> items;
  final TabController controller;

  const TitledBottomNavigationBar({Key key, this.items, this.controller}) : super(key: key);

  @override
  _TitledBottomNavigationBarState createState() => _TitledBottomNavigationBarState();
}

class _TitledBottomNavigationBarState extends State<TitledBottomNavigationBar> with SingleTickerProviderStateMixin {
  List<PageBean> get items => widget.items;
  TabController get controller => widget.controller;

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
    controller.addListener(() {
      _select(controller.index);
      setState(() {

      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width - 32;
//    tabs = ;
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
          Positioned( // 标签正文（文字+图标）
            top: INDICATOR_HEIGHT,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: items.map((item) {
                var index = items.indexOf(item);
                return GestureDetector(
                  onTap: () => setState(() {
                    _select(index);
                    controller.animateTo(index);
                  }),
                  child: _buildItemWidget(item, index == selectedIndex),
                );
              }).toList(),
            ),
          ),
          Positioned( // 能滚动的线
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
        ]
      ),
    );
  }

  _select(int index) {
//    print('select' + index.toString());
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