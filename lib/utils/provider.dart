import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutterappdemo/model/version_cache.dart';
import 'package:flutterappdemo/resources/const_info.dart';
import 'package:flutterappdemo/resources/shared_preferences_keys.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'logger.dart';
import 'shared_preferences.dart';

class Provider {
  static Database db;
  static String dbName = "app.db";

  Future init(bool isCreate) async {
    //Get a location using getDatabasesPath
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    Log.info("load app db:" + path);
    File dbFile = File(path);
    try {
      var isExist = await dbFile.exists();
      Log.info("app db exist:$isExist");
//      await deleteDatabase(path);
      if (!isExist) {
        _initAppDB(path);
      } else {
        _openExistDB(path);
      }
    } catch (e) {
      Log.error("Error $e");
    }
  }

  void _initAppDB(String path) async {
    ByteData data = await rootBundle.load(join("assets", "app.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes);
    //全新安装，保证数据库的最新
    db = await openDatabase(path, version: ConstInfo.DB_VERSION,
        onCreate: (Database db, int version) async {
      Log.info('db created version is $version');
    }, onOpen: (Database db) async {
      Log.info('new db opened');
    });
    getTables();
  }

  void _openExistDB(String path) async {
    db = await openDatabase(path,
        version: ConstInfo.DB_VERSION,
        onUpgrade: _upgrade, onOpen: (Database db) async {
      Log.info('existed db opened');
    });
    List<int> range = await checkVersion();
    if (range.length > 0) {
      var batch = db.batch();
      //更新数据库版本
      _updateFunc.sublist(range[0], range[1]).forEach((func) {
        Log.info("execute func:$func");
        func(batch);
      });
      _upgradeVersion(batch);
      await batch.commit();
      //reset welcome page
      await SpUtil.getInstance()
        ..putBool(SharedPreferencesKeys.showWelcome, true);
    }
  }

  // 获取数据库中所有的表
  Future<List> getTables() async {
    if (db == null) {
      return Future.value([]);
    }
    List tables = await db
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    List<String> targetList = [];
    tables.forEach((item) {
      Log.debug("current table: ${item['name']}");
      targetList.add(item['name']);
    });
    return targetList;
  }

  // 检查数据库中, 表是否完整, 在部份android中, 会出现表丢失的情况
  Future checkTableIsRight() async {
    List<String> expectTables = ['user', 'version'];
    List<String> tables = await getTables();
    for (int i = 0; i < expectTables.length; i++) {
      if (!tables.contains(expectTables[i])) {
        return false;
      }
    }
    return true;
  }

  Future<List<int>> checkVersion() async {
    Version version = await VersionCacheControlModel().getVersion();
    Log.info("current app db version:$version");
    List<int> range = [];
    if (version.version < ConstInfo.DB_VERSION) {
      range = [version.version, ConstInfo.DB_VERSION];
    }
    return range;
  }

  void _upgrade(Database db, int oldVersion, int newVersion) async {
    Log.info('db update oldVersion is $oldVersion newVersion $newVersion');
  }

  List<Function> _updateFunc = [() {}, _v1tov2, _v2tov3];

  static void _upgradeVersion(Batch batch) {
    Log.info("upgrade db version to ${ConstInfo.DB_VERSION}");
    batch.execute(
      "UPDATE version set version = ${ConstInfo.DB_VERSION};",
    );
  }

  ///创建数据库--初始版本
  static void _v1tov2(Batch batch) {
    Log.info("upgrade db to v2");
    /* batch.execute(
      "UPDATE test set name = 2;",
    );*/
  }

  ///更新数据库Version: 1->2.
  static void _v2tov3(Batch batch) {
    Log.info("upgrade db to v3");
    /*batch.execute(
      "UPDATE test set name = 3;",
    );*/
  }
}
