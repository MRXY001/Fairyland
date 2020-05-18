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
  static int getDescTone(String sent) {
    int tone = -1;

    /*// TODO: 判断高潮模式
    if (us->climax_value >= us->climax_threshold)
      return tone = 1;*/
    if (sent.contains("轻"))
      tone = 0;
    else if (sent.contains("温"))
      tone = 0;
    else if (sent.contains("柔"))
      tone = 0;
    else if (sent.contains("悄"))
      tone = 0;
    else if (sent.contains("淡"))
      tone = 0;
    else if (sent.contains("静"))
      tone = 0;
    else if (sent.contains("小"))
      tone = 0;
    else if (sent.contains("问"))
      tone = 2;
    else if (sent.contains("疑"))
      tone = 2;
    else if (sent.contains("惑"))
      tone = 2;
    else if (sent.contains("不解"))
      tone = 2;
    else if (sent.contains("迷"))
      tone = 2;
    else if (sent.contains("好奇"))
      tone = 2;
    else if (sent.contains("试"))
      tone = 2;
    else if (sent.contains("探"))
      tone = 2;
    else if (sent.contains("询"))
      tone = 2;
    else if (sent.contains("诧"))
      tone = 2;
    else if (sent.contains("愤"))
      tone = 1;
    else if (sent.contains("恼"))
      tone = 1;
    else if (sent.contains("咬"))
      tone = 1;
    else if (sent.contains("怒"))
      tone = 1;
    else if (sent.contains("骂"))
      tone = 1;
    else if (sent.contains("狠"))
      tone = 1;
    else if (sent.contains("火"))
      tone = 1;
    else if (sent.contains("重"))
      tone = 1;
    else if (sent.contains("抓"))
      tone = 1;
    else if (sent.contains("狂"))
      tone = 1;
    else if (sent.contains("叫"))
      tone = 1;
    else if (sent.contains("喊"))
      tone = 1;
    else if (sent.contains("力"))
      tone = 1;
    else if (sent.contains("大"))
      tone = 1;
    else if (sent.contains("哮"))
      tone = 1;
    else if (sent.contains("厉"))
      tone = 1;
    else if (sent.contains("斥"))
      tone = 1;
    else if (sent.contains("吼"))
      tone = 1;
    else if (sent.contains("气"))
      tone = 1;
    else if (sent.contains("震"))
      tone = 1;
    else if (sent.contains("喜"))
      tone = 1;
    else if (sent.contains("惊"))
      tone = 1;
    else if (sent.contains("忙"))
      tone = 1;
    else if (sent.contains("瞪"))
      tone = 1;
    else if (sent.contains("嗔"))
      tone = 1;
    else if (sent.contains("暴"))
      tone = 1;
    else if (sent.contains("咒"))
      tone = 1;
    else if (sent.contains("红"))
      tone = 1;
    else if (sent.contains("痛"))
      tone = 1;
    else if (sent.contains("恐"))
      tone = 1;
    else if (sent.contains("憎"))
      tone = 1;
    else if (sent.contains("眦"))
      tone = 1;
    else if (sent.contains("悲"))
      tone = 1;
    else if (sent.contains("狂"))
      tone = 1;
    else if (sent.contains("重"))
      tone = 1;
    else if (sent.contains("躁"))
      tone = 1;
    else if (sent.contains("铁青"))
      tone = 1;
    else if (sent.contains("狠"))
      tone = 1;
    else if (sent.contains("恨"))
      tone = 1;
    else if (sent.contains("齿"))
      tone = 1;
    else if (sent.contains("急"))
      tone = 1;
    else if (sent.contains("变"))
      tone = 1;
    else if (sent.contains("冲"))
      tone = 1;
    else if (sent.contains("激"))
      tone = 1;
    else if (sent.contains("恶"))
      tone = 1;
    else if (sent.contains("绝"))
      tone = 1;
    else if (sent.contains("瞪"))
      tone = 1;
    else if (sent.contains("愁"))
      tone = 1;
    else if (sent.contains("羞"))
      tone = 1;
    else if (sent.contains("恼"))
      tone = 1;
    else if (sent.contains("忿"))
      tone = 1;
    else if (sent.contains("凶"))
      tone = 1;
    else if (sent.contains("连"))
      tone = 1;
    else if (sent.contains("热"))
      tone = 1;
    else if (sent.contains("欢"))
      tone = 1;
    else if (sent.contains("万"))
      tone = 1;
    else if (sent.contains("得"))
      tone = 1;
    else if (sent.contains("叹"))
      tone = 1;
    else if (sent.contains("兴"))
      tone = 1;
    else if (sent.contains("不已"))
      tone = 1;
    else if (sent.contains("舞"))
      tone = 1;
    else if (sent.contains("天天"))
      tone = 1;
    else if (sent.contains("高"))
      tone = 1;
    else if (sent.contains("昂"))
      tone = 1;
    else if (sent.contains("澎湃"))
      tone = 1;
    else if (sent.contains("颤"))
      tone = 1;
    else if (sent.contains("慌"))
      tone = 1;
    else if (sent.contains("骇"))
      tone = 1;
    else if (sent.contains("跳"))
      tone = 1;
    else if (sent.contains("皆"))
      tone = 1;
    else if (sent.contains("怵"))
      tone = 1;
    else if (sent.contains("霹雳"))
      tone = 1;
    else if (sent.contains("急"))
      tone = 1;
    else if (sent.contains("忙"))
      tone = 1;
    else
      tone = -1;

    return tone;
  }

  /// 获取句子标点
  static String getTalkTone(String sent, String sent2, int tone, String left1,
      String left2, String left3, bool inQuote) {
  
    String punc = "";
  
    if (sent.contains("是不"))
    {
      if (tone == 0)
        punc = "，";
      else if (tone == 1)
        punc = "！";
      else if (canRegExp(sent, "是不.的") == true)
        ;
      else if (sent.contains("本来是不"))
        ;
      else
        punc = "？";
    }
    else if (sent.contains("是么"))
      punc = "？";
    else if (sent.contains("管不管"))
      punc = "？";
    else if (sent.contains("不管"))
      ;
    else if (sent.contains("反正"))
      ;
    else if (sent.contains("怎么知"))
      punc = "？";
    else if (sent.contains("么会"))
      punc = "？";
    else if (sent.startsWith("不知道") && !inQuote)
      punc = "，";
    else if (sent.contains("真") && !sent.contains("真理") && !sent.contains("真假") && !sent.contains("真事") && !canRegExp(sent, "真.{0,3}不是"))
    {
      if (sent.contains("真的") || sent.contains("真是"))
      {
        if (sent.contains("真的是") || sent.contains("真是"))
        {
          if (sent.contains("啊"))
            punc = "！";
          else if (sent.contains("吗"))
            punc = "？";
          else if (sent.contains("啦"))
            punc = "！";
          else if (sent.contains("呀"))
            punc = "！";
          else if (sent.contains("了"))
            if (sent.contains("太") || sent.contains("好"))
              punc = "！";
            else
              punc = "？";
          else if (tone == 1)
            punc = "！";
          else if (tone == 2)
            punc = "？";
          else if (sent.contains("真是不"))
            punc = "！";
          else
          {
          }
        }
        else if (sent == "真的")
        {
          if (tone == 2)
            punc = "？";
          else if (sent.contains("好吗"))
            punc = "？";
          else if (sent.contains("太") || sent.contains("好"))
            punc = "！";
          else
          {}
        }
        else if (sent.contains("真的好") || sent.contains("真的很") || sent.contains("真的非常") || sent.contains("真的太") || sent.contains("真的特"))
        {
          if (sent.contains("吗"))
            punc = "？";
          else if (tone == 0)
            ;
          else if (tone == 2)
            punc = "？";
          else
            punc = "！";
        }
        else if (sent.contains("怎么"))
        {
          if (canRegExp(sent, "怎么也.*不"))
            ;
          else
            punc = "？";
        }
        else if (sent.contains("难道"))
          punc = "？";
        else if (isKnowFormat(sent) == true)
          ;
        else if (sent.contains("真的是我"))
          ;
        else if (sent.contains("如何"))
          punc = "？";
        else if (sent.endsWith("啊") || sent.endsWith("啦") || sent.endsWith("呀") || sent.endsWith("呢"))
          punc = "！";
        else if (sent.endsWith("吗"))
          punc = "？";
        else if (tone == 1)
          punc = "！";
        else if (tone == 2)
          punc = "？";
        else if (sent.contains("真的不是"))
          ;
        else if (sent.contains("不是"))
          punc = "？";
        else
        {}
      }
      else if (sent.contains("你真"))
      {
        if (sent.contains("不") || sent.contains("了"))
        {
          if (tone == 1)
            punc = "！";
          else if (tone == 0)
            ;
          else
            punc = "？";
        }
        else if (tone == 2 || sent.endsWith("吗"))
          punc = "？";
        else if (tone == 0)
          ;
        else if (sent.endsWith("啊") || sent.endsWith("啦") || sent.endsWith("呀") || sent.endsWith("呢"))
          punc = "！";
        else if (sent.endsWith("吗"))
          punc = "？";
        else
          punc = "！";
      }
      else if (sent.contains("他真"))
      {
        if (sent.contains("不") || sent.contains("了"))
        {
          if (tone == 1)
            punc = "！";
          else if (tone == 0)
            ;
          else
            punc = "？";
        }
        else if (tone == 2)
          punc = "？";
        else if (tone == 0)
          ;
        else if (sent.endsWith("啊") || sent.endsWith("啦") || sent.endsWith("呀") || sent.endsWith("呢"))
          punc = "！";
        else if (sent.endsWith("吗"))
          punc = "？";
        else
          punc = "！";
      }
      else if (sent.contains("她真"))
      {
        if (sent.contains("不") || sent.contains("了"))
        {
          if (tone == 1)
            punc = "！";
          else if (tone == 0)
            ;
          else
            punc = "？";
        }
        else if (tone == 2)
          punc = "？";
        else if (tone == 0)
          ;
        else if (sent.endsWith("啊") || sent.endsWith("啦") || sent.endsWith("呀") || sent.endsWith("呢"))
          punc = "！";
        else if (sent.endsWith("吗"))
          punc = "？";
        else
          punc = "！";
      }
      else if (isKnowFormat(sent) == true)
        ;
      else if (tone == 1)
        punc = "！";
      else if (tone == 2)
        punc = "？";
      else if (sent.endsWith("啊") || sent.endsWith("啦") || sent.endsWith("呀") || sent.endsWith("呢"))
        punc = "！";
      else if (sent.endsWith("吗"))
        punc = "？";
      else
      {}
    }
    else if (sent.contains("太") && "了啦吧".indexOf(sent.substring(sent.length-1)) > -1) // 带“太”的都是厉害的，除了部分名词，应该都是感叹号
      punc = "！";
    else if (canRegExp("不过.+太", sent))
      ;
    else if (sent.contains("是否"))
    {
      if (isKnowFormat(sent) == true)
        ;
      else
        punc = "？";
    }
    else if (sent.contains("是不是"))
    {
      if (isKnowFormat(sent) == true)
        ;
      else if (tone == 1)
        punc = "！";
      else if (tone == 0)
        ;
      else
        punc = "？";
    }
    else if (sent.contains("可能是") && canRegExp(sent, ".*[特别|真的|格外|非常].*") == true)
      punc = "！";
    else if (sent.contains("知不知"))
      punc = "？";
    else if (sent.contains("需不需"))
    {
      if (isKnowFormat(sent) == true && !sent.contains("怎么") && !sent.contains("为什么"))
        ;
      else
        punc = "？";
    }
    else if (sent.contains("要不要"))
    {
      if (isKnowFormat(sent) == true)
        ;
      else if (!sent.contains("你"))
        punc = "？";
      else if (sent.contains("犹豫要") || sent.contains("在想") || sent.contains("思考"))
        ;
      else
        punc = "？";
    }
    else if (sent.contains("要不是"))
      ;
    else if (canRegExp(sent, "(.{1,2})不\\1") == true)
    {
      if (isKnowFormat(sent) == true && !sent.contains("怎么") && !sent.contains("为什么") && !sent.contains("难道"))
        ;
      else if (sent.contains("时不时"))
        ;
      else
        punc = "？";
    }
    else if (sent.length  > 2 && sent.substring(sent.length-1) == "不" && !sent.contains("不不"))
      punc = "？";
    else if ( sent.contains("还不") || canRegExp(sent, "^(你他她)们?(怎么|为什么|干嘛|为何)还(没|不)"))
    {
      if (sent.contains("给我"))
        punc = "！";
      else if (tone == 1)
        punc = "！";
      else if (tone == 0)
        ;
      else if (sent.contains("甚至"))
        ;
      else if (sent.contains("吧"))
        punc = "？";
      else if (sent.contains("吗"))
        punc = "？";
      else if (sent.contains("嘛"))
        punc = "？";
      else if (sent.contains("啊"))
        punc = "！";
      else if (sent.contains("不至于"))
        ;
      else if (sent.contains("不如"))
        ;
      else
        punc = "？";
    }
    else if (sent.contains("不要") && !sent.contains("吗") && !sent.contains("吧") && !sent.contains("呢") && !sent.contains("了"))
    {
      if (inQuote)
        punc = "！";
      else
        ;
    }
    else if (sent.contains("不可思议"))
      punc = "！";
    else if (sent.contains("誓不"))
      punc = "！";
    else if (sent.contains("都要") && !sent.contains("吗") && !sent.contains("吧") && !sent.contains("呢") && !sent.contains("了"))
    {
      if (sent.contains("你都要") && sent.contains("这") && sent.indexOf("这") > sent.indexOf("你都要"))
        punc = "？";
      else
        punc = "！";
    }
    else if (sent == "我要")
      punc = "！";
    else if (sent == "不要")
      punc = "！";
    else if (sent == "要")
      ;
    else if (sent == "反正")
      ;
    else if (sent == "那就是说" && sent.length  > 6 && sent.substring(sent.length-1) == "了")
    {
      if (tone == 1)
        punc = "！";
      else if (tone == 0)
        punc = "。";
      else
        punc = "？";
    }
    else if (sent.contains("绝对"))
      punc = "！";
    else if (sent.contains("一定") && !sent.contains("有一定") && !sent.contains("一定的") && !sent.contains("不一定") && !sent.contains("一定的"))
      punc = "！";
    else if (sent.contains("你居然"))
      punc = "！";
    else if (sent.contains("甚至"))
      punc = "！";
    else if (sent.contains("简直"))
      punc = "！";
    else if (sent.contains("必定"))
      punc = "！";
    else if (sent.contains("要不"))
    {
      if (sent == "要不")
        punc = "，";
      else
        punc = "？";
    }
    else if (sent.contains("可不") && (sent.contains("可不可") || sent.endsWith("可不")))
      punc = "？";
    else if (sent.contains("行不"))
      punc = "？";
    else if (sent.contains("不就"))
      punc = "？";
    else if (sent.contains("多少"))
    {
      if (sent.contains("没"))
        ;
      else if (sent.indexOf("多少") < sent.indexOf("是"))
        ;
      else if (tone == 1)
        punc = "！";
      else if (tone == 0)
        ;
      else if (isKnowFormat(sent) == true)
        ;
      else
        punc = "？";
    }
    else if (sent.contains("多久"))
    {
      if (sent.contains("没") && sent.indexOf("没") < sent.indexOf("多久"))
        ;
      else if (sent.contains("没多久"))
        ;
      else if (tone == 1)
        punc = "！";
      else if (tone == 0)
        ;
      else if (isKnowFormat(sent) == true)
        ;
      else
        punc = "？";
    }
    else if (sent.contains("有多"))
    {
      if (tone == 1)
        punc = "！";
      else if (tone == 0)
        punc = "。";
      else if (isKnowFormat(sent) == true)
        ;
      else
        punc = "？";
    }
    else if (sent.contains("都要"))
    {
      if (tone == 2)
        punc = "？";
      else if (tone == 0)
        ;
      else
        punc = "！";
    }
    else if (canRegExp(sent, ".{1,3}(无论|不管)(怎么|什么|任意|任何)") && !sent.contains("真的"))
    {
    
    }
    else if (sent.contains("么"))
    {
      if (sent.contains("什么"))
      {
        int shenme_pos = sent.indexOf("什么");
        if (tone == 1)
          punc = "！";
        else if (tone == 2)
          punc = "？";
        else if (tone == 0)
          ;
        else if (sent.contains("还"))
        {
          if (isKnowFormat(sent) == true)
            ;
          else if (sent.contains("以为"))
            ;
          else
            punc = "？";
        }
        else if (sent.contains("似乎"))
          ;
        else if (sent.contains("好像"))
          ;
        else if (sent.contains("不") && sent.indexOf("不") < sent.indexOf("什么"))
          ;
        else if (sent.contains("不了"))
        {
          if (tone == 1)
            punc = "！";
          else
          {}
        }
        else if (!sent.contains("怎么") && canRegExp(sent, "什么.*都"))
          ;
        else if (sent.contains("都不"))
          ;
        else if (sent.contains("都") && sent.contains("来"))
          ;
        else if (sent.contains("或许"))
          ;
        else if (sent.contains("说不定"))
          ;
        else if (sent.contains("可能"))
          ;
        else if (sent.contains("仿佛"))
          ;
        else if (sent.contains("要发生什么"))
          ;
        else if (sent.contains("没") && sent.indexOf("没") < shenme_pos)
          ;
        else if (sent.contains("肯定") && sent.indexOf("肯定") < shenme_pos)
          ;
        else if (sent.contains("决定"))
          ;
        else if (sent.contains("不出"))
          ;
        else if (sent.contains("不是") && sent.indexOf("不是") < shenme_pos)
          ;
        else if (sent.contains("不到") && sent.indexOf("不到") < shenme_pos)
          ;
        else if (sent.contains("不了"))
          ;
        else if (sent.contains("没有什么") || sent.contains("没什么") || sent.contains("无什么") || canRegExp("不.{1,3}什么", sent))
          ;
        else if (sent.contains("多么"))
        {
          if (sent.contains("啊"))
            punc = "！";
          else
          {}
        }
        else if (sent.contains("什么都"))
        {
          if (sent.contains("怎么"))
            if (sent.contains("不"))
              ;
            else
              punc = "？";
          else if (sent.contains("什么都要"))
            punc = "！";
          else
          {}
        }
        else if (sent.contains("什么的"))
          ;
        else if (sent.contains("的什么东西"))
          ;
        else if (sent.contains("说了什么") && sent.indexOf("的", sent.indexOf("说了什么") + 1) > -1)
          ;
        else if (sent.contains("到底"))
          punc = "！";
        else if (sent.contains("情况"))
          punc = "？";
        else if (isKnowFormat(sent) == true)
          ;
        else
          punc = "？";
      }
      else if (sent.contains("怎么") && !sent.contains("不怎么") && !sent.contains("怎么也"))
      {
        if (isKnowFormat(sent) == true && !sent.contains("都知道"))
        {
          if (sent.contains("怎么知"))
            punc = "？";
          else if (sent.contains("怎么懂"))
            punc = "？";
          else if (canRegExp(sent, "我.*[教|告|诉|帮].*怎么"))
            ;
          else if (tone == 2)
            punc = "？";
          else if (tone == 1)
            punc = "！";
          else
          {}
        }
        else if (tone == 1)
          punc = "！";
        else if (tone == 0)
          ;
        else if (sent == "怎么")
          punc = "，";
        else if (sent.contains("吗"))
          punc = "？";
        else if (sent.contains("啊"))
          punc = "？";
        else if (sent.contains("吧"))
          punc = "？";
        else if (sent.contains("呢"))
          punc = "？";
        else if (sent.contains("嘛"))
          punc = "？";
        else if (sent.contains("看到"))
          ;
        else if (sent.contains("其实"))
          ;
        else if (sent.contains("发现"))
          ;
        else if (sent.contains("怎么就"))
          punc = "！";
        else
          punc = "？";
      }
      else if (sent.contains("要么"))
        punc = "，";
      else if (sent.contains("不怎"))
        ;
      else if (sent.contains("怎样"))
      {
        if (isKnowFormat(sent) == true || sent.contains("不怎样"))
          ;
        else
          punc = "？";
      }
      else if (sent.contains("么么"))
        punc = "~";
      else if (sent.contains("么又"))
      {
        if (tone == 1)
          punc = "！";
        else if (tone == 0)
          ;
        else
          punc = "？";
      }
      else if (sent.contains("这么") && tone == 2)
        punc = "？";
      else if (sent.contains("这么"))
      {
        if (sent.contains("果然"))
          punc = "。";
        else
          punc = "！";
      }
      else if (sent.contains("那么") && (tone == 1 || sent.endsWith("吧")) )
        punc = "！";
      else if (sent.contains("那么") && (tone == 2 || sent.endsWith("吗")))
        punc = "？";
      else if (sent.contains("那么"))
        ;
      else if (sent.contains("多么"))
        if (sent.contains("啊") || sent.contains("呀") || sent.contains("呢") || sent.contains("诶"))
          punc = "！";
        else
        {}
      else if (sent.contains("饿了么"))
        ;
      else
        punc = "？";
    }
    else if (sent.contains("难道"))
    {
      if (sent == "难道")
        punc = "，";
      else
        punc = "？";
    }
    else if (sent.contains("怎样") && !sent.contains("不怎样"))
    {
      if (isKnowFormat(sent) == true && sent.contains("我") && !sent.contains("怎么") && sent.indexOf("知") < sent.indexOf("怎样") && sent.indexOf("明") < sent.indexOf("怎样") && sent.indexOf("懂", 0) < sent.indexOf("怎样"))
        ;
      else
        punc = "？";
    }
    else if (sent.startsWith("怎") || sent.contains("又怎"))
      punc = "？";
    else if (sent.contains("何"))
    {
      if (sent.contains("奈何"))
        ;
      else if (sent.contains("如何"))
      {
        if (sent.contains("无论") || sent.contains("不管") || isKnowFormat(sent) == true)
          if (tone == 1)
            punc = "！";
          else
          {}
        else
          punc = "？";
      }
      else if (sent.contains("任何"))
      {
        if (tone == 2 && isKnowFormat(sent) == false)
          punc = "？";
        else if (tone == 1)
          punc = "！";
        else
        {}
      }
      else if (sent.contains("为何"))
      {
        if (isKnowFormat(sent) == true)
        {
          if (sent.contains("何不知"))
            punc = "？";
          else
          {}
        }
        else
          punc = "？";
      }
      else if (sent.contains("何况") || sent.contains("何人") || sent.contains("何事") || sent.contains("何时") || sent.contains("何且"))
        punc = "？";
      else if (sent.contains("何等"))
      {
        if (sent.contains("啊"))
          punc = "！";
        else
        {}
      }
      else if (tone == 0)
        ;
      else if (tone == 1)
        punc = "！";
      else if (sent.contains("几何"))
        ;
      else if (sent.contains("何来"))
        punc = "！";
      else
        punc = "？";
    }
    else if (sent.contains("不如") && inQuote && canRegExp(sent, "不如.+(\\S+)\\1"))
      punc = "？";
    else if (inQuote && sent.contains("几") && ( tone == 2 || sent.contains("几点") || sent.contains("几时") || sent.contains("样了") ||
        (sent.startsWith("几") && sent.endsWith("了")) || (sent.contains("你") && sent.indexOf("你") < sent.indexOf("几")) ) )
      punc = "？";
    else if (sent.contains("谁") && !sent.contains("谁也"))
    {
      if (sent.contains("谁知") && sent.indexOf("谁知") < sent.indexOf("就"))
        punc = "！";
      else if (sent.contains("谁知") && sent.contains("然"))
        ;
      else if (tone == 1)
        punc = "！";
      else if (sent.contains("谁说") || sent.contains("谁让"))
        punc = "？";
      else
        punc = "？";
    }
    else if (canRegExp(sent, "当.+时") == true)
    {
      if (sent.contains("难道"))
        punc = "？";
      else
      {}
    }
    else if (sent.contains("啥"))
    {
      if (isKnowFormat(sent) == true)
        punc = "。";
      else
        punc = "？";
    }
    else if (sent.contains("哪"))
    {
      if (tone == 0)
        punc = "。";
      else if (tone == 1)
        punc = "！";
      else if (sent.contains("天哪"))
        punc = "！";
      else if (sent.contains("哪怕"))
        ;
      else if (sent == "哪里")
        ;
      else
        punc = "？";
    }
    else if (sent.contains("居然") && sent.length  >= 3 && sent.substring(sent.length-3).indexOf("居然") > -1)
      punc = "……";
    else if (sent.contains("居然"))
    {
      if (tone == 2)
        punc = "？";
      else if (tone == 0)
      {
        if (sent.length > 5)
          punc = "。";
        else
        {}
      }
      else if (sent.contains("知") || sent.contains("发") || sent.contains("到"))
        ;
      else
        punc = "！";
    }
    else if ((sent.startsWith("虽然") || sent.startsWith("然而") || sent.startsWith("但") || sent.startsWith("最后") || sent.contains("接着") || sent.contains("然后") || sent.contains("之后") || sent.contains("至少"))
        && "吗呢吧呀啊".indexOf(sent.substring(sent.length-1)) == -1)
      ;
    else if (sent.contains("也不能") && sent.indexOf("也不能")<= 2 && "吗呢".indexOf(sent.substring(sent.length-1)) == -1)
      ;
    else if (sent.contains("听说"))
    {
      if (tone == 0 || sent.contains("就听说") || sent.contains("一些") || sent.contains("还没") || sent.indexOf("不是") > sent.indexOf("听说")
          || sent == "听说" || sent.indexOf("前") > sent.indexOf("听说") || sent.contains("时") || sent.contains("听说过") || sent.contains("却")
          || (sent.contains("没听说") && "吧吗啊".indexOf(sent.substring(sent.length-1)) > -1) || sent.contains("都听说")
          || sent.indexOf("她") > sent.indexOf("听说")|| sent.indexOf("他") > sent.indexOf("听说")|| sent.indexOf("它") > sent.indexOf("听说")
          || sent.endsWith("听说") || sent.contains("这"))
        ;
      else if (tone == 1)
        punc = "！";
      else if (canRegExp(sent, "听说你.*?什么都.+"))
        punc = "?";
      else
        punc = "？";
    }
    else if (sent.contains("谢谢"))
    {
      if (sent == "谢谢" || sent == "谢谢你" || sent == "谢谢您") // 为了效率才特判
        punc = "！";
      else if (tone == 2 || sent.endsWith("吗"))
        punc = "？";
      else if (sent.endsWith("呦"))
        punc = "~";
      else if (canRegExp(sent, "谢谢.*[他她它]"))
        ;
      else
        punc = "！";
    }
    else if (sent.contains("多谢"))
      punc = "！";
    else if (sent.contains("貌似"))
    {
      if (tone == 0)
        ;
      else if (tone == 1)
        punc = "！";
      else
        punc = "？";
    }
    else if (sent.contains("有没有") || sent.contains("有木有"))
    {
      if (sent.contains("知道"))
        ;
      else if (tone == 1)
        punc = "！";
      else
        punc = "？";
    }
    else if (sent.contains("至少"))
    {
      if (sent == "至少")
        punc = "，";
      else if (tone == 0)
        ;
      else if (tone == 2)
        punc = "？";
      else
        punc = "！";
    }
    else if (sent.contains("想必"))
    {
      if (tone == 0)
        ;
      else
        punc = "？";
    }
    else if (sent.contains("站住"))
      punc = "！";
    else if (sent.contains("然又") || sent.contains("又来"))
    {
      if (tone == 2 || sent.contains("吗"))
        punc = "？";
      else
        punc = "！";
    }
    else if (sent.contains("了没") && isKnowFormat(sent) == false)
      punc = "？";
    else if (sent.contains("了什") && isKnowFormat(sent) == false )
      punc = "？";
    else if (sent.contains("不知"))
    {
      if (isKnowFormat(sent) == true && sent.substring(sent.length-2) == "知道")
        punc = "，";
      else if (tone == 0)
        ;
      else if (tone == 1)
        punc = "！";
      else if (sent.contains("知过"))
        ;
      else if (sent.length  > 7 && sent.substring(0, 3) == "不知道" && sent.substring(sent.length-1) == "的")
        punc = "？";
      else if (sent.contains("然不知"))
        punc = "，";
      else if (sent.contains("知所"))
        punc = "，";
      else if (sent.contains("知不"))
        punc = "，";
      else if (sent.contains("知者"))
        punc = "，";
      else if (sent.contains("知火"))
        punc = "，";
      else if (sent.contains("知之"))
        punc = "，";
      else if (sent.contains("知的"))
        punc = "，";
      else if (sent.contains("还不") && sent.contains("呢"))
        punc = "！";
      else
        punc = "？";
    }
    else if (sent.contains("干嘛"))
    {
      if ( !sent.contains("你") && isKnowFormat(sent) == true)
        punc = "，";
      else
        punc = "？";
    }
    else if (sent.contains("也算") || sent.contains("算是"))
    {
      if (tone == 2)
        punc = "？";
      else if (tone == 1)
        punc = "！";
      else if (sent.contains("吗"))
        punc = "？";
      else if (sent.contains("呢"))
        punc = "！";
      else if (sent.contains("嘛"))
        punc = "！";
      else if (sent.contains("吧"))
      {
        if (sent.contains("这") || sent.contains("那") )
        {
          if (sent.contains("也算"))
            punc = "？";
          else
            punc = "！";
        }
        else
          punc = "！";
      }
      else
      {}
    }
    else if (sent.contains("百分百"))
    {
      if (tone == 2)
        punc = "？";
      else if (tone == 0)
        ;
      else
        punc = "！";
    }
    else if (sent.contains("听说你") || sent.contains("听说他") || sent.contains("听说她") || sent.contains("听说这") || sent.contains("听说那"))
    {
      if (tone == 2 || sent.contains("啊") || sent.contains("吗") || sent.contains("吧"))
        punc = "？";
      else if (tone == 0)
        ;
      else if (tone == 1 || sent.contains("呢"))
        punc = "！";
      else
        punc = "？";
    }
    else if (sent.contains("彻底"))
    {
      if (tone == 2)
        punc = "？";
      else if (tone == 0)
        ;
      else
        punc = "！";
    }
    else if (sent.contains("到底"))
    {
      if (tone == 2)
        punc = "？";
      else if (tone == 0)
        ;
      else
        punc = "！";
    }
    else if (sent.endsWith("极了"))
      punc = "！";
    else if (sent.contains("岂有此理"))
      punc = "！";
    else if (sent.contains("恐怖如此"))
      punc = "！";
    else if (sent.contains("岂"))
      punc = "？";
    else if (sent.contains("真的"))
      punc = "？";
    else if (sent.contains("而且是"))
      punc = "？";
    else if (sent.contains("多久"))
    {
      if (isKnowFormat(sent) == true)
        ;
      else
        punc = "？";
    }
    else if (sent.contains("莫非"))
    {
      if (sent == "莫非")
        punc = "……";
      else
        punc = "？";
    }
    else if (sent.contains("其实"))
    {
      if (sent == "其实")
        ;
      else
      {}
    }
    else if (sent == "当心" || sent == "小心")
      punc = "！";
    else if (sent.contains("当真"))
      punc = "？";
    else if (sent.contains("你敢"))
    {
      if (sent == "你敢")
        punc = "！";
      else
        punc = "？";
    }
    else if (sent.contains("你确定"))
      punc = "？";
    else if (sent.contains("你肯定"))
      punc = "？";
    else if (sent.contains("定") && canRegExp(sent, "[必定|一定|肯定|定要|定把|定将|定会|定能|定可|定是|定非]") == true && !sent.contains("不一定") && !sent.contains("不") && !sent.contains("确定") && !sent.contains("稳定") && !sent.contains("待定") && !sent.contains("决定") && !sent.contains("下定") && !sent.contains("定理") && !sent.contains("定义") && !sent.contains("不定") && !sent.contains("没") && !sent.contains("定时") && !sent.contains("定期") && !sent.contains("安定") && !sent.contains("设定") && !sent.contains("定点") && !sent.contains("平定") && !sent.contains("定力"))
    {
      if (sent.contains("你确定"))
        punc = "？";
      else if (sent.contains("确定"))
        ;
      else
        punc = "！";
    }
    else if (sent.contains("滚") && !sent.contains("打滚") && !sent.contains("翻滚") && !sent.contains("滚动") && !sent.contains("靠滚"))
      punc = "！";
    else if (sent.contains("混账") || sent.contains("混蛋") || sent.contains("可恶") || sent.contains("变态") || sent.contains("难以置信"))
    {
      if (tone == 2)
        punc = "？";
      else if (tone == 0)
        ;
      else
        punc = "！";
    }
    else if (sent.contains("相信"))
    {
      if (sent == "我相信" || sent == "相信")
        punc = "，";
      else
        punc = "！";
    }
    else if (sent.contains("不信"))
      punc = "！";
    else if (sent.contains("加油"))
      punc = "！";
    else if (sent.contains("还是"))
    {
      if (tone == 0)
        ;
      else if (inQuote == true)
      {
        if (tone == 2)
          punc = "？";
        else
          punc = "！";
      }
      else if (sent == "还是")
        punc = "？";
      else if (sent.substring(sent.length-1) == "的" || sent.contains("果然"))
        ;
      else if (sent.contains("居然") || sent.contains("竟然"))
        punc = "！";
      else if (sent.contains("还是没有") && !sent.contains("你还是"))
        ;
      else
      {
        if ("吗嘛呢".indexOf(left1) > -1)
          punc = "？";
        else if (left1 == "吧")
          punc = "！";
        else if (sent.contains("我还是"))
          punc = "！";
        else if (left1 == "但还是")
          ;
        else if ("吧啊嘛哈".indexOf(left1) > -1)
          punc = "！";
        else
        {}
      }
    }
    else if (sent.contains("不可能"))
    {
      if (tone == 1)
        punc = "！";
      else if (tone == 2)
        punc = "？";
      else
      {}
    }
    else if (sent.startsWith("你还在") || sent.startsWith("你也在"))
    {
      if (tone == 1)
        punc = "！";
      else if (tone == 0)
        ;
      else
        punc = "？";
    }
    else if (sent.startsWith("还是先") && sent2.indexOf("先") > -1)
      punc = "？";
    else if (sent.contains("不就"))
    {
      if (tone == 0)
        ;
      else if (tone == 1)
        punc = "！";
      else
        punc = "？";
    }
    else if (sent.contains("有点") && "啊吗呢吧呀么".indexOf(sent.substring(sent.length-1)) == -1)
      ;
    else if (sent.contains("斩"))
    {
      if (tone == 2)
        punc = "？";
      else if (tone == 0)
        ;
      else
        punc = "！";
    }
    else if (sent.contains("简直"))
      punc = "!";
    else if (sent.startsWith("巴不得") && (sent.endsWith("呢")))
      punc = "！";
    else if (sent.contains("不成") && (
        canRegExp(sent, "还.{1,5}不成") || sent.contains("成不成")))
      punc = "？";
    else if (canRegExp(sent, "你[更最].+的.+"))
      punc = "？";
    else if (sent.contains("杀"))
    {
      if (tone == 2)
        punc = "？";
      else if (tone == 0)
        ;
      else if (sent.length  >= 2 && sent.substring(0, 1) == "杀")
        ;
      else if (sent.length  >= 2 && sent.substring(sent.length-1) == "杀")
        ;
      else if (sent.contains("被"))
        ;
      else if (sent.contains("我不"))
        ;
      else if (sent.contains("杀了你"))
        punc = "！";
      else if (sent.contains("我杀"))
        ;
      else if (sent.contains("杀掉"))
        punc = "！";
      else
      {}
    }
    else if (sent.contains("死"))
    {
      if (tone == 2)
        punc = "？";
      else if (tone == 0)
        ;
      else if (sent.contains("濒死"))
        ;
      else if (sent.contains("死活"))
        ;
      else if (sent.contains("死寂"))
        ;
      else if (sent.contains("死不"))
        ;
      else if (sent.contains("不死"))
      {
        if (sent.contains("啊"))
          punc = "？";
        else
        {}
      }
      else
        punc = "！";
    }
    else if (sent.length  >= 4 && sent.substring(0, 1) == "快")
    {
      if (tone == 0)
        ;
      else
        punc = "！";
    }
    else if (tone == -1 && sent.contains("貌似") && sent.contains("要"))
      ;
    else if (left1 == "了")
    {
      if (tone == 1)
        punc = "！";
      else if (tone == 2)
        punc = "？";
      else if (tone == 3)
        punc = "~";
      else
      {}
    }
    else if (left1 == "吗")
    {
      if (tone == 1)
        punc = "！";
      else if (tone == 0)
        ;
      else if (tone == 3)
        punc = "~";
      else
        punc = "？";
    }
    else if (left1 == "吧")
    {
      if (tone == 1)
        punc = "！";
      else if (tone == 0)
        ;
      else if (tone == 3)
        punc = "~";
      else if (sent.contains("没"))
        punc = "？";
      else if (left2 == "心")
        punc = "，";
      else if (sent.contains("你还"))
        punc = "？";
      else if (sent.contains("似乎"))
        punc = "？";
      else if (sent.contains("会") && sent.contains("我") && sent.indexOf("我") < sent.indexOf("会"))
        punc = "？";
      else if (sent.contains("不说"))
        ;
      else if (sent.contains("还"))
        ;
      else if (sent.contains("酒吧"))
        ;
      else if (sent.contains("网吧"))
        ;
      else if (sent.contains("咖啡吧"))
        ;
      else if (sent.contains("第") && sent.contains("次"))
      {
        if (tone == 2)
          punc = "？";
        else if (inQuote)
          punc = "？";
        else if (sent.contains("你"))
          punc = "？";
        else
          punc = "！";
      }
      else if (sent.contains("再"))
        punc = "！";
      else if (sent.contains("因为"))
        punc = "！";
      else if (sent.contains("就是"))
        punc = "！";
      else if (sent.startsWith("这是"))
        punc = "？";
      else if (sent.contains("是"))
        punc = "？";
      else if (sent.contains("这也"))
        punc = "？";
      else if (left2 == "的")
        punc = "？";
      else if (canRegExp(sent, "就.{1,3}了吧"))
        punc = "？";
      else
        punc = "！";
    }
    else if (left1 == "啊")
    {
      if (sent.contains("还是"))
        punc = "！";
      else if (sent.contains("你还"))
        punc = "？";
      else if (sent == "不过啊")
        punc = "，";
      else if (sent == "但是啊")
        punc = "，";
      else if (sent == "你想啊")
        punc = "，";
      else if (sent.substring(sent.length-3).contains("后"))
        punc = "，";
      else if ((sent.indexOf("啊") < sent.length - 1 && sent.substring(sent.length-2, sent.length-1) != "啊") || tone == 0)
        ;
      else if (tone == 1)
        punc = "！";
      else if (tone == 2)
        punc = "？";
      else if (isChinese(left2) == true)
        punc = "！";
      else
        punc = "！";
    }
    else if (left1 == "呢")
    {
      if (sent.contains("如果") || sent.contains("要是") || sent.startsWith("而") || sent.contains("哪"))
        punc = "？";
      else if (sent.contains("还是") || sent.contains("就是") || sent.contains("毕竟"))
        punc = "！";
      else if (sent .contains("起来") && sent .indexOf("起来") <= 2)
        punc = "！";
      else if (sent.startsWith("我") || sent.contains("很") || sent.contains("特别") || sent.contains("格外")
          || sent.contains("非常") || sent.contains("太") || sent.contains("真") || sent.contains("确"))
        punc = "！";
      else if (canRegExp(sent, "还.+了呢\$") || canRegExp(sent, ".{1,3}着.*呢\$"))
        punc = "！";
      else if (canRegExp(sent, ".+了.+呢\$"))
        punc = "？";
      else
        punc = "？";
    }
    else if (left1 == "呀")
    {
      if (sent == "什么呀")
        punc = "，";
      else if (sent.contains("什么"))
        punc = "？";
      else if (sent == "哎呀")
        punc = "，";
      else if (canRegExp(sent, "不.{1,3}呀"))
        punc = "！";
      else if (sent.contains("呀呀"))
        ;
      else if (sent.contains("来呀"))
        ;
      else if (tone == 1)
        punc = "！";
      else if (tone == 2)
        punc = "？";
      else
        punc = "！";
    }
    else if (left1 == "哦")
    {
      if (isChinese(left2) == true)
        punc = "！";
      else
        punc = "？";
    }
    else if (left1 == "哈")
    {
      if (left1 == "哈" || isChinese(left2) == false)
        punc = "！";
      else
      {}
    }
    else if (left1 == "哼")
      punc = "！";
    else if (left1 == "唉")
    {
      if (tone == 0)
        ;
      else if (tone == 2)
        punc = "？";
      else
        punc = "！";
    }
    else if (left1 == "嘛")
    {
      if (sent.contains("就"))
        punc = "！";
      else if (isKnowFormat(sent) == true)
        ;
      else if (sent.contains("你"))
        punc = "！";
      else
        punc = "！";
    }
    else if (left1 == "额")
    {
      if (!isChinese(left2))
        punc = "……";
      else
      {}
    }
    else if (left1 == "呃")
      punc = "……";
    else if (left1 == "啦")
    {
      if (left2 == "的")
        punc = "～";
      else
        punc = "！";
    }
    else if (left1 == "嘻")
      punc = "！";
    else if (left1 == "诶")
      punc = "！";
    else if (left1 == "嘭")
      punc = "！";
    else if (left1 == "咚")
      punc = "！";
    else if (left1 == "咦")
      punc = "？";
    else if (left1 == "呜")
    {
      if (left1 ==  "嗷")
        punc = "～～";
      else
        punc = "……";
    }
    else if (left1 == "开")
    {
      if (isChinese(left2) == false)
        punc = "！";
      else
      {}
    }
    else if (left1 == "嗷")
      punc = "～～";
    else if (left1 == "呦")
      punc = "～";
    else if (left1 == "呸")
      punc = "！";
    else if (left1 == "嘿")
      punc = "！";
    else if (left1 == "嗨")
      punc = "！";
    else if (left1 == "哩" && left2 != "哔")
      punc = "！";
    else if (left1 == "靠")
      punc = "！";
    else if (left1 == "艹")
      punc = "！";
    else if (left1 == "要")
      punc = "！";
    else if (left1 == "轰")
      punc = "！";
    else if (left1 == "隆")
      punc = "！";
    else if (left1 == "砰")
      punc = "！";
    else if (left1 == "哇")
      punc = "！";
    else if (left1 == "当")
      punc = "！";
    else if (left1 == "喽")
    {
      if (left2 == "的")
        punc = "？";
      else if (tone == 0)
        punc = "。";
      else if (tone == 2)
        punc = "？";
      else
        punc = "！";
    }
    else if (left1 == "呵")
    {
      if (!isChinese(left2) || (left2=="呵"&&left3=="呵"))
        punc = "！";
      else
      {}
    }
    else
    {}
  
    return punc;
  
  }

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
    if (sent.contains("怎么知")) return false;
    if (sent.contains("知道我")) return false;

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
