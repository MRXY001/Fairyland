/// Volume or Chapter Item Base
class VCItem {
  String id; // 分卷/章节在全书中的唯一ID
  String name; // 分卷/章节显示的名字
  int indexInBook; // 在全部正文的索引（不包含作品相关）
  int indexInList; // 在当前分卷的索引（从1开始）
  String fullName; // 带有章序的章节名
  int wordCount; // 章节有效字数/该分卷章节总有效字数
  String content; // 章节内容/分卷内容
  DateTime modifyTime; // 修改时间
  bool isChapter;
  List<VCItem> vcList;
}