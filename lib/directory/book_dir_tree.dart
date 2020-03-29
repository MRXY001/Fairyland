import 'package:flutter/material.dart';
import 'package:fairyland/directory/book_beans.dart';
import 'package:xml/xml.dart';

class BookDirTreeView extends StatefulWidget {
	BookDirTreeView({Key key}) : super(key: key);
	
	@override
	_BookDirTreeViewState createState() => _BookDirTreeViewState();
}

class _BookDirTreeViewState extends State<BookDirTreeView> {
	
	XmlDocument dirTreeXml;
	
	
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
  
  void openBook(String name) {
  
  }
	
}


/// 演示控件，可能就采用这个项目了
class Item {
	Item({
		this.expandedValue,
		this.headerValue,
		this.isExpanded = true,
	});
	
	String expandedValue;
	String headerValue;
	bool isExpanded;
}

/// Expansion参考
class ExpansionPanelPage extends StatefulWidget {
	ExpansionPanelPage({Key key}) : super(key: key);
	
	@override
	_ExpansionPanelPageState createState() => _ExpansionPanelPageState();
}

class _ExpansionPanelPageState extends State<ExpansionPanelPage> {
	List<Item> _data = List.generate(8, (int index) {
		return Item(
			headerValue: 'Panel $index',
			expandedValue: 'This is item number $index',
		);
	});
	
	@override
	Widget build(BuildContext context) {
		return new SingleChildScrollView(
			child: Container(
				child: _buildPanel(),
			),
		);
	}
	
	Widget _buildPanel() {
		return ExpansionPanelList.radio(
			expansionCallback: (int index, bool isExpanded) {
				setState(() {
					_data[index].isExpanded = !isExpanded;
				});
			},
			children: _data.map<ExpansionPanel>((Item item) {
				return ExpansionPanelRadio(
					canTapOnHeader: true,
					headerBuilder: (BuildContext context, bool isExpanded) {
						return ListTile(
							title: Text(item.headerValue),
						);
					},
					body: ListTile(
							title: Text(item.expandedValue),
							subtitle: Text('To delete this panel, tap the trash can icon'),
							trailing: Icon(Icons.delete),
							onTap: () {
								setState(() {
									_data.removeWhere((currentItem) => item == currentItem);
								});
							}),
					value: item.headerValue,
				);
			}).toList(),
		);
	}
}
