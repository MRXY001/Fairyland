/// Volume or Chapter Item Base
class VCItem {
  static final bookType = 0;
  static final volumeType = 1;
  static final chapterType = 2;
  
  String id; // 分卷/章节在全书中的唯一ID
  String name; // 分卷/章节显示的名字
  int indexInBook; // 在全部正文的索引（不包含作品相关）
  int indexInList; // 在当前分卷的索引（从1开始）
  String fullName; // 带有章序的章节名
  int type; // 0: Book, 1: Volume, 2: Chapter, ?; Other
  int wordCount; // 章节有效字数/该分卷章节总有效字数
  String content; // 章节内容/分卷内容
  DateTime modifyTime; // 修改时间
  List<VCItem> vcList; // 分卷的子章节

  VCItem({this.id, this.name, this.wordCount, this.type, this.vcList});
  
  bool isVolume() => type == volumeType;
  bool isChapter() => type == chapterType;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'wordCount': wordCount,
        'list': vcList
      };

  factory VCItem.fromJson(Map<String, dynamic> json) {
    List vcList;
    int type = json['type'] ?? chapterType;
    if (type == volumeType) {
      List list = json['list'];
      list.forEach((element) {
        vcList.add(VCItem.fromJson(element)); // 递归读取
      });
    }
    return new VCItem(
      id: json['id'],
      name: json['name'],
      type: type,
      wordCount: json['wordCount'] ?? 0,
      vcList: vcList,
    );
  }
}
