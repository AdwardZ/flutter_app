import 'package:flutterappdemo/resources/const_info.dart';

class Api {
  static const String BASE_URL = ConstInfo.bastPath;
  static final String LOGIN = '/appa/vendor/login'; //登陆
  static final String LOGINOUT = '/appa/vendor/logout'; //登陆
  static final String HOME = '/appa/vendor/home'; //主界面
  static final String SUBMIT_REVIEW = '/appa/vendor/submittoreview'; //提交審核
  static final String UPLoad = '/a/file/upload';
  static final String AddFile = '/appa/vendor/addFile';
  static final String DelFile = '/appa/vendor/delFile';
  static final String HEARTBEAT = '/appa/vendor/heartbeat'; //心跳
}
