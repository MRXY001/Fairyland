/// Volume or Chapter Item Base
class VCItem {
  String id;
  String name;
  int indexInBook; // 在全部正文的索引（不包含作品相关）
  String fullName; // 带有章序的章节名
  int indexInList; // 在当前分卷的索引
  DateTime modifyTime; // 修改时间
}

/// 分卷 Item
class VolumeItem extends VCItem {
  List<ChapterItem> chapters;
}

/// 章节 Item
class ChapterItem extends VCItem {
  int wordCount; // 章节有效字数
  String content; // 章节内容
}
