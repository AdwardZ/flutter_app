import 'dart:math';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutterappdemo/model/home_res_model.dart';
import 'package:flutterappdemo/utils/offline_utils.dart';

class DirSiteState implements Cloneable<DirSiteState> {
  ///所有数据
  List<AppSite> appSites = [];

  ///展示的数据
  List<AppSite> showSites = [];

  ///列表加载刷新控制器
  EasyRefreshController easyRefreshController = EasyRefreshController();

  /// 当前页
  int currentPage = 0;

  /// 总页数
  int totalPageCount = 0;

  ///是否是搜索状态
  bool isSearch = false;

  ///每页个数
  static const int pageCount = 10;

  @override
  DirSiteState clone() {
    return DirSiteState()
      ..showSites = showSites
      ..isSearch = isSearch
      ..appSites = appSites
      ..totalPageCount = totalPageCount
      ..easyRefreshController = easyRefreshController
      ..currentPage = currentPage;
  }
}

DirSiteState initState(Map<String, dynamic> args) {
  if (args == null) {
    return DirSiteState();
  }
  return DirSiteState()..appSites = args["appSites"] ?? [];
}
