/// Volume or Chapter Item Base
class VCItem {
  String name; // 章节/分卷名字
  int indexInBook; // 在全部正文的索引（不包含作品相关）
  int indexInList; // 在当前分卷的索引（从1开始）
  String fullName; // 带有章序的章节名
  DateTime modifyTime; // 修改时间
  bool isChapter;
}

/// 分卷 Item
class VolumeItem extends VCItem {
  String vid;
  List<VCItem> vcList;
}

/// 章节 Item
class ChapterItem extends VCItem {
  String cid; // 章节在全书中的唯一ID（也是文件名）
  int wordCount; // 章节有效字数
  String content; // 章节内容
}
