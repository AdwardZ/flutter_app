import 'package:dio/dio.dart';
import 'package:flutterappdemo/utils/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'net_utils.dart';

class FileUpUtil {
  //待上传的文件
  List<String> startFilePath;

  //上传失败的文件
  List<String> errorFilePath;

  //上传成功的文件
  List<String> successFilePath;

  //上传失败重试次数
  int tautologyNum;

  //超时时间
  int timeOut;

  //上传成功的标示符
  final String suceessKey = "SHOP_CHECK_UP_PHOTO_OK";

  //本次上传的文件数组的标示符
  final String upKey = "SHOP_CHECK_UP_PHOTOING";

  FileUpUtil(this.startFilePath, this.tautologyNum, this.timeOut);

  Future<FileUpUtil> init(
      List<String> startFilePath, int up, int tautologyNum, int timeOut) async {
    FileUpUtil fileUpUtil =
        new FileUpUtil(startFilePath, tautologyNum, timeOut);
    SpUtil sp = await SpUtil.getInstance();
    //更新最新的上传文件列表
    sp.putStringList(upKey, startFilePath);
    //获取上传成功的文件
    if (sp.hasKey(suceessKey)) {
      successFilePath = sp.getStringList(suceessKey);
    } else {
      successFilePath = [];
    }
    return fileUpUtil;
  }

  //开始上传
  Future<FileUpUtil> start() async {
    //开启文件
//       for (String value in startFilePath) {
//           if(successFilePath.contains(value)){
//               continue;
//           }
//           var name = value.substring(value.lastIndexOf("/") + 1, value.length);
//           var file = await MultipartFile.fromFile(value, filename: name);
//           var result = await NetUtils.post(url: Api.Upload, params: {
//               "file": file,
//           },isBody: false);
//           Log.debug(result['url']);
//       }
    return this;
  }
}
