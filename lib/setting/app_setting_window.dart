import 'package:fairyland/common/global.dart';
import 'package:fairyland/setting/app_setting_item_bean.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppSettingWindow extends StatelessWidget {
  String pageTitle;
  AppSettingGroups appSettingGroups;
  bool showGroupTitle = true;

  AppSettingWindow({Key key, this.pageTitle, this.appSettingGroups})
      : super(key: key) {
    if (pageTitle == null || pageTitle.isEmpty) {
      pageTitle = '程序设置';
    }
    if (appSettingGroups == null) {
      appSettingGroups = G.asg;
    }
    if (appSettingGroups.length() <= 1) {
      showGroupTitle = false;
    }
    print(appSettingGroups.length());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: ListView.builder(
        itemCount: appSettingGroups.length(),
        itemBuilder: (context, index) {
          return _buildGroup(
              appSettingGroups.names[index], appSettingGroups.items[index]);
        },
      ),
    );
  }

  Widget build0(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Setting Area1",
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.red,
                  ),
                  title: Text("Account"),
                  trailing: Icon(Icons.arrow_right),
                ),
                ListTile(
                  leading: Icon(
                    Icons.mail,
                    color: Colors.red,
                  ),
                  title: Text("Mail"),
                  trailing: Icon(Icons.arrow_right),
                ),
                ListTile(
                  leading: Icon(
                    Icons.sync,
                    color: Colors.red,
                  ),
                  title: Text("Sync"),
                  trailing: Icon(Icons.arrow_right),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Setting Area2",
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.network_wifi,
                    color: Colors.blue,
                  ),
                  title: Text("Network"),
                  trailing: Switch(value: true, onChanged: (v) {}),
                ),
                ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Colors.blue,
                  ),
                  title: Text("Phone"),
                  trailing: Icon(Icons.arrow_right),
                ),
                ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: Colors.blue,
                  ),
                  title: Text("Address"),
                  trailing: Icon(Icons.arrow_right),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建整个分组
  /// 判断是否需要分组标题（如果有多个分组则需要）
  Widget _buildGroup(String name, List<AppSettingItem> group) {
    if (showGroupTitle) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(name),
          ),
          _buildGroupCard(group)
        ],
      );
    } else {
      return Column(
        children: <Widget>[_buildGroupCard(group)],
      );
    }
  }

  /// 构建分组设置项的卡片
  Widget _buildGroupCard(List<AppSettingItem> group) {
    return Card(
        color: Colors.white,
        elevation: 4.0,
        child: ListView.builder(
            itemCount: group.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var item = group[index];
              return ListTile(
                leading: item.icon,
                title: Text(item.title),
                trailing: Icon(Icons.arrow_right),
                onTap: item.onClicked,
              );
            }));
  }
}
