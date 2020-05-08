import 'dart:math';
import 'package:fairyland/common/global.dart';

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
        //        config: BookConfig.fromJson(json['config']),
        createTime: json['createTime'] ?? 0,
        wordCount: json['wordCount'] ?? 0,
        config: BookConfig.fromJson(json['config']));
  }

  /// 递归设置每一项的 index 和 displayedName
  void setVCItemsContext() {
    int bookV = 0, bookC = 0, volumeV = 0, volumeC = 0, inList = 0;
    for (int i = 0; i < catalog.length; i++) {
      if (!G.us.showCatalogRecycle && catalog[i].isDeleted()) continue;
      if (catalog[i].isVolume()) {
        VCBundle bundle = catalog[i].setIndexes(bookV, volumeV);
        if (!catalog[i].isDeleted()) {
	        bookV += bundle.volume;
	        bookC += bundle.chapter;
	        volumeV++;
        }
      } else if (catalog[i].isChapter()) {
        catalog[i].setIndexes(bookC, volumeC);
        if (!catalog[i].isDeleted()) {
	        volumeC++;
	        bookC++;
        }
      }
      catalog[i].indexInList = inList;
      inList++;
    }

    _setVCItemsDisplayNames();
  }

  /// 设置所有 item 的显示名字
  void _setVCItemsDisplayNames() {
    catalog.forEach((item) {
      setVCItemDisplayName(item, recursive: true);
    });
  }

  /// 设置某一项的名字
  /// @param recursive 是否递归
  void setVCItemDisplayName(VCItem item, {bool recursive: false}) {
    int index;
    String number;
    String name;
    String format;
    // 序号
    if (config.recalculateSerialNumber) {
      index = item.indexInVolume;
    } else {
      index = item.indexInBook;
    }
    if (config.useArabSerialNumber) {
      // TODO: 转换成中文
      number = index.toString();
    } else {
      number = index.toString();
    }
    name = item.name;
    // 格式
    if (item.isVolume()) {
      format = config.volumeDisplayFormat;
    } else if (item.isChapter()) {
      format = config.chapterDisplayFormat;
    }
    item.setDisplayName(format.replaceAll('%1', number).replaceAll('%2', name));

    // 如果是分卷，递归遍历
    if (item.isVolume() && recursive) {
      item.vcList.forEach((item) {
        setVCItemDisplayName(item);
      });
    }
  }

  /// 随机创建一个分卷/章节ID
  String createRandomID() {
    const chi = "abcdefghijklmnopqrstuvwxyz1234567890";
    const len = 6;
    String result = '';
    int repeat = 0;
    do {
      result = '';
      int r = Random().nextInt(chi.length);
      for (int i = 0; i < len; i++) result += chi.substring(r - 1, r);
      if (++repeat > 10000) // 次数太频繁，有问题
        return '000000';
    } while (_isIdExist(result, catalog));
    return result;
  }

  /// 判断随机创建的ID是不是已经存在了
  static bool _isIdExist(String id, List<VCItem> vcList) {
    for (int i = 0; i < vcList.length; i++) {
      if (vcList[i].id == id) return true;
    }
    return false;
  }

  /// 能否作为作品名字
  static bool canBeBookName(String name) {
    if (name.length < 1 || name.length > 30) {
      return false;
    }
    for (int i = 0; i < name.length; i++) {
      String ch = name.substring(i, i + 1);
      if (ch == ' ' ||
          ch == "'" ||
          ch == "/" ||
          ch == ":" ||
          ch == "?" ||
          ch == "<" ||
          ch == ">" ||
          ch == "|" ||
          ch == "\"" ||
          ch == '\\' ||
          ch == '\n' ||
          ch == '\r' ||
          ch == '\t') {
        return false;
      }
    }
    return true;
  }
}

enum VCItemType { BookType, VolumeType, ChapterType }

class VCBundle {
  VCBundle({this.volume, this.chapter});

  int chapter;
  int volume;
}

/// Volume or Chapter Item Base
/// 记录了分卷/章节的信息
class VCItem {
  String id; // 分卷/章节在全书中的唯一ID
  String name; // 分卷/章节显示的名字
  VCItemType type; // 0: Book, 1: Volume, 2: Chapter, ?; Other
  int wordCount; // 章节有效字数/该分卷章节总有效字数
  String content; // 章节内容/分卷内容
  bool opened; // 是否打开
  int createTime; // 创建时间
  int modifyTime; // 修改时间
  bool deleted = false; // 是否已删除
  int deleteTime; // 删除时间
  bool published; // 是否已发布
  int publishTime; // 发布时间
  List<VCItem> vcList; // 分卷的子章节

  VCItem parent;
  int indexInBook; // 在全部正文的索引（从0开始，不包含作品相关）
  int indexInVolume; // 在当前分卷的索引（从0开始，分卷/章节单独计算）
  int indexInList; // 在当前分卷的list索引（从0开始，分卷/章节混合）
  String displayedName; // 带有卷/章序的完整名字

  VCItem(
      {this.id,
      this.name,
      this.wordCount,
      this.type,
      this.vcList,
      this.parent});

  bool operator &(VCItem item) {
    return this.id == item.id;
  }

  bool isVolume() => type == VCItemType.VolumeType;

  bool isChapter() => type == VCItemType.ChapterType;

  bool isDeleted() => deleted;

  /// 递归设置当前索引
  VCBundle setIndexes(int inBook, int inVolume) {
    indexInBook = inBook;
    indexInVolume = inVolume;

    // 如果是 volume，则需要继续递归设置下面
    if (isVolume()) {
      int vCount = 0, cCount = 0; // 自己子级的
      int vSum = 1, cSum = 0; // 全书的，自己也算 vSum
      int inList = 0;
      // 递归子章节
      for (int i = 0; i < vcList.length; i++) {
        if (!G.us.showCatalogRecycle && vcList[i].isDeleted()) continue;
        if (vcList[i].isVolume()) {
          VCBundle bundle = vcList[i].setIndexes(inBook + vSum, vCount);
          if (!vcList[i].isDeleted()) {
	          vCount++;
	          vSum++;
	          vSum += bundle.volume;
	          cSum += bundle.chapter;
          }
        } else if (vcList[i].isChapter()) {
          vcList[i].setIndexes(inBook + cSum, cCount);
          if (!vcList[i].isDeleted()) {
	          cCount++;
	          cSum++;
          }
        }
        vcList[i].indexInList = inList;
        inList++;
      }
      return VCBundle(volume: vSum, chapter: cSum);
    } else {
      return VCBundle(volume: 0, chapter: 0);
    }
  }

  /// 设置显示的名字
  void setDisplayName(String name) {
    this.displayedName = name;
  }

  /// 获取显示的带序号的名字
  String getDisplayName() => displayedName;

  /// 转化成JSON，用来保存至文件
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'type': type.index,
      'opened': opened,
      'deleted': deleted,
      'deleteTime': deleteTime,
      'published': published,
      'publishTime': publishTime,
      'createTime': createTime
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
    int type = json['type'] ?? VCItemType.ChapterType.index;
    if (type == VCItemType.VolumeType.index) {
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

    VCItem item = new VCItem(
        id: json['id'],
        name: json['name'],
        type: VCItemType.values[type],
        wordCount: json['wordCount'] ?? 0,
        vcList: vcList);
    item.opened = json['opened'] ?? false;
    item.deleted = json['deleted'] ?? false;
    item.deleteTime = json['deleteTime'] ?? 0;
    item.published = json['published'] ?? false;
    item.publishTime = json['publishTime'] ?? 0;
    item.createTime = json['createTime'] ?? 0;
    if (vcList != null) {
      vcList.forEach((VCItem i) {
        i.parent = item;
      });
    }
    return item;
  }
}

class BookConfig {
  bool useRelevant = true; // 使用作品相关（第0卷不计算序号）
  bool useArabSerialNumber = false; // 使用阿拉伯数字
  bool recalculateSerialNumber = false; // 每卷里的章节重新计算序号
  String volumeDisplayFormat = '第%s卷 %s'; // 分卷显示格式
  String chapterDisplayFormat = '第%s章 %s'; // 章节显示格式（不影响存储）

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
      return BookConfig.fromJson(Map<String, dynamic>()); // 至少要设置一下默认值
    }
    return new BookConfig(
      useRelevant: json['useRelevant'] ?? true,
      useArabSerialNumber: json['useArabSerialNumber'] ?? false,
      recalculateSerialNumber: json['recalculateSerialNumber'] ?? false,
      chapterDisplayFormat: json['chapterDisplayFormat'] ?? '第%1章 %2',
      volumeDisplayFormat: json['volumeDisplayFormat'] ?? '第%1卷 %2',
    );
  }
}
