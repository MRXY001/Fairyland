import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Bookshelf extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _BookshelfState();
  }
}

class _BookshelfState extends State<Bookshelf> {
  @override
  Widget build(BuildContext context) {
  	return Scaffold(
		  appBar: AppBar(
			  title: Text('我的书架'),
			  actions: <Widget>[
				  IconButton(
					  icon: Icon(Icons.add),
					  tooltip: '创建新书',
					  onPressed: () {
					  	// 创建新书
						  
					  },
				  ),
			  ],
		  ),
	  );
  }
	
}