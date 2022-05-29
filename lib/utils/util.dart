import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' hide Key;
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutterappdemo/resources/base_style.dart';
import 'package:flutterappdemo/resources/const_info.dart';
import 'package:flutterappdemo/utils/shared_preferences.dart';
import 'package:load/load.dart';
import 'package:oktoast/oktoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

import 'adapt.dart';

class Util {
  static bool isFinish(int curPage, int pageCount) {
    return curPage + 1 > pageCount;
  }

  static bool isStringEmpty(String value) {
    return value == null || value.isEmpty;
  }

  static String stringNull(String value) {
    if (value == null) return null;
    return value.isEmpty ? null : value;
  }

  static Color parseColor(String hexColor) {
    if (hexColor == null || hexColor.isEmpty) return BStyle.themeColor;
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    hexColor = hexColor.replaceAll('0X', '');
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    var value = int.parse(hexColor, radix: 16);
    return Color(value);
  }

  static String md5Encode(String str) {
    var content = new Utf8Encoder().convert(str);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  /*
  * Base64加密
  */
  static String encodeBase64(String data) {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  /*
  * Base64解密
  */
  static String decodeBase64(String data) {
    return String.fromCharCodes(base64Decode(data));
  }

  /*
  * 通过图片路径将图片转换成Base64字符串
  */
  static Future image2Base64(String path) async {
    File file = new File(path);
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }

  static String encrypt(String value) {
    final key = Key.fromUtf8("dasdasdasdasdasd");
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    return encrypter.encrypt(value).base64;
  }

  static bool isPhone(String value) {
    return RegExp("^1\\d{10}\$").hasMatch(value);
  }

  static bool isPassword(String value) {
    return RegExp("^(?=.*[A-Za-z])(?=.*?[0-9]).{6,10}\$").hasMatch(value);
  }

  static bool isValidAmount(String value) {
//    var reg = /(^[1-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9]\.[0-9]{1,2}$)/;
    return RegExp(
            "^(([1-9][0-9]{0,14})|([0]{1})|(([0]\\.\\d{1,2}|[1-9][0-9]{0,14}\\.\\d{1,2})))\$")
        .hasMatch(value);
  }

  static String getTimeDuration(String comTime) {
    var nowTime = DateTime.now();
    var compareTime = DateTime.parse(comTime);
    if (nowTime.isAfter(compareTime)) {
      if (nowTime.year == compareTime.year) {
        if (nowTime.month == compareTime.month) {
          if (nowTime.day == compareTime.day) {
            if (nowTime.hour == compareTime.hour) {
              if (nowTime.minute == compareTime.minute) {
                return '片刻之间';
              }
              return (nowTime.minute - compareTime.minute).toString() + '分钟前';
            }
            return (nowTime.hour - compareTime.hour).toString() + '小时前';
          }
          return (nowTime.day - compareTime.day).toString() + '天前';
        }
        return (nowTime.month - compareTime.month).toString() + '月前';
      }
      return (nowTime.year - compareTime.year).toString() + '年前';
    }
    return 'time error';
  }

  static double getChineseTime(int second) {
    if (second <= 0) return 0;
    double temp = second / (60 * 60 * 24.0);
    if (temp >= 1) {
      return temp;
    }
    temp = second / (60 * 60);
    if (temp >= 1) {
      return temp;
    }
    temp = second ~/ (60) * 1.0;
    if (temp >= 1) {
      return temp;
    }
    return second / 1.0;
  }

  static String getChineseTimeUnit(int second) {
    if (second <= 0) return "";
    double temp = second / (60 * 60 * 24.0);
    if (temp >= 1) {
      return "天";
    }
    temp = second / (60 * 60);
    if (temp >= 1) {
      return "时";
    }
    temp = second / (60);
    if (temp >= 1) {
      return "分";
    }
    return "秒";
  }

  static double setPercentage(percentage, context) {
    return MediaQuery.of(context).size.width * percentage;
  }

  static void openMap(double lat, double lng) async {
    String url;
    if (Platform.isAndroid) {
      url = 'androidamap://navi?sourceApplication=app&softname'
          '&lat=${lat.toString()}&lon=${lng.toString()}&style=0';
    } else {
      url = 'iosamap://navi?sourceApplication=app&softname'
          '&lat=${lat.toString()}&lon=${lng.toString()}&style=0';
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Msg.toast('无法打开高德地图');
    }
  }

  static String getTimeDate(String comTime) {
    var compareTime = DateTime.parse(comTime);
    String weekDay = '';
    switch (compareTime.weekday) {
      case 2:
        weekDay = '周二';
        break;
      case 3:
        weekDay = '周三';
        break;
      case 4:
        weekDay = '周四';
        break;
      case 5:
        weekDay = '周五';
        break;
      case 6:
        weekDay = '周六';
        break;
      case 7:
        weekDay = '周日';
        break;
      default:
        weekDay = '周一';
    }
    return '${compareTime.month}-${compareTime.day}  $weekDay';
  }

  //必须强制
  static Future<void> downFile(
      String url, String fileName, String mes, BuildContext context1) async {
    StreamController<double> stream1 = StreamController<double>();
    showCustomLoadingWidget(
      Center(
        child: StreamBuilder<double>(
            stream: stream1.stream,
            builder: (context1, snapshot) {
              return SizedBox(
                width: 200,
                height: 300,
                child: Center(
                  child: Container(
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
                        CircularProgressIndicator(
                            value: snapshot.data,
                            backgroundColor: Colors.white,
                            //进度颜色
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.deepOrange)),
                        Container(
                          height: 10,
                        ),
                        Text(mes,
                            style: TextStyle(
                              color: BStyle.titleColor,
                              fontSize: BStyle.fSubtitle,
                            )),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
      tapDismiss: false,
    ); // custom dialog
    var localPath = (await _findLocalPath());
    final defaultPath = Directory(localPath);
    bool hasExisted = await defaultPath.exists();
    if (!hasExisted) {
      defaultPath.create();
    }
    Response response;
    try {
      Dio dio = new Dio();
      new File('$localPath' + '/' + '$fileName');
      response = await dio.download('$url', '$localPath' + '/' + '$fileName',
          onReceiveProgress: (int count, int total) {
        //进度
       // print("$count $total");
        stream1.sink.add(count.toDouble() / total.toDouble());
      });
      //print('downloadFile success---------${response.data}');
      //打开文件
      hideLoadingDialog();
      SpUtil sp = await SpUtil.getInstance();
      sp.putString(url + fileName, "ok");
      OpenFile.open('$localPath' + '/' + '$fileName');
    } on DioError catch (e) {
      //print('downloadFile error---------$e');
      hideLoadingDialog();
    }
  }

  static Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /*
* 查看应用是否打开某项权限
*/
  static Future<bool> checkPermission(PermissionGroup permissionGroup) async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([permissionGroup]);
    print(permissions);
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(permissionGroup);
    if (permission == PermissionStatus.granted) {
      return true;
    }
    return false;
  }
}

class Msg {
  static toast(String msg) {
    showToast(msg);
    // Fluttertoast.cancel().whenComplete(() {
    //   Fluttertoast.showToast(
    //       msg: msg,
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.CENTER,
    //       timeInSecForIos: 1,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // });
  }

  static snackBar(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  static confirm(BuildContext context, String msg, Function sureFunc,
      [Function cancelFunc,
      String sureTxt = 'Ok',
      String cancelTxt = 'Cancel']) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: Adapt.px(30.0)),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    msg,
                    style: TextStyle(
                      color: BStyle.titleColor,
                      fontSize: BStyle.fSubtitle,
                    ),
                  ),
                ),
                SizedBox(height: Adapt.px(30.0)),
                Divider(height: 1.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border:
                              Border(right: Divider.createBorderSide(context)),
                        ),
                        child: FlatButton(
                          child: Text(
                            '$cancelTxt',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: BStyle.fSubtitle,
                            ),
                          ),
                          textColor: BStyle.titleColor,
                          onPressed: () {
                            if (cancelFunc != null) {
                              cancelFunc();
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        child: Text(
                          '$sureTxt',
                          style: TextStyle(fontSize: BStyle.fSubtitle),
                        ),
                        textColor: BStyle.themeColor,
                        onPressed: () {
                          Navigator.of(context).pop();
                          sureFunc();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static confirmForCentent<T>(
      BuildContext context, Function sureFunc, Widget us, T t,
      [Function cancelFunc,
      String sureTxt = '确认',
      String cancelTxt = '取消',
      bool awitcanceFunce = false]) async {
    String can = await showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: Adapt.px(30.0)),
                us,
                SizedBox(height: Adapt.px(30.0)),
                Divider(height: 1.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border:
                              Border(right: Divider.createBorderSide(context)),
                        ),
                        child: FlatButton(
                          child: Text(
                            '$cancelTxt',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: BStyle.fSubtitle,
                            ),
                          ),
                          textColor: BStyle.titleColor,
                          onPressed: () {
                            if (!awitcanceFunce) {
                              if (cancelFunc != null) {
                                cancelFunc();
                              }
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).pop("1");
                              if (cancelFunc != null) {
                                cancelFunc();
                              }
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        child: Text(
                          '$sureTxt',
                          style: TextStyle(fontSize: BStyle.fSubtitle),
                        ),
                        textColor: BStyle.themeColor,
                        onPressed: () {
                          Navigator.of(context).pop(t);
                          sureFunc(t);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
    return can;
  }

  static confirmForCententPt<T>(
      BuildContext context, Function sureFunc, Widget us, T t,
      [Function cancelFunc,
      String sureTxt = '确认',
      String cancelTxt = '取消',
      bool awitcanceFunce = false]) async {
    showDialog<T>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: Adapt.px(30.0)),
                us,
                SizedBox(height: Adapt.px(30.0)),
                Divider(height: 1.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border:
                              Border(right: Divider.createBorderSide(context)),
                        ),
                        child: FlatButton(
                          child: Text(
                            '$cancelTxt',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: BStyle.fSubtitle,
                            ),
                          ),
                          textColor: BStyle.titleColor,
                          onPressed: () {
                            if (!awitcanceFunce) {
                              if (cancelFunc != null) {
                                cancelFunc();
                              }
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).pop("1");
                              if (cancelFunc != null) {
                                cancelFunc();
                              }
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        child: Text(
                          '$sureTxt',
                          style: TextStyle(fontSize: BStyle.fSubtitle),
                        ),
                        textColor: BStyle.themeColor,
                        onPressed: () {
                          Navigator.of(context).pop(t);
                          sureFunc(t);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, //点击遮罩不关闭对话框
    builder: (context) {
      return Center(
        child: Container(
          width: Adapt.px(60.0),
          height: Adapt.px(60.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.6),
              borderRadius: BorderRadius.circular(10.0)),
          child: Image.asset(
            "assets/images/ajax-loader.gif",
            fit: BoxFit.contain,
            width: Adapt.px(40.0),
            height: Adapt.px(40.0),
          ),
        ),
      );
    },
  );
}
