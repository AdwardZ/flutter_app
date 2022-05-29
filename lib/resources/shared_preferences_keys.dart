class SharedPreferencesKeys {
  /// boolean
  /// 用于欢迎页面. 只有第一次访问才会显示. 或者手动将这个值设为false
  static String showWelcome = 'loginWelcone';
  static String userKey = "asg_user_info";
  static String msgRegID = "jpush_reg_id";
  static String token = "asg_ccess_token";
  static String cacheProjectStores = 'cache_project_stores';
  static String cachePromoterProjectStores = 'cache_promoter_project_stores';
  static String cacheTasks = 'cache_tasks_';
  static String cacheWorkCenter = 'cache_work_center';
  static String cacheWorkDetail = 'cache_work_projectId_storeId';

//  static String cacheWorkEhrId = 'cache_work_ehr_id';
  static String cacheWorkEhr = 'cache_work_ehr_data';

  /**促销员使用*/
  static String cacheWorkSuperisorDetail =
      'cache_work_projectId_supervisorUserId';

  /// json
  /// 用于存放搜索页的搜索数据.
  /// [{
  ///  name: 'name'
  ///
  /// }]
  static String searchHistory = 'searchHistory';

  /**存放用户手机号*/
  static String userPhoneNum = 'userPhoneNum';

  /**存放用户密码*/
  static String userPWD = 'userPwd';
}
