import 'package:fairyland/utils/web_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fairyland/common/global.dart';

class ProfileWindow extends StatefulWidget {
  @override
  _ProfileWindowState createState() => _ProfileWindowState();
}

class _ProfileWindowState extends State<ProfileWindow> {
  var barKey = GlobalKey();
  var cardHeadKey = GlobalKey();
  var adKey = GlobalKey();
  var itemKey = GlobalKey();
  var gridKey = GlobalKey();
//  var outKey = GlobalKey();

  var barHeight = .0;
  var cardHeadHeight = .0;
  var adHeight = .0;
  var itemHeight = .0;
  var gridHeight = .0;
//  var outHeight = .0;

  var padding = 16.0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.endOfFrame.then((value) {
      barHeight = getHeightOfWidget(barKey);
      cardHeadHeight = getHeightOfWidget(cardHeadKey);
      adHeight = getHeightOfWidget(adKey);
      gridHeight = getHeightOfWidget(gridKey);
      itemHeight = getHeightOfWidget(itemKey);
//      outHeight = getHeightOfWidget(outKey);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('用户信息'),
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: SizedBox(
            height: barHeight +
                cardHeadHeight +
                adHeight +
                gridHeight +
                itemHeight,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: padding,
                  left: 0,
                  right: 0,
                  child: ProfileBar(barKey),
                ),
                Positioned(
                  top: barHeight + padding * 2,
                  left: padding,
                  right: padding,
                  child: ProfileCardHead(cardHeadKey),
                ),
                Positioned(
                  top: barHeight + cardHeadHeight + padding,
                  left: padding,
                  right: padding,
                  child: ProfileAD(adKey),
                ),
                Positioned(
                  top: barHeight + cardHeadHeight + adHeight,
                  left: 0,
                  right: 0,
                  child: ProfileGrid(gridKey),
                ),
                Positioned(
                  top: barHeight + cardHeadHeight + adHeight + gridHeight,
                  left: 0,
                  right: 0,
                  child: ProfileItems(itemKey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double getHeightOfWidget(GlobalKey key) {
    RenderBox renderBox = key.currentContext.findRenderObject();
    return renderBox.size.height;
  }
}

class ProfileBar extends StatelessWidget {
  final GlobalKey sizeKey;

  ProfileBar(this.sizeKey);

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: sizeKey,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.sync, size: 20),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.settings, size: 16),
                Text(
                  '设置',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Icon(Icons.mail_outline, size: 20)
        ],
      ),
    );
  }
}

class ProfileCardHead extends StatelessWidget {
  final GlobalKey sizeKey;

  ProfileCardHead(this.sizeKey);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sizeKey,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                radius: 24,
                backgroundImage:
                    AssetImage('assets/icons/writerfly_appicon.png'),
              ),
              SizedBox(width: 14),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    G.ac.getNickname(),
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.ac_unit,
                        color: Colors.green,
                        size: 12,
                      ),
                      SizedBox(width: 4),
                      Text(
                        G.ac.getLevel().toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        Icons.stars,
                        color: Colors.orange,
                        size: 12,
                      ),
                      SizedBox(width: 4),
                      Text(
                        G.ac.isVIP() ? 'VIP用户' : '普通用户',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.keyboard_arrow_right, size: 16),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      G.ac.getAllWords().toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '字数',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    )
                  ],
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      G.ac.getAllTimes().toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '分钟',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    )
                  ],
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      G.ac.getRank().toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '排名',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    )
                  ],
                ),
                Spacer(),
                ButtonTheme(
                  minWidth: 50,
                  height: 25,
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () {},
                    child: Text(
                      '充值',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProfileAD extends StatelessWidget {
  final GlobalKey sizeKey;

  ProfileAD(this.sizeKey);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sizeKey,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.star,
                color: Colors.white,
              ),
              Text(
                '开通畅享卡',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Text(
                '享免费书库等10项福利',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
                size: 14,
              ),
            ],
          ),
          SizedBox(height: 4),
          SizedBox(
            height: 1,
            child: Container(
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class ProfileADGridItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final onTap;

  const ProfileADGridItem({Key key, this.icon, this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 24,
            color: Colors.black,
          ),
          SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

class ProfileData {
  final IconData icon;
  final String text;
  final onTap;
  IconData tail;

  ProfileData(this.icon, this.text, this.onTap);

  ProfileData setTail(IconData icon) {
    this.tail = icon;
    return this;
  }
}

// ignore: must_be_immutable
class ProfileGrid extends StatelessWidget {
  final GlobalKey sizeKey;

  List<ProfileData> datas = [
    ProfileData(Icons.favorite, '我的好友', () {}),
    ProfileData(Icons.star, '我的收藏', () {}),
    ProfileData(Icons.description, '我的文章', () {}),
    ProfileData(Icons.send, '小说发布', () {}),
    ProfileData(Icons.device_hub, '拼字房间', () {}),
    ProfileData(Icons.backup, '云端网盘', () {}),
    ProfileData(Icons.history, '浏览历史', () {}),
    ProfileData(Icons.more_horiz, '更多', () {}),
  ];

  ProfileGrid(this.sizeKey);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sizeKey,
      color: Colors.white,
      height: 180,
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 0.0,
        childAspectRatio: 4 / 3,
        children: List.generate(datas.length, (index) {
          return ProfileADGridItem(
            icon: datas[index].icon,
            text: datas[index].text,
          );
        }),
      ),
    );
  }
}

// ignore: must_be_immutable
class ProfileItems extends StatelessWidget {
  final GlobalKey sizeKey;
  List<ProfileData> datas = [
    ProfileData(Icons.face, '码字风云榜', () {
      WebUtil.launchURL('http://writerfly.cn/rank');
    }),
    ProfileData(Icons.center_focus_strong, '思绪深渊', () {
      WebUtil.launchURL('http://web.writerfly.cn/index/muse/entrance.html');
    }),
    ProfileData(Icons.color_lens, '主题风格', () {}).setTail(Icons.brightness_2),
    ProfileData(Icons.computer, '电脑下载', () {
      WebUtil.launchURL('http://writerfly.cn/download');
    }),
    ProfileData(Icons.restore, '回收站', () {}),
    ProfileData(Icons.exit_to_app, '退出登录', () {
      
      G.ac.logout();
    }),
  ];

  ProfileItems(this.sizeKey);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sizeKey,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(datas.length, (index) {
          return ListTile(
            leading: Icon(datas[index].icon),
            title: Text(datas[index].text),
            trailing:
                datas[index].tail != null ? Icon(datas[index].tail) : null,
            onTap: datas[index].onTap,
          );
        })
          ..insert(
            0,
            Container(
              height: 10,
              color: Colors.grey.shade200,
            ),
          ),
      ),
    );
  }
}

class LogoutWidget extends StatelessWidget {
  final GlobalKey sizeKey;

  LogoutWidget(this.sizeKey);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('退出登录'),
      onPressed: () {
        G.ac.logout();
      },
    );
  }
}
