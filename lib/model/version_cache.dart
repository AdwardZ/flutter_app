import 'dart:async';

import 'package:flutterappdemo/utils/sql.dart';

class Version {
  int version;

  Version({this.version});

  factory Version.fromJson(Map<String, dynamic> json) =>
      Version(version: json['version'] as int);

  @override
  String toString() {
    return 'Version{version: $version}';
  }
}

class VersionCacheControlModel {
  final String table = 'version';
  Sql sql;

  VersionCacheControlModel() {
    sql = Sql.setTable(table);
  }

  // 获取用户信息
  Future<Version> getVersion() async {
    List list = await sql.get();
    if (list.length == 1) {
      return Version.fromJson(list[0]);
    }
    return null;
  }
}
