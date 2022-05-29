import 'dart:collection';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutterappdemo/Api/Api.dart';
import 'package:flutterappdemo/main.dart';
import 'package:flutterappdemo/model/home_res_model.dart';
import 'package:flutterappdemo/resources/const_info.dart';
import 'package:flutterappdemo/utils/Spkey.dart';
import 'package:flutterappdemo/utils/event_bus.dart';
import 'package:flutterappdemo/utils/net_utils.dart';
import 'package:flutterappdemo/utils/offline_utils.dart';
import 'package:flutterappdemo/utils/util.dart';
import 'package:flutterappdemo/utils/file_utils.dart';
import 'action.dart';
import 'state.dart';
import 'package:flutter/material.dart' hide Action;

Effect<DirSiteState> buildEffect() {
  return combineEffects(<Object, Effect<DirSiteState>>{
    DirSiteAction.goDirOnePage: _goDirOnePage,
    DirSiteAction.back: _back,
    DirSiteAction.initDate: _initData,
    Lifecycle.initState: _init
  });
}

///请求返回
void _back(Action action, Context<DirSiteState> ctx) {
  /// 20220324: adward
  HomeResModel model = new HomeResModel();
  if (sp.hasKey(ConstInfo.bastPath + Api.HOME)) {
    model = HomeResModel.fromJson(sp.getObject(ConstInfo.bastPath + Api.HOME));
  }
  Navigator.pop(ctx.context, model);

  // HomeResModel model = HomeResModel.fromJson(sp.getObject(ConstInfo.bastPath + Api.HOME));
  // Navigator.pop(ctx.context, model);
}

///取子目录
void _goDirOnePage(Action action, Context<DirSiteState> ctx) {
  if (action.payload != null) {
    Navigator.pushNamed(ctx.context, "dirOnePage",
        arguments: {"appSite": action.payload}).then((value) {
      // 二级目录返回时调用
      ctx.state.appSites.forEach((appSite) async {
        var list = await OffineUtils.get43(siteId: appSite.siteId);
        appSite.needUploadNumber = list.length;
        if (appSite.uploadStatus != 3) {
          var bool = await OffineUtils.hasOffline(siteId: appSite.siteId);
          if (bool) {
            appSite.uploadStatus = 3;
          }
        }

        int i = 0;
        appSite.dirOnes.forEach((two) {
          i = i + two.uploadedNumber;
        });
        appSite.uploadedNumber = i;
        ctx.dispatch(DirSiteActionCreator.onAction());
      });
    });
  }
}

/// 首次进入基站页面后初始化调用
void _init(Action action, Context<DirSiteState> ctx) {
  //print("@@@@@@ Site page.init");
  /// 20220321: adward
  // 注册基站状态更新函数。二级目录状态更新后回调这个函数更新基站状态
  bus.on(Spkey.updateStatus, (arg) {
    ctx.state.appSites.firstWhere((element) => element.siteId == arg).approveStatus = 2;
    ctx.dispatch(DirSiteActionCreator.onAction());
  });
  // 下拉刷新
  ctx.state.easyRefreshController = EasyRefreshController();
  // 加载本地数据
  if (!sp.hasKey(ConstInfo.bastPath + Api.HOME)) {
    //print("no local data");
  } else {
    //print("load local data");
    HomeResModel model = HomeResModel.fromJson(sp.getObject(ConstInfo.bastPath + Api.HOME));
    ctx.dispatch(DirSiteActionCreator.requestAll(model.appSites));
  }

  // bus.on(Spkey.updateStatus, (arg) {
  //   ctx.state.appSites.firstWhere((element) => element.siteId == arg).approveStatus = 2;
  //   ctx.dispatch(oneActionCreator.onAction());
  // });
  // ctx.state.easyRefreshController = EasyRefreshController();
  // ctx.dispatch(oneActionCreator.requestAll(ctx.state.appSites));
  // _onDownPic(ctx.state.appSites, ctx);
}

/// [废弃]下拉刷新调用(为了效率暂时不刷新)
void _initData(Action action, Context<DirSiteState> ctx) {
  //print("@@@@@@ Site page.initData");
  //初始化接口
  // NetUtils.post(url: Api.HOME, params: {}, isCache: true, throwError: true)
  //     .then((value) {
  //   ctx.state.easyRefreshController.finishRefresh();
  //   if (value != null) {
  //     var model = HomeResModel.fromJson(value);
  //     sp.setObject(ConstInfo.bastPath + Api.HOME, model.toJson());
  //     bus.emit(Spkey.updateMainDate, model);
  //     ctx.dispatch(oneActionCreator.requestAll(model.appSites));
  //     //刷新完之后调用下载
  //     _onDownPic(model.appSites, ctx);
  //   }
  // }).catchError((e) {
  //   ctx.state.easyRefreshController.finishRefresh();
  //   if (!sp.hasKey(ConstInfo.bastPath + Api.HOME)) {
  //     Msg.toast("no cache");
  //     return;
  //   } else {
  //     HomeResModel model =
  //         HomeResModel.fromJson(sp.getObject(ConstInfo.bastPath + Api.HOME));
  //     ctx.dispatch(oneActionCreator.requestAll(model.appSites));
  //   }
  // });
}

/// [废弃]
void _onDownPic(List<AppSite> appSites, Context<DirSiteState> ctx) {
  //print("&& _onDownPic");
  //清理出所有需要下载的图片列表
  //List<String> downPicList = [];
  Set<String> downPicList = new HashSet();
  appSites.forEach((appSite) {
    appSite.dirOnes.forEach((dirOne) {
      dirOne.dirTwos.forEach((dirTwo) {
        dirTwo.dirThrees.forEach((dirThree) {
          // 20210516 adward: 因图片太多，服务端已去掉上传图片
          dirThree.uploadedPicUrls.forEach((element) {
            downPicList.add(element.fileUrl);
          });
          // 只下载模板example图片
          dirThree.examplePicUrls.forEach((element) {
            downPicList.add(element.fileUrl);
          });
        });
      });
    });
  });
  //开始下载
  FileUtils.downFileforOther(downPicList, ctx.context);
}
