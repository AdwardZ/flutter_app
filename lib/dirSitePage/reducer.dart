import 'package:fish_redux/fish_redux.dart';
import 'package:flutterappdemo/model/home_res_model.dart';
import 'package:flutterappdemo/utils/offline_utils.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'action.dart';
import 'state.dart';

Reducer<DirSiteState> buildReducer() {
  return asReducer(
    <Object, Reducer<DirSiteState>>{
      DirSiteAction.action: _onAction,
      DirSiteAction.requestMore: _requestMore,
      DirSiteAction.searchSite: _searchSite,
      DirSiteAction.requestAll: _requestAll,
    },
  );
}

///搜索站点
DirSiteState _searchSite(DirSiteState state, Action action) {
  final DirSiteState newState = state.clone();
  newState.currentPage = 0;
  //拿到输入的字符串
  String inputText = action.payload;

  //改变搜索状态
  newState.isSearch = inputText.isNotEmpty;

  //找到包含字符的站点信息
  List<AppSite> resultSites = getShowList(inputText, newState.appSites);

  newState.showSites.clear();
  newState.showSites.addAll(resultSites);

  return newState;
}

//获取刷新时需要展示的列表
List<AppSite> getShowList(String inputText, List<AppSite> allSites) {
  List<AppSite> resultSites = [];
  if (inputText.isEmpty) {
    //无字符时取前10个
    if (allSites.length < DirSiteState.pageCount) {
      resultSites = allSites.sublist(0, allSites.length);
    } else {
      resultSites = allSites.sublist(0, DirSiteState.pageCount);
    }
  } else {
    //找出含有输入文本的站点
    allSites.forEach((element) {
      if (element.siteId.contains(inputText.toUpperCase().trim()) ||
          element.siteId.contains(inputText.toLowerCase().trim())) {
        resultSites.add(element);
      }
    });
  }
  return resultSites;
}

///处理请求更多逻辑
DirSiteState _requestAll(DirSiteState state, Action action) {
  final DirSiteState newState = state.clone();

  ///所有个数
  List<AppSite> appSites = [];

  ///显示个数
  List<AppSite> showSites = [];

  ///计算出总页数
  int totalPageCount = 0;

  ///取传过来的数据
  List<AppSite> arg = action.payload;
  if (arg != null && arg.isNotEmpty) {
    appSites = arg;
    /// 20220324 adward 去掉分页
    totalPageCount = 1;
    // totalPageCount = (appSites.length / oneState.pageCount).ceil();

    appSites.forEach((dirSite) async {
      //寻找是否有离线图片, 1-No photos,2-Upload completed,3-Offline photos
      if (dirSite.uploadStatus != 2 && dirSite.uploadStatus != 3) {
        var bool = await OffineUtils.hasOffline(siteId: dirSite.siteId);
        if (bool) {
          dirSite.uploadStatus = 3;
        }
        var list = await OffineUtils.get43(siteId: dirSite.siteId);
        dirSite.needUploadNumber = list.length;
      } else {
        dirSite.needUploadNumber = 0;
      }
    });

    /// 20220324 adward 去掉分页
    showSites = appSites.sublist(0, appSites.length);
    ///截取做分页
    // if (appSites.length < oneState.pageCount) {
    //   showSites = appSites.sublist(0, appSites.length);
    // } else {
    //   showSites = appSites.sublist(0, oneState.pageCount);
    // }
  }
  newState.currentPage = 0;
  newState.appSites = appSites;
  newState.totalPageCount = totalPageCount;
  newState.showSites = showSites;
  return newState;
}

///处理请求更多逻辑
DirSiteState _requestMore(DirSiteState state, Action action) {
  final DirSiteState newState = state.clone();
  if (newState.currentPage < newState.totalPageCount - 1) {
    newState.currentPage = newState.currentPage + 1;
    //如果是最后一页
    if (newState.currentPage == newState.totalPageCount - 1) {
      newState.showSites.addAll(newState.appSites
          .sublist(newState.showSites.length, newState.appSites.length));
    } else {
      //不是最后一页 取N个
      newState.showSites.addAll(newState.appSites.sublist(
          newState.showSites.length,
          newState.showSites.length + DirSiteState.pageCount));
    }
  }

  return newState;
}

DirSiteState _onAction(DirSiteState state, Action action) {
  final DirSiteState newState = state.clone();
  return newState;
}
