class RuntimeInfo {
  // 路径相关
  String storagePath; // 外部存储目录
  String dataPath; // 应用数据路径
  String booksPath; // 小说路径
  String recyclesPath;
  String recyclesBooksPath; // 回收站路径

  String currentBookName;

  // 路径方法命名规则：PathD 结尾的带分割线（可以理解为 Dir，或 Divider）
  String bookPathD(String name) => booksPath + name + '/';

  String bookCatalogPathD(String name) => booksPath + name + '/catalog.json';

  String cBookPathD() => dataPath + 'books/' + currentBookName + '/';

  String cBookCatalogPathD() => cBookPathD() + '/catalog.json';

  String cBookChaptersPathD() => cBookPathD() + '/chapters/';

  String cBookChapterPath(String id) => cBookChaptersPathD() + id + ".chpt";

  String rBookPathD(String name) => recyclesBooksPath + name + '/';

  String rBookPath(String name) => recyclesBooksPath + name;
}
