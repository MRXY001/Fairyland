class MzfySyncThread {
	/// 开始云同步
	/// 有两种情况：
	/// - 首次云同步（全部重新下载、上传）
	/// - 根据上次的时间，继续云同步
	void startSync() {
	
	}
	
	/// 根据上次的时间，继续开始云同步
	void uploadAll() => uploadByTime(0);
	
	/// 根据时间戳，上传大于这个时间戳的内容
	void uploadByTime(int timestamp) {
	
	}
	
	/// 联网获取下载的内容
	/// get需要下载的列表
	void downloadAll() {
	
	}
	
	
}