class NovelAI {
  static String autoPuncWhitelists = '吗哼呀呢么嘛啦呵吧啊哦哪呸滚';
  static String shuoBlacklists =
      "[白|在|再|再有|接|一直|人|没|持|道|还|样|以|理|明|里|来|么|用|要|一|想|都|是|虽|听|听我|据|再|小|说|是|不|传|如|胡|话|乱|且|假|游|按|邪|述|数|陈|成|称|浅|图|谬|定|解|瞎|劝|妄|解|叙|絮|评|照|论|申|言|演|学|明|好|难|枉|接|实|者|上|一会儿?|被.*|听|不|无.*|让.*|怎么.*|说.*]说";
  static String daoWhiteLists = "，说口嘴的着回答地释述笑哭叫喊吼脸骂";
  static String wenBlackLists = "一请想去若试不莫问想要你我敢来";
  static String symbolPairLefts = "([{（［｛‘“<〈《〔【「『︵︷︹︻︽︿﹁";
  static String symbolPairRights = ")]}）］｝’”>〉》〕】」』︶︸︺︼︾﹀﹂";
  static String sentPuncs = "。？！；~—…?!";
  static String sentSplitPuncs = "，。？！；~—…?!;:\"“”,.";
  static String sentSplits = "\n\t，。？！；~—…?!;:\"“”,.";
  static String quoteNoColons =
      "很常点击倒真是成为其乃就能的作些称作之被有和及选择在会用不起么上下出入与和及跟叫并且可以要非来去离知何啥意一百千万亿为到拿以多少点做为";
  static String quantifiers =
      "局团坨滩根排列匹张座回场尾条个首阙阵网炮顶丘棵只支袭辆挑担颗壳窠曲墙群腔砣座客贯扎捆刀令打手罗坡山岭江溪钟队单双对出口头脚板跳枝件贴针线管名位身堂课本页丝毫厘分钱两斤担铢石钧锱忽毫厘分寸尺丈里寻常铺程撮勺合升斗石盘碗碟叠桶笼盆盒杯钟斛锅簋篮盘桶罐瓶壶卮盏箩箱煲啖袋钵年月日季刻时周天秒分旬纪岁世更夜春夏秋冬代伏辈丸泡粒颗幢堆";
  static String blankChars = "\n\r \t　　";

  /// 获取标点
  static String getPunc(String para, int pos) {}

  /// 获取句子语气
  static int getDescTone(String sent) {}

  /// 获取句子标点
  static String getTalkTone(String sent, String sent2, int tone, String left1,
      String left2, bool inQuote) {}

  /// 是否为中文
  /// @param str 单个字符
  static bool isChinese(String str) {
    return RegExp('^[\\u4e00-\\u9FA5]+\$').hasMatch(str);
  }

  /// 是否为英文单词
  /// @param str 单个字符
  static bool isEnglish(String str) {
    return RegExp('^\\w+\$').hasMatch(str);
  }

  /// 是否为数字
  /// @param str 单个字符
  static bool isNumber(String str) {
    return RegExp('^\\d+\$').hasMatch(str);
  }

  /// 是否为空白符
  /// @param str 单个字符
  bool isBlankChar(String str) {
    return str == ' ' ||
        str == '\t' ||
        str == '\n' ||
        str == '\r' ||
        str == '　';
  }

  /// 是否为换行之外的空白符
  /// @param str 单个字符
  bool isBlankChar2(String str) {
    return str == ' ' || str == '\t' || str == '　';
  }

  /// 是否为空白字符串
  /// @param str 单个字符
  bool isBlankString(String str) {
    for (int i = 0; i < str.length; i++) if (!isBlankChar(str[i])) return false;
    return true;
  }

  /// 是否为“我知道...”格式
  static bool isKnowFormat(String sent) {
    if (sent.indexOf("怎么知") > -1) return false;
    if (sent.indexOf("知道我") > -1) return false;

    if (canRegExp(sent, "知道我.*[怎|什|何|吗|吧]")) return false;

    List<String> knows = [
      "知道",
      "我明",
      "问我",
      "明白",
      "我理",
      "我懂",
      "至于",
      "对于",
      "问我",
      "问他",
      "问她",
      "问它",
      "才知",
      "才明",
      "才理",
      "才懂",
      "于知",
      "于明",
      "于理",
      "于懂",
      "在知",
      "在明",
      "在理解",
      "在咚",
      "我知",
      "问了",
      "说了",
      "问了",
      "我告诉",
      "告诉了",
      "教会"
    ];

    for (int i = 0; i < knows.length; i++)
      if (sent.indexOf(knows[i]) > -1) return true;

    return false;
  }

  static bool canRegExp(String str, String pat) {
    RegExp exp = new RegExp(pat);
    return exp.hasMatch(str);
  }

  /// 是否为句末标点（不包含引号和特殊字符，不包括逗号）
  static bool isSentPunc(String str) {
    return str.isNotEmpty && sentPuncs.contains(str);
  }

  /// 是否为句子分割标点（包含逗号）
  static bool isSentSplitPunc(String str) {
    return str.isNotEmpty && sentSplitPuncs.contains(str);
  }

  /// 是否为句子分割符（各类标点，包括逗号）
  static bool isSentSplit(String str) {
    return str.isNotEmpty && sentSplits.contains(str);
  }

  /// 是否为需要自动添加标点
  static bool isAutoPunc(String str) {
    return str.isNotEmpty && autoPuncWhitelists.contains(str);
  }

  /// 是否为英文标点（不包含引号和特殊字符）
  static bool isASCIIPunc(String str) {
    if (str.isEmpty) return false;
    int uni = str.codeUnitAt(0);
    return ((uni <= 47) ||
        (uni >= 58 && uni <= 63) ||
        (uni >= 91 && uni <= 95) ||
        (uni >= 123 && uni <= 127));
  }

  /// 是否为对称标点左边的
  static bool isSymPairLeft(String str) {
    return str.isNotEmpty && symbolPairLefts.contains(str);
  }

  /// 是否为对称标点右边的
  static bool isSymPairRight(String str) {
    return str.isNotEmpty && symbolPairRights.contains(str);
  }

  /// 根据右边括号获取左边的括号
  static String getSymPairLeftByRight(String str) {
    if (str.isEmpty) return '';
    int pos = symbolPairLefts.indexOf(str);
    if (pos == -1) return '';
    return symbolPairRights[pos];
  }

  /// 根据右边括号获取左边的括号
  static String getSymPairRightByLeft(String str) {
    if (str.isEmpty) return '';
    int pos = symbolPairRights.indexOf(str);
    if (pos == -1) return '';
    return symbolPairLefts[pos];
  }

  /// 汉字后面是否需要加标点
  static bool isQuoteColon(String str) {
    return str.isNotEmpty &&
        !quoteNoColons.contains(str) &&
        !quantifiers.contains(str);
  }
}
