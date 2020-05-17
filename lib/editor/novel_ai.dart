class NovelAIBase {
	/// 获取标点
	static String getPunc(String para, int pos) {
	
	}
	
	/// 获取句子语气
	static int getDescTone(String sent) {
	
	}
	
	/// 获取句子标点
	static String getTalkTone(String sent, String sent2, int tone, String left1, String left2, bool inQuote) {
	
	}
	
	/// 是否为中文
	static bool isChinese(String s) {
	
	}
	
	/// 是否为英文单词
	static bool isEnglish(String s) {
	
	}
	
	/// 是否为数字
	static bool isNumber(String s) {
	
	}
	
	/// 是否为空白符
	bool isBlankChar(String str) {
	
	}
	
	/// 是否为换行之外的空白符
	bool isBlankChar2(String str) {
	
	}
	
	/// 是否为空白字符串
	bool isBlankString(String str) {
	
	}
	
	/// 是否为“我知道...”格式
	static bool isKnowFormat(String sent) {
	
	}
	
	/// 是否为句末标点（不包含引号和特殊字符，不包括逗号）
	bool isSentPunc(String str) {
	
	}
	
	/// 是否为句子分割标点（包含逗号）
	bool isSentSplitPunc(String str) {
	
	}
	
	/// 是否为句子分割符（各类标点，包括逗号）
	bool isSentSplit(String str) {
	
	}
	
	/// 是否为英文标点（不包含引号和特殊字符）
	bool isASCIIPunc(String str) {
	
	}
	
	/// 是否为对称标点左边的
	bool isSymPairLeft(String str) {
	
	}
	
	/// 是否为对称标点右边的
	bool isSymPairRight(String str) {
	
	}
	
	/// 根据右边括号获取左边的括号
	String getSymPairLeftByRight(String str) {
	
	}
	
	/// 根据右边括号获取左边的括号
	String getSymPairRightByLeft(String str) {
	
	}
	
	/// 获取当前面的句子
	String getCursorFrontSent() {
	
	}
	
	/// 获取当前位置的附近汉字
	String getCurrentChar(int x) {
	
	}
	
	/// 汉字后面是否需要加标点
	bool isQuoteColon(String str) {
	
	}
	
}