class AccountInfo {
	String userID;
	String username;
	String password;
	String nickname;
	
	int allWords;
	int allTimes;
	int allUseds;
	int allBonus;
	
	bool isLogin() => userID != null && userID.isNotEmpty;
}