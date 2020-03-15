import 'package:flutter/material.dart';
import 'file:///E:/Flutter/fairyland/lib/main/my_main_home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '写作天下',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '写作天下'),
    );
  }
}

