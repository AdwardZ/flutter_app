import 'dart:convert';

import 'package:flutterappdemo/utils/shared_preferences.dart';

class OffineImage {
  String siteId;
  String dirOneId;
  String dirTwoId;
  String dirThreeId;
  String path;
  String imageId;

  OffineImage(
      {this.siteId, this.dirOneId, this.dirTwoId, this.dirThreeId, this.path, this.imageId});

  factory OffineImage.fromJson(Map<String, dynamic> json) => OffineImage(
        siteId: json['siteId'] as String,
        dirOneId: json['dirOneId'] as String,
        dirTwoId: json['dirTwoId'] as String,
        dirThreeId: json['dirThreeId'] as String,
        path: json['path'] as String,
        imageId: json['imageId'] as String,
      );

  Map<String, dynamic> toJson() {
    return {
      'siteId': this.siteId,
      'dirOneId': this.dirOneId,
      'dirTwoId': this.dirTwoId,
      'dirThreeId': this.dirThreeId,
      'path': this.path,
      'imageId': this.imageId
    };
  }
}

class OffineUtils {
  static const String _key = "offine_data";
  static List<OffineImage> offineImages;
  static SpUtil _sp;

  static Future init() async {
    if (offineImages == null) {
      _sp = await SpUtil.getInstance();
      String value = _sp.getString(_key);
      if (value != null && value.isNotEmpty) {
        var array = jsonDecode(value);
        offineImages = array.map<OffineImage>((json) {
          return OffineImage.fromJson(json);
        }).toList();
      } else {
        offineImages = [];
      }
    }
  }

  /// 保存离线数据
  static Future _save() async {
    await init();
    var items =
        offineImages.map<Map<String, dynamic>>((x) => x.toJson()).toList();
    var value = jsonEncode(items);
    await _sp.putString(_key, value);
  }

  /// 删除离线数据
  /// @path 图片本地图径
  static Future remove(String path) async {
    await init();
    var item = offineImages.firstWhere((x) => x.path == path);
    if (item != null) {
      offineImages.remove(item);
      await _save();
    }
  }

  /// 添加离线数据
  ///
  static Future add(String siteId, String dirOneId, String dirTwoId, String dirThreeId, String path,
      String imageId) async {
    await init();
    offineImages.add(OffineImage(
        siteId: siteId, dirOneId: dirOneId, dirTwoId: dirTwoId, dirThreeId: dirThreeId, path: path));
    await _save();
  }

  // 判断是否存在离线数据
  static Future<bool> hasOffline(
      {String siteId = '', String dirOneId = '', String dirTwoId = '', String dirThreeId = ''}) async {
    await init();
    return offineImages.any((x) =>
        x.siteId == siteId || x.dirOneId == dirOneId || x.dirTwoId == dirTwoId || x.dirThreeId == dirThreeId);
  }

  // 根据三级目录 -> 获取离线图片
  static Future<List<OffineImage>> get(String dirThreeId) async {
    await init();
    return offineImages.where((x) => x.dirThreeId == dirThreeId).toList();
  }

  static Future<List<OffineImage>> getAll() async {
    await init();
    return offineImages;
  }

  // 根据一级二级三级目录 -> 获取离线图片
  static Future<List<OffineImage>> get43(
      {String siteId = '', String dirOneId = '', String dirTwoId = '', String dirThreeId = ''}) async {
    await init();
    return offineImages
        .where((x) =>
            x.siteId == siteId || x.dirOneId == dirOneId || x.dirTwoId == dirTwoId || x.dirThreeId == dirThreeId)
        .toList();
  }
}
