class BookObject {
  String id; // 云端分配的ID（未同步则没有）
  String name;
  String author;
  String style;
  String description;
  List<VCItem> catalog;
  BookConfig config;
  int createTime;
  int wordCount;

  BookObject(
      {this.name,
      this.author,
      this.style,
      this.description,
      this.catalog,
      this.config,
      this.createTime,
      this.wordCount});

  Map<String, dynamic> toJson() => {
        'name': name,
        'author': author,
        'style': style,
        'description': description,
        'catalog': catalog,
        'config': config,
        'createTime': createTime,
        'wordCount': wordCount
      };

  factory BookObject.fromJson(Map<String, dynamic> json) {
    List list = json['catalog'];
    List<VCItem> catalog = [];
    list.forEach((element) {
      catalog.add(VCItem.fromJson(element));
    });

    return new BookObject(
      name: json['name'],
      author: json['author'],
      style: json['style'],
      description: json['description'],
      catalog: catalog,
      config: BookConfig.fromJson(json['config']),
      createTime: json['createTime'] ?? 0,
      wordCount: json['wordCount'] ?? 0,
    );
  }
}

/// Volume or Chapter Item Base
class VCItem {
  static final bookType = 0;
  static final volumeType = 1;
  static final chapterType = 2;

  String id; // 分卷/章节在全书中的唯一ID
  String name; // 分卷/章节显示的名字
  int indexInBook; // 在全部正文的章节索引（从1开始，不包含作品相关）
  int indexInVolume; // 在当前分卷的章节索引（从1开始）
  String displayedName; // 带有章序的章节名
  int type; // 0: Book, 1: Volume, 2: Chapter, ?; Other
  int wordCount; // 章节有效字数/该分卷章节总有效字数
  String content; // 章节内容/分卷内容
  int createTime; // 创建时间
  int modifyTime; // 修改时间
  bool published; // 是否已发布
  int publishTime; // 发布时间
  List<VCItem> vcList; // 分卷的子章节

  VCItem({this.id, this.name, this.wordCount, this.type, this.vcList});
  
  bool operator&(VCItem item) {
    return this.id == item.id;
  }

  bool isVolume() => type == volumeType;

  bool isChapter() => type == chapterType;

  /// 设置当前索引
  void setIndexes(int inBook, inVolume) {
    indexInBook = inBook;
    indexInVolume = inVolume;
  }

  /// 获取显示的带序号的名字
  String getDisplayName() {}

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'type': type,
    };
    if (isChapter()) {
      map.addAll({
        'wordCount': wordCount,
      });
    } else {
      map.addAll({'list': vcList});
    }
    return map;
  }

  factory VCItem.fromJson(Map<String, dynamic> json) {
    List<VCItem> vcList;
    int type = json['type'] ?? chapterType;
    if (type == volumeType) {
      // 如果是分卷，遍历加载子分卷和子章节
      List list = json['list'];
      vcList = [];
      if (list != null) {
        // 如果不是null（其实若是null就已经有问题了）
        list.forEach((element) {
          vcList.add(VCItem.fromJson(element)); // 递归读取
        });
      }
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

class BookConfig {
  bool useRelevant = true; // 使用作品相关（第0卷不计算序号）
  bool useArabSerialNumber = false; // 使用阿拉伯数字
  bool recalculateSerialNumber = false; // 每卷里的章节重新计算序号
  String chapterDisplayFormat = '第%s章 %s'; // 章节显示格式（不影响存储）
  String volumeDisplayFormat = '第%s卷 %s'; // 分卷显示格式

  BookConfig(
      {this.useRelevant,
      this.useArabSerialNumber,
      this.recalculateSerialNumber,
      this.chapterDisplayFormat,
      this.volumeDisplayFormat});

  Map<String, dynamic> toJson() => {
        'useRelevant': useRelevant,
        'useArabSerialNumber': useArabSerialNumber,
        'recalculateSerialNumber': recalculateSerialNumber,
        'chapterDisplayFormat': chapterDisplayFormat,
        'volumeDisplayFormat': volumeDisplayFormat
      };

  factory BookConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return new BookConfig();
    }
    return new BookConfig(
      useRelevant: json['useRelevant'] ?? true,
      useArabSerialNumber: json['useArabSerialNumber'] ?? false,
      recalculateSerialNumber: json['recalculateSerialNumber'] ?? false,
      chapterDisplayFormat: json['chapterDisplayFormat'] ?? '第%s章 %s',
      volumeDisplayFormat: json['volumeDisplayFormat'] ?? '第%s卷 %s',
    );
  }
}