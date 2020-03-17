import 'package:fairyland/main/my_main_page.dart';
import 'package:flutter/material.dart';

/// 保存页面的List
class PageBean {
  PageBean({this.title, this.icon, this.widget});

  String title;
  IconData icon;
  MainPageBase widget;
}

typedef void MainPageChangedCallback(int page);

/// 底部导航栏
class TitledBottomNavigationBar extends StatefulWidget {
  final List<PageBean> items;
  final PageController controller;

  const TitledBottomNavigationBar({Key key, this.items, this.controller})
      : super(key: key);

  @override
  _TitledBottomNavigationBarState createState() =>
      _TitledBottomNavigationBarState();
}

class _TitledBottomNavigationBarState extends State<TitledBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  List<PageBean> get items => widget.items;

  PageController get controller => widget.controller;

  //  MainPageChangedCallback get pageChangedCallback => widget.pageChangedCallback;

  int selectedIndex = 0;
  int aimIndex = -1;
  static const double BAR_HEIGHT = 60;
  static const double INDICATOR_HEIGHT = 2;
  static const double INDICATOR_WIDTH = 10;
  double width = 0;
  double indicatorAlignX = -1; // 相对于宽度的百分比

  Duration duration = Duration(milliseconds: 270);

  @override
  void initState() {
    _select(selectedIndex);
    controller.addListener(() {
      setState(() {
        final pageWidth = MediaQuery.of(context).size.width;
        int index = (controller.offset + pageWidth / 2) ~/ pageWidth;
        if (index < 0)
          index = 0;
        else if (index >= items.length) index = items.length - 1;
        indicatorAlignX = -1 + controller.offset / width;

        if (aimIndex == selectedIndex) { // 点击按钮跳转进来的
          if (index == selectedIndex) {
            aimIndex = -1;
          }
        } else {
          _select(index);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
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
              // 标签正文（文字+图标）
              top: INDICATOR_HEIGHT,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: items.map((item) {
                  var index = items.indexOf(item);
                  return GestureDetector(
                    onTap: () => setState(() {
                      aimIndex = index;
                      _select(index);
                      controller.animateToPage(
                        index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }),
                    child: _buildItemWidget(item, index == selectedIndex),
                  );
                }).toList(),
              ),
            ),
            Positioned(
              // 能滚动的线
              top: 0,
              width: width,
              child: AnimatedAlign(
                alignment: Alignment(indicatorAlignX, 0), // 这是按照百分比来算的，不是实际像素
                curve: Curves.linear,
                duration: Duration(milliseconds: 0),
                child: Container(
                  color: Colors.black,
                  width: width / items.length,
                  height: INDICATOR_HEIGHT,
                ),
              ),
            ),
          ]),
    );
  }

  _select(int index) {
    //    print('select' + index.toString());
    selectedIndex = index;
    //    indicatorAlignX = -1 + (2 / (items.length - 1) * index);
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
