import 'package:fairyland/directory/bookshelf/bookshelf.dart';
import 'package:flutter/material.dart';
import 'common/global.dart';
import 'main/my_main_home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // 不加这句启动就会报错
  G.init().then((e) {
    runApp(MyApp());
  });
}
//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '写作天下',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '写作天下'),
      routes: {
        "bookshelf": (BuildContext context) => new Bookshelf(),
      },
    );
  }
}
