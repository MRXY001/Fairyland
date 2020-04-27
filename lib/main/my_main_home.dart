import 'package:fairyland/assist/assist_page.dart';
import 'package:fairyland/common/global.dart';
import 'package:fairyland/directory/book_beans.dart';
import 'package:fairyland/editor/chatper_editor.dart';
import 'package:fairyland/main/my_drawer.dart';
import 'package:fairyland/square/square_page.dart';
import 'package:flutter/material.dart';
import 'package:fairyland/directory/dir_page.dart';
import 'package:fairyland/editor/editor_page.dart';

import 'my_navigation_bar.dart';

class MyHomePage extends StatefulWidget {
	MyHomePage({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	_MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
		with SingleTickerProviderStateMixin {
	var context;
	List<PageBean> _pages;
	DirPage dirPage;
	EditorPage editorPage;
	PageController pageController;
	ChapterEditor chapterEditor;
	AssistPage assistPage;
	var currentPage = 0;
	TitledBottomNavigationBar bottomBar;
	
	@override
	void initState() {
		super.initState();
		pageController = PageController();
		dirPage = new DirPage(openChapter: _openChapter);
		editorPage = new EditorPage();
		assistPage = new AssistPage();
		chapterEditor = editorPage.getEditor();
		_pages = <PageBean>[
			PageBean(title: '目录', icon: Icons.list, widget: dirPage),
			PageBean(title: '写作', icon: Icons.edit, widget: editorPage),
			PageBean(title: '助手', icon: Icons.school, widget: assistPage),
		];
		bottomBar = new TitledBottomNavigationBar(
			items: _pages,
			controller: pageController,
		);
		MyDrawer.globalDrawer = new MyDrawer();
	}
	
	@override
	void dispose() {
		pageController.dispose();
		super.dispose();
	}
	
	@override
	Widget build(BuildContext context) {
		this.context = context;
		return new Scaffold(
				body: new PageView(
					children: _pages.map((PageBean page) => page.widget).toList(),
					controller: pageController,
					physics: BouncingScrollPhysics(),
					onPageChanged: (page) {
						setState(() {
							currentPage = page;
						});
					},
				),
				drawer: MyDrawer.globalDrawer,
				bottomNavigationBar: bottomBar
		);
	}
	
	/// 打开章节
	void _openChapter(VCItem chapter) {
		setState(() {
			editorPage.openChapter(chapter);
		});
	}
}
