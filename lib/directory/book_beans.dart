class ChapterItem {
  String id;
  String name;
  int indexInRoll; // 在当前分卷的索引
  int indexInBook; // 在全部正文的索引（不包含作品相关）
  String fullName; // 带有章序的章节名
  DateTime time;   // 修改时间
  int wordCount;   // 字数
  String content;  // 内容
}

class RollItem {
  String id;
  String name;
  int indexInBook;
  String fullName;
  List<ChapterItem> chapters;
}
