import 'dart:convert';
import 'dart:io';

import 'package:flutterappdemo/model/user.dart';
import 'package:flutterappdemo/resources/shared_preferences_keys.dart';
import 'package:flutterappdemo/utils/shared_preferences.dart';
import 'package:flutterappdemo/utils/util.dart';
import 'package:permission_handler/permission_handler.dart';

class DataUtils {
  static SpUtil _sp;

  static void init(SpUtil sp) {
    _sp = sp;
  }

  static User getUser() {
    String json = _sp.getString(SharedPreferencesKeys.userKey);
    return json != null ? User.fromJson(jsonDecode(json)) : null;
  }

  static void clearUser() {
    _sp.remove(SharedPreferencesKeys.userKey);
  }

  static void setUser(User user) {
    _sp.putString(SharedPreferencesKeys.userKey, jsonEncode(user));
  }

  static void setSearchHistory(String type, List history) {
    _sp.putString(
        SharedPreferencesKeys.searchHistory + type, jsonEncode(history));
  }

  static List getSearchHistory(String type) {
    String json = _sp.getString(SharedPreferencesKeys.searchHistory + type);
    return json != null ? jsonDecode(json) : null;
  }

  static void clearSearchHistory() {
    _sp.remove(SharedPreferencesKeys.searchHistory);
  }

  static void setUserPhone(String phoneNum) {
    _sp.putString(SharedPreferencesKeys.userPhoneNum, phoneNum);
  }

  static String getUserPhone() {
    String phoneNum = _sp.getString(SharedPreferencesKeys.userPhoneNum);
    return phoneNum != null ? phoneNum : '';
  }

  static void setUserPwd(String pwd) {
    _sp.putString(SharedPreferencesKeys.userPWD, pwd);
  }

  static String getUserPwd() {
    String pwdNum = _sp.getString(SharedPreferencesKeys.userPWD);
    return pwdNum != null ? pwdNum : '';
  }

  static void setUserName(String userName) {
    _sp.putString("userName", userName);
  }

  static String getUserName() {
    String userName = _sp.getString("userName");
    return userName != null ? userName : '';
  }

  static Future<bool> requestLocationPermission() async {
    final permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);

    if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
      return true;
    } else {
      Msg.toast("无法获取系统权限,定位失败");
      return false;
    }
  }

  static SpUtil getSPInstance() {
    return _sp;
  }

  // 申请权限
  static Future<bool> checkPermission(PermissionGroup permissionGroup) async {
    //IOS 下无须申请storage权限
    if (Platform.isIOS && permissionGroup == PermissionGroup.storage) {
      return true;
    }
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(permissionGroup);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler().requestPermissions([permissionGroup]);
      if (permissions[permissionGroup] == PermissionStatus.granted) {
        return true;
      } else {
        Msg.toast("无法获取系统权限,操作失败");
        return false;
      }
    }
    return true;
  }

//  static Future<DeviceInfo> getDeviceModel() async {
//    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//    if (Platform.isAndroid) {
//      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//      return DeviceInfo(
//          "Android-${androidInfo.version.release}-${androidInfo.version.sdkInt}:${androidInfo.model}",
//          androidInfo.isPhysicalDevice ? androidInfo.androidId : 'simulator',
//          androidInfo.version.toString(),
//          androidInfo.brand);
//    }
//    if (Platform.isIOS) {
//      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//      return DeviceInfo(
//          "IOS-${iosInfo.systemVersion}:${iosInfo.model}",
//          iosInfo.isPhysicalDevice ? iosInfo.identifierForVendor : 'simulator',
//          iosInfo.systemVersion,
//          "ios");
//    }
//    return null;
//  }
}

class DeviceInfo {
  String model;
  String deviceId;
  String version;
  String mobileBrand;

  DeviceInfo(this.model, this.deviceId, this.version, this.mobileBrand);

  @override
  String toString() {
    return 'DeviceInfo{model: $model, deviceId: $deviceId, version: $version}';
  }
}
