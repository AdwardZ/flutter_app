import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutterappdemo/main.dart';
import 'package:flutterappdemo/utils/Spkey.dart';
import 'package:flutterappdemo/utils/event_bus.dart';
import 'package:path/path.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterappdemo/Api/Api.dart';
import 'package:flutterappdemo/model/home_res_model.dart';
import 'package:flutterappdemo/model/upLoadPicModel.dart';
import 'package:flutterappdemo/resources/base_style.dart';
import 'package:flutterappdemo/resources/const_info.dart';
import 'package:flutterappdemo/utils/net_utils.dart';
import 'package:flutterappdemo/utils/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'logger.dart';
import 'offline_utils.dart';
import 'util.dart';
import 'package:crypto/crypto.dart';

class FileUtils {
  String workPhotos = "/workphotos";
  static String downloads = "/Downloads11";

  static init() async {
    initDirectory(downloads);
  }

  static Future initDirectory(String folder) async {
    String dir = await getPath();
    var directory = Directory("$dir/$folder");
    try {
      bool exists = await directory.exists();
      if (!exists) {
        await directory.create();
        Log.info("$folder directory create success :${directory.path}");
      }
    } catch (e) {
      Log.error("$folder directory create err  $e");
    }
    return directory;
  }

  static Future<String> getPath() async {
    // 20220402 adward
    String dir = (Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationSupportDirectory())
        .path;
    return dir;
  }

  static Future<String> getDownloadDir() async {
    String dir = await getPath();
    var directory = Directory("$dir$downloads");
    return directory.path;
  }

  static Future<void> downFileforOther(
      Set<String> urls, BuildContext context1) async {
    //print("########### Start down pic");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      Msg.toast("No Network");
      return;
    }

    if (urls == null || urls.isEmpty) {
      Msg.toast("No Image Need Down");
      return;
    }
    //print("# pic size=" + '${urls.length}');
    // 下载的下标
    int index = 0;
    StreamController<double> stream1 = StreamController<double>();
    stream1.sink.add(0);

    // 进度窗口
    showDialog<void>(
      context: context1,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
            child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StreamBuilder<double>(
                  stream: stream1.stream,
                  builder: (context1, snapshot) {
                    return Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.vertical(
                              top: Radius.elliptical(10, 10),
                              bottom: Radius.elliptical(10, 10)),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                  value: snapshot.data,
                                  backgroundColor: Colors.white,
                                  //进度颜色
                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepOrange)),
                            ),
                            Container(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                  "down ${index >= urls.length ? urls.length : index}/${urls.length} , ",
                                  style: TextStyle(
                                    color: BStyle.titleColor,
                                    fontSize: BStyle.fSubtitle,
                                  )),
                            ),
                            // 按钮文字
                            // RaisedButton
                            ElevatedButton(
                              // child: snapshot.data != null
                              //     ? (snapshot.data < 1.0) ? Text('down $index  ，total ${urls.length} picture')
                              //         : (snapshot.data == -1) ? Text('down error: $index ')
                              //             : (snapshot.data == 1 && index == urls.length + 1)
                              //                 ? Text('All down success ') : Text('Down success: $index ') : "loading",
                              child: snapshot.data != null
                                  ? (snapshot.data < 1.0
                                  ? (snapshot.data == -1 ? Text('Error downloading $index!') : Text('downloading $index, total ${urls.length} pictures'))
                                  : ((snapshot.data >= 1.0 && index == urls.length + 1) ? Text('All download success!') : Text('Success download $index!')))
                                  : Text("Loading..."),
                              // color: Colors.blue,
                              // textColor: snapshot.data == 1 ? Colors.white : Colors.grey,
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  textStyle: TextStyle(color: snapshot.data == 1 ? Colors.white : Colors.grey)),
                              onPressed: () async {
                                if (index >= urls.length + 1 && (snapshot.data == 1 || snapshot.data == -1)) {
                                  Navigator.of(context).pop();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ]);
                  }),
            ],
          ),
        ));
      },
    );

    // 准备路径
    var localPath = (await getPath());
    final defaultPath = Directory(localPath);
    bool hasExisted = await defaultPath.exists();
    if (!hasExisted) {
      defaultPath.create();
    }

    //
    Response response;
    // 订阅\回调
    //print("@ bus.on..." + '$index');
    bus.on(Spkey.OKDownFile, (arg) async {
      index++;
      if (index >= urls.length + 1) {
        stream1.sink.add(1);
        // 没有off会造成成倍调用，比如第1次调N次，第2次调2*N次
        //print("@ bus.off: " + '$index');
        bus.off(Spkey.OKDownFile);
        return;
      }
      //print("Call func..." + '$index');
      String element = urls.elementAt(index - 1);
      //print('$index' + "/" + '${urls.length}' + ": " + element);
      if (!sp.hasKey(element)) {
        //print("begin download from server...");
        try {
          // 下载类
          Dio dio = new Dio();
          //print("#File     =" + ConstInfo.bastPath + '$element');
          //print("#localPath=" + '$localPath' + '$element');
          response = await dio.download(
              ConstInfo.bastPath + '$element', '$localPath' + '$element',
              onReceiveProgress: (int count, int total) {
                  // 跳转到进度条，修改snapshot.data数据
                  //print("count/total=" + '$count' + "/" + '$total');
                  stream1.sink.add(count.toDouble() / total.toDouble());
                  if (count == total) {
                    //print("end download from tpm");
                    //print("@ bus.emit[1]" + Spkey.OKDownFile);
                    // 下载成功 -> 一张图片下载完成
                    sp.putString(element, "ok");
                    bus.emit(Spkey.OKDownFile); // 调用注册函数(arg) async
                  }
          });
        } on DioError catch (e) {
          //print('download error: $e');
          //print("@ bus.emit[2]" + Spkey.OKDownFile);
          // 下载失败 ->
          stream1.sink.add(-1);
          bus.emit(Spkey.OKDownFile);// 调用注册函数(arg) async
        }
      } else {
        //print("load from locle");
        //print("@ bus.emit[3]" + Spkey.OKDownFile);
        // 本地存在，无需下载
        bus.emit(Spkey.OKDownFile); // 调用注册函数(arg) async
      }
    });
    //print("@ bus.emit[4]" + Spkey.OKDownFile);
    bus.emit(Spkey.OKDownFile);// 调用注册函数(arg) async
    //print("########### End down pic");
  }


  static Future<void> uploadList(List<OffineImage> uploadImage,
      HomeResModel homeResModel, BuildContext context1) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      Msg.toast("No Network");
      return;
    }
    if (uploadImage == null || uploadImage.isEmpty) {
      Msg.toast("No Image Need Upload!-1");
      return;
    }
    //print("# upload pic size=" + '${uploadImage.length}');
    //下载的下标
    int index = 0;
    StreamController<double> stream1 = StreamController<double>();
    //print("> stream.sink.add(0)");
    stream1.sink.add(0);

    //取出所有的三级列表数组
    var needUploadImage = [];
    List<DirThree> threes = [];
    homeResModel.appSites.forEach((dirSite) {
      dirSite.dirOnes.forEach((dirOne) {
        dirOne.dirTwos.forEach((dirTwo) {
          dirTwo.dirThrees.forEach((three) {
            three.siteId = dirSite.siteId;
            three.dirOneId = dirOne.bizKey;
            three.dirTwoId = dirTwo.bizKey;
          });
          threes.addAll(dirTwo.dirThrees);
        });
      });
    });

    // 找到能与三级目录匹配的上传图片
    uploadImage.forEach((element) async {
      var list = threes
          .where((threeModel) =>
              element.siteId == threeModel.siteId &&
              element.dirOneId == threeModel.dirOneId &&
              element.dirTwoId == threeModel.dirTwoId &&
              element.dirThreeId == threeModel.bizKey)
          .toList();
      // 找到需要上传的图片状态。既然是离线的，应该都符合
      // 1-	To be uploaded  待上传
      // 2-	To be approved  待审核
      // 3-	Accepted        审核通过
      // 4-	Rejected        审核不通过
      if (list != null && list.isNotEmpty) {
        if (list.first.approveStatus == 1 ||
            list.first.approveStatus == 2 ||
            list.first.approveStatus == 5) {
          needUploadImage.add(element);
        }
        //stream1.sink.add(1);
      }
    });
    if (needUploadImage.isEmpty) {
      Msg.toast("No Image Need Upload!-2");
      return;
    }

    // 进度窗口
    showDialog<void>(
      context: context1,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  StreamBuilder<double>(
                      stream: stream1.stream,
                      builder: (context1, snapshot) {
                        return Column(mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.vertical(
                                  top: Radius.elliptical(10, 10),
                                  bottom: Radius.elliptical(10, 10)),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(
                                      value: snapshot.data,
                                      backgroundColor: Colors.white,
                                      // 进度颜色
                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepOrange)),
                                ),
                                Container(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                      "upload ${index >= needUploadImage.length ? needUploadImage.length : index}/${needUploadImage.length}",
                                      style: TextStyle(
                                        color: BStyle.titleColor,
                                        fontSize: BStyle.fSubtitle,
                                      )),
                                ),
                                // 按钮文字
                                // RaisedButton
                                ElevatedButton(
                                  child: snapshot.data != null
                                      ? (snapshot.data < 1.0
                                      ? (snapshot.data == -1 ? Text('Error upload ${index-1}!') : Text('uploading $index, total ${needUploadImage.length} pictures'))
                                      : ((snapshot.data >= 1.0 && index == needUploadImage.length + 1) ? Text('All upload success!') : Text('Success upload $index!')))
                                          : Text("Loading..."),
                                  // color: Colors.blue,
                                  // textColor: snapshot.data == 1 ? Colors.white : Colors.grey,
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blue,
                                      textStyle: TextStyle(color: snapshot.data == 1 ? Colors.white : Colors.grey)),
                                  onPressed: () async {
                                    if (index >= needUploadImage.length + 1 && (snapshot.data == 1 || snapshot.data == -1)) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ]);
                      }),
                ],
              ),
            ));
      },
    );

    //print("@ bus.on index=" + '$index');
    // 订阅\回调
    bus.on(Spkey.OKUploadFile, (arg) async {
      //print("@@@@@@@@@ Call func index=" + '$index');
      index++;
      if (index >= needUploadImage.length + 1) {
        //print("> stream.sink.add(1)");
        //stream1.sink.add(1);
        // 没有off会造成成倍调用，比如第1次调N次，第2次调2*N次
        //print("@ bus.off index=" + '$index');
        bus.off(Spkey.OKUploadFile);
        return;
      }
      //print("@index=" + '$index');
      OffineImage offineImage = needUploadImage[index - 1];
      //上传图片
      String bizKey = '${offineImage.dirThreeId}';
      String fileName = '${basename(offineImage.path)}';
      String filePath = '${offineImage.path}';
      //print("bizKey  =" + '$bizKey');
      //print("fileName=" + '$fileName');
      //print("filePath=" + '$filePath');
      var files = await MultipartFile.fromFile(filePath);
      File file = File(filePath);
      //获取md5
      var fileMd5 = await md5.bind(file.openRead()).first;
      FormData formData = FormData.fromMap({
        'bizKey': bizKey,
        'bizType': "acp_image",
        'fileName': fileName,
        'fileMd5': fileMd5,
        "file": files,
      });
      try {
        // Dio dio = new Dio();
        if(NetUtils.dio == null){
          //print('NetUtils.dio is null ----> to rebuild');
          String loginName = sp.getString("loginName");
          String pass = sp.getString("pass");
          var res = await NetUtils.post(
              url: Api.LOGIN,
              params: {
                'loginName': loginName,
                'password': pass
              },
              throwError: true)
              .catchError((e) {
            //print('login error: $e');
          });
          //print('login res: $res');
        }
        //print("NetUtils.dio is null? " + '${NetUtils.dio == null}');
        //print("begin to upload.post(1/2): fileName=" + '$fileName');
        Response response = await NetUtils.dio.post(Api.UPLoad, data: formData,
            onReceiveProgress: (int count, int total) {
              // 跳转到进度条，修改snapshot.data数据
              //print("count/total=" + '$count' + "/" + '$total');
              //print("> stream.sink.add: " +'$count' + "/" + '$total');
              stream1.sink.add(count.toDouble() / (total.toDouble()+100));
              // if (count == total) {
              //   print("@ bus.emit[addFile.success]");
              //   //bus.emit(Spkey.OKUploadFile); // 调用注册函数(arg) async
              // }
            });
        print("response is null? " + '${response == null}');
        print("response.data: " + '${response.data}');
        UpLoadPicModel resUpload = UpLoadPicModel.fromJson(response.data);
        print("resUpload.result=" + '${resUpload.result}');
        if (resUpload.result == 'true') {// end of upload.post(1/2)
          print("begin to upload.add(2/2): fileId=" + '${resUpload.fileUpload.id}');
          var resAdd = await NetUtils.post(url: Api.AddFile, params: {
            'bizKey': bizKey,
            'acp_image': resUpload.fileUpload.id,
          });
          print("resAdd: $resAdd");
          if (resAdd) {// end of upload.add(2/2)
            homeResModel.appSites
                .firstWhere((appSite) => offineImage.siteId == appSite.siteId)
                .dirOnes
                .firstWhere((dirOne) => dirOne.bizKey == offineImage.dirOneId)
                .dirTwos
                .firstWhere((dirTwo) => dirTwo.bizKey == offineImage.dirTwoId)
                .dirThrees
                .firstWhere((dirThree) => dirThree.bizKey == offineImage.dirThreeId)
                .uploadedPicUrls
                .removeWhere(
                    (uploadPic) => uploadPic.filePath == offineImage.path);
            homeResModel.appSites
                .firstWhere((appSite) => offineImage.siteId == appSite.siteId)
                .dirOnes
                .firstWhere((dirOne) => dirOne.bizKey == offineImage.dirOneId)
                .dirTwos
                .firstWhere((dirTwo) => dirTwo.bizKey == offineImage.dirTwoId)
                .dirThrees
                .firstWhere((dirThree) => dirThree.bizKey == offineImage.dirThreeId)
                .uploadedPicUrls
                .add(UploadedPicUrls(
              fileName: '',
              fileUrl: offineImage.path,
              filePath: offineImage.path,
              id: resUpload.fileUpload.id,
            ));
            // 上传成功 -> 清除本地离线数据
            print("OffineUtils.getAll: " + '${OffineUtils.getAll()}');
            print("OffineUtils.remove: " + '${offineImage.path}');
            OffineUtils.remove(offineImage.path);
            print("@ bus.emit[addFile.success]");
            print("> stream.sink.add(1)");
            stream1.sink.add(1);
            bus.emit(Spkey.OKUploadFile);
          } else {
            // 上传失败 -> 保存至离线保存
            //stream1.sink.add(-1);
            print("@ bus.emit[addFile.fail]");
            //bus.emit(Spkey.OKUploadFile);
            throw new DioError(error: "@@addFile.fail");
          }
        } else {
          print("@ bus.emit[upload.fail]");
          // 上传失败 -> 保存至离线保存
          //stream1.sink.add(-1);
          //bus.emit(Spkey.OKUploadFile);
          throw new DioError(error: "@@upload.fail");
        }
      } on DioError catch (e) {
        // 上传失败 -> 无网络
        print('DioError: $e');
        print("@ bus.emit[DioError]");
        print("> stream.sink.add(-1)");
        stream1.sink.add(-1);
        bus.emit(Spkey.OKUploadFile);// 调用注册函数(arg) async
      } catch (error, stacktrace) {
        // 上传失败 ->
        print('Error: $error');
        print("> stream.sink.add(-1)");
        stream1.sink.add(-1);
        bus.emit(Spkey.OKUploadFile);// 调用注册函数(arg) async
      }
    });
    print("@ bus.emit[end]");
    bus.emit(Spkey.OKUploadFile);
  }

  static Future<String> picPath(String url) async {
    var localPath = (await getPath());
    if (sp.hasKey('${url}')) {
      return localPath + url;
    } else {
      return ConstInfo.bastPath + '${url}';
    }
  }

  /// 离线上传不使用这里
  /// 上传图片页面会调用
  static Future<UpLoadPicModel> upload(
      String bizKey, String fileName, String filePath) async {
    var files = await MultipartFile.fromFile(filePath);
    File file = File(filePath);
    //获取md5
    var fileMd5 = await md5.bind(file.openRead()).first;
    FormData formData = FormData.fromMap({
      'bizKey': bizKey,
      'bizType': "acp_image",
      'fileName': fileName,
      'fileMd5': fileMd5,
      "file": files,
    });
    print('NetUtils.dio.post.->');
    Response res = new Response();
    if(NetUtils.dio == null){
      //{"code":100,"msg":"成功","result":{"userType":"1"}}
      print('NetUtils.dio is null');
    } else {
      try {
        res = await NetUtils.dio.post(Api.UPLoad, data: formData);
        //var res = await NetUtils.dio.post(Api.UPLoad, data: formData);
        print('NetUtils.dio.post.->end');
        Log.info("call res:${res.data}");
      } on DioError catch (e) {
        print('#upload error: $e');
        res = new Response();
      }
    }
    return UpLoadPicModel.fromJson(res.data);
  }

  static Future<bool> addFile(String bizKey, String imageId) async {
    var res = await NetUtils.post(url: Api.AddFile, params: {
      'bizKey': bizKey,
      'acp_image': imageId,
    });
    Log.info("call res:${res}");
    return res;
  }

  static Future<bool> delFile(String bizKey, String imageId) async {
    var res = await NetUtils.post(url: Api.DelFile, params: {
      'bizKey': bizKey,
      'acp_image__del': imageId,
    });
    return res;
  }
}
