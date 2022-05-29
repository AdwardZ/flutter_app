class ConstInfo {
  //TODO
  static const bool dev = true;
  static const int PAGE_SIZE = 15;
  static const int DB_VERSION = 1;
  static const int UPLOAD_WORK_PHOTO_INTERVAL = 600;
  static const String AMAP_IOS_KEY = "";

  static const String bastPath = 'http://192.168.1.11';
  static const bool isDownloadExamplePic = true;

  ///
  static const bool inProd = const bool.fromEnvironment("dart.vm.product");

  ///提交審核Levle常亮
  static const String SUBMIT_LEVEL_ROOT = "root";
  static const String SUBMIT_LEVEL_SITE = "site";
  static const String SUBMIT_LEVEL_DIRONE = "dirone";
  static const String SUBMIT_LEVEL_DIRTWO = "dirtwo";
  static const String SUBMIT_LEVEL_DIRTHREE = "dirthree";
}
