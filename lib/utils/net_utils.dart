import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutterappdemo/Api/Api.dart';
import 'package:flutterappdemo/utils/StringUtile.dart';
import 'package:flutterappdemo/utils/event_bus.dart';
import 'package:flutterappdemo/utils/util.dart';
import 'package:load/load.dart';
import 'package:path_provider/path_provider.dart';

import 'Spkey.dart';
import 'logger.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
Map<String, dynamic> optHeader = {
  'accept-language': 'zh-cn',
  'Content-Type': 'application/x-www-form-urlencoded'
};
enum Method { GET, PUT, POST, DELETE }

Set<String> excludeAuth = {Api.LOGIN};
int loadingNum = 0;

bool checkResult(Response response) {
  bool r = true;
  var data = response.data;
  // APP定义接口 与 文件上传接口 返回response格式不一致
  // response:{"code":100,"msg":"成功！","result":{"
  // response:{"result":"true","code":"server","fileUpload":{"
  var fileUpload = data["fileUpload"];
  if(fileUpload == null) {
    int code = data["code"];
    if (code != 100) {
      r = false;
    }
  } else {
    var result = data["result"];
    if (result != "true") {
      r = false;
    }
  }
  return r;
}

class Interceptors implements InterceptorsWrapper {
  @override
  Future onError(DioError err) async {
//    // 超时
//    if (err.type == DioErrorType.CONNECT_TIMEOUT) {
//      Msg.toast('网络请求超时');
//      return err;
//    }
//
//    Log.debug("call error:" + err.toString());
//    if (ConstInfo.inProd) {
//      Msg.toast('\n' +err.toString());
//    } else {
//      Msg.toast('\n' + err.toString());
//    }

    Msg.toast('No Network Signal Detected!');
    Log.debug("call error:" + err.toString());
    bus.emit(Spkey.NetError);
    return err;
  }

  @override
  Future onRequest(RequestOptions options) async {
    //特殊处理更新接口的headers
    Log.info("call url:" + options.uri.toString());
    Log.info("call params:" + options.data.toString());
    Log.info("call header:${options.headers}");
    return options;
  }

  @override
  Future onResponse(Response response) async {
    Log.debug("call response:" + json.encode(response.data));
    if (!checkResult(response)) {
      bus.emit(Spkey.NetError);
      var extra = response.request.extra;
      if (extra['showToast'] == null || extra['showToast'] == true) {
        if (!StringUtile.isEmpty(response.data["msg"])) {
          Msg.toast(response.data["msg"].toString());
        }
      }
      if (response.data["code"] == 150) {
        // 20220328: adward 改成弹出提示框，不要退回到登录页面. 弹出提示框上面已实现，MSG从后台返回。
        // Msg.toast('Login has failed. Please login again!');
        //navigatorKey.currentState.pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
      }
//   if(response.data["code"] == "000200000016"||response.data["code"] == "000200030084"||response.data["code"] == "000300000059") {
//      return response;
//    }
      return null;
    }
    return response;
  }
}

class NetUtils {
  /// global dio object
  static Dio dio;

  static Future<Directory> _createCookie() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;
    var dir = new Directory("$documentsPath/cookies");
    await dir.create();
    return dir;
  }

  /// 创建 dio 实例对象
  static Future<Dio> _createInstance({bool isBody: true}) async {
    if (dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      dio = new Dio(BaseOptions(
        headers: optHeader,
        baseUrl: Api.BASE_URL,
        connectTimeout: 20000,
        receiveTimeout: 1000 * 30,
        contentType: Headers.formUrlEncodedContentType,
/*//          contentType: "application/json",
//          responseType: ResponseType.plain*/
      ));
      var dir = await _createCookie();
      dio.interceptors.add(CookieManager(PersistCookieJar(dir: dir.path)));
      dio.interceptors.add(Interceptors());
      dio.interceptors
          .add(DioCacheManager(CacheConfig(baseUrl: Api.BASE_URL)).interceptor);
    }
    return dio;
  }

  static buildCache() {
    return buildCacheOptions(Duration(days: 7), maxStale: Duration(days: 10));
  }

  static Future request<T>(
      {String url,
      Method method = Method.GET,
      Map<String, dynamic> params,
      Map<String, dynamic> healder,
      bool isBody = true,
      bool isMask = true,
      bool isCache = false,
      bool showToast = true,
      bool throwError = false}) async {
    try {
      var response;
//      if (isMask && loadingNum == 0) {
//        showLoadingDialog();
//        loadingNum = loadingNum + 1;
//      }
      Dio dio = await _createInstance();
      Options options = isCache ? buildCache() : Options();
      options.extra = {'showToast': showToast};
      switch (method) {
        case Method.GET:
          if (params != null) {
            response =
                await dio.get(url, queryParameters: params, options: options);
          } else {
            response = await dio.get(url, options: options);
          }
          break;
        case Method.POST:
          response = await dio.post(url,
              data: isBody ? params : FormData.fromMap(params),
              options: options);
          break;
        case Method.PUT:
          response = await dio.put(url,
              data: isBody ? params : FormData.fromMap(params),
              options: options);
          break;
        case Method.DELETE:
          response = await dio.delete(url,
              data: isBody ? params : FormData.fromMap(params),
              options: options);
          break;
        default:
          break;
      }
      if (isMask && loadingNum == 1) {
        loadingNum = loadingNum - 1;
        Future.delayed(Duration(milliseconds: 30), () {
          hideLoadingDialog();
        });
      }
      if (!checkResult(response)) {
        Msg.toast(response.data["msg"].toString());
        return throwError ? Future.error(response) : null;
      }
      return response.data["result"] ?? true;
    } on DioError catch (error) {
      if (isMask && loadingNum == 1) {
        loadingNum = loadingNum - 1;
        Future.delayed(Duration(milliseconds: 30), () {
          hideLoadingDialog();
        });
      }
      return Future.error(error);
    }
  }

  static Future get<T>(
      {String url,
      Map<String, dynamic> params,
      bool isMask = true,
      bool throwError = true,
      bool isCache = false}) async {
    return request(
        url: url,
        params: params,
        isMask: isMask,
        throwError: throwError,
        isCache: isCache);
  }

  static Future post(
      {String url,
        Map<String, dynamic> params,
        bool isBody = true,
        bool isMask = true,
        bool throwError = true,
        bool isCache = false}) async {
    // // 设置代理 便于本地 charles 抓包
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.findProxy = (uri) {
    //     return "PROXY 30.10.24.79:8889";
    //   };
    // };
    return request(
        url: url,
        method: Method.POST,
        params: params,
        isBody: isBody,
        isMask: isMask,
        throwError: throwError,
        isCache: isCache);
  }

  static Future put({
    String url,
    Map<String, dynamic> params,
    bool isBody = true,
    bool isMask = true,
    Map<String, dynamic> headler,
    bool isCache = false,
    bool throwError = true,
  }) async {
    // // 设置代理 便于本地 charles 抓包
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.findProxy = (uri) {
    //     return "PROXY 30.10.24.79:8889";
    //   };
    // };
    return request(
      url: url,
      method: Method.PUT,
      params: params,
      isBody: isBody,
      isMask: isMask,
      healder: headler,
      isCache: isCache,
      throwError: throwError,
    );
  }

  static Future delete(
      {String url,
      Map<String, dynamic> params,
      bool isBody = true,
      bool isMask = true}) async {
    return request(
        url: url,
        method: Method.DELETE,
        params: params,
        isBody: isBody,
        isMask: isMask);
  }
}
