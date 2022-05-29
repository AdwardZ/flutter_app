import 'dart:collection';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutterappdemo/Api/Api.dart';
import 'package:flutterappdemo/main.dart';
import 'package:flutterappdemo/model/home_res_model.dart';
import 'package:flutterappdemo/model/upLoadPicModel.dart';
import 'package:flutterappdemo/resources/const_info.dart';
import 'package:flutterappdemo/utils/Spkey.dart';
import 'package:flutterappdemo/utils/event_bus.dart';
import 'package:flutterappdemo/utils/file_utils.dart';
import 'package:flutterappdemo/utils/net_utils.dart';
import 'package:flutterappdemo/utils/offline_utils.dart';
import 'package:flutterappdemo/utils/util.dart';
import 'action.dart';
import 'state.dart';

Effect<HomeState> buildEffect() {
  return combineEffects(<Object, Effect<HomeState>>{
    HomePageAction.action: _onAction,
    HomePageAction.goList: _goFirstList,
    Lifecycle.initState: _init,
    HomePageAction.downPic: _onDownPic,
    HomePageAction.uploadPic: _onUploadPic
  });
}

void _onAction(Action action, Context<HomeState> ctx) {
  //print("@@@@@@ homepage.onAction");
}

// 获得基站列表
void _goFirstList(Action action, Context<HomeState> ctx) {
  if (ctx.state.model != null && ctx.state.model.appSites != null) {
    //print("########### Go site page...model != null");
    Navigator.pushNamed(ctx.context, "dirSitePage",
            arguments: {"appSites": ctx.state.model.appSites})
        .then((value) => value != null ? ctx.state.model = value : null);
  } else {
    //print("########### Go site page...model == null");
    Navigator.pushNamed(ctx.context, "dirSitePage")
        .then((value) => value != null ? ctx.state.model = value : null);
  }
}

// 上传离线文件
Future<void> _onUploadPic(Action action, Context<HomeState> ctx) async {
  // 先心跳判断是否SESSION超时失效
  NetUtils.post(url: Api.HEARTBEAT, params: {}, isCache: true, throwError: true)
      .then((value) async {
    if (value != null) {
      //获取所有的离线图片
      List<OffineImage> uploadImage = await OffineUtils.getAll();
      FileUtils.uploadList(uploadImage, ctx.state.model, ctx.context);
    } else {

    }
  }).catchError((e) {
    print("_onUploadPic.catchError.e=$e");
    //print("e.runtimeType=" + '${e.runtimeType}');
  });
}

//
void _init(Action action, Context<HomeState> ctx) {
  //启动时初始化定位不起效果，所以放在这里
  var res = AndroidApi.invokeMethod('initLoc');
  //print(res.runtimeType);
  /// 20220321: adward 进入首页，如果有本地数据则加载，如果没有则空
  if (!sp.hasKey(ConstInfo.bastPath + Api.HOME)) {
    //print("no local data");
  } else {
    //print("load local data");
    ctx.state.model = HomeResModel.fromJson(sp.getObject(ConstInfo.bastPath + Api.HOME));
  }
  // bus.on(Spkey.updateMainDate, (arg) {
  //   ctx.state.model = arg;
  // });
  // NetUtils.post(url: Api.HOME, params: {}, isCache: true, throwError: true)
  //     .then((value) {
  //   if (value != null) {
  //     ctx.state.model = HomeResModel.fromJson(value);
  //     sp.setObject(ConstInfo.bastPath + Api.HOME, ctx.state.model.toJson());
  //   }
  // }).catchError((e) {
  //   if (!sp.hasKey(ConstInfo.bastPath + Api.HOME)) {
  //     Msg.toast("no cache");
  //     return;
  //   } else {
  //     ctx.state.model =
  //         HomeResModel.fromJson(sp.getObject(ConstInfo.bastPath + Api.HOME));
  //   }
  // });

}

// 下载所有模板图片
void _onDownPic(Action action, Context<HomeState> ctx) {
  /// 20220321: adward
  //print("@@@@@@ _onDownPic");
  //print("###########Get home json from tpm");
  // 显示进度滚动窗口
  showLoadingDialog(ctx.context);
  NetUtils.post(url: Api.HOME, params: {}, isCache: true, throwError: true)
      .then((value) {
    //print("##########End home json from tpm");
    // 关闭进度滚动窗口
    Navigator.of(ctx.context).pop();
    if (value != null) {
      //print("@@@@@@value=" + '$value');
      //print("# Json value != null");
      // TPM返回值存入model
      ctx.state.model = HomeResModel.fromJson(value);
      // http://www.sinohxph.com/app/vendor/home
      sp.setObject(ConstInfo.bastPath + Api.HOME, ctx.state.model.toJson());
      //print("# Put json into Object");
      _downPics(ctx);
    } else {
      //print("# Json value == null");
    }
  }).catchError((e) {
    print("_onDownPic.catchError.e=$e");
    //print("e.runtimeType=" + '${e.runtimeType}');
    // if(e.runtimeType == Response){
    //   print("Response");
    //   var data = e.data;
    //   int code = data["code"];
    //   print("# code=" + '$code');
    //   if (code == 150) {
    //
    //   }
    // }
    // if(e.runtimeType == DioError){
    //   //print("DioError");
    //   // 关闭进度滚动窗口
    //   Navigator.of(ctx.context).pop();
    // }
    // 关闭进度滚动窗口
    Navigator.of(ctx.context).pop();

    // 关闭进度滚动窗口
    //Navigator.of(ctx.context).pop();
    //Msg.toast('Error: connect to TPM Server!');
    // if (!sp.hasKey(ConstInfo.bastPath + Api.HOME)) {
    //   print("#No cache");
    //   Msg.toast("no cache");
    //   return;
    // } else {
    //   print("#From cache");
    //   ctx.state.model = HomeResModel.fromJson(sp.getObject(ConstInfo.bastPath + Api.HOME));
    //   _downPics(ctx);
    // }
  });
}

/// 20220321: adward
void _downPics(Context<HomeState> ctx) {
  //print("########### Start analysis pic list");
  //清理出所有需要下载的图片列表
  Set<String> downPicList = new HashSet();
  ctx.state.model.appSites.forEach((appSite) {
    //print("siteId=" + '${appSite.siteId}');
    appSite.dirOnes.forEach((dirOne) {
      //print("dirOne=" + '${dirOne.name}');
      dirOne.dirTwos.forEach((dirTwo) {
        //print("dirTwo=" + '${dirTwo.name}');
        dirTwo.dirThrees.forEach((dirThree) {
          //print("dirThree=" + '${dirThree.name}');
          dirThree.uploadedPicUrls.forEach((element) {
            // 20210516 adward: 因图片太多，服务端已去掉上传图片, 这里是空LIST
            downPicList.add(element.fileUrl);
          });
          dirThree.examplePicUrls.forEach((element) {
            // 只下载模板example图片
            // if (!sp.hasKey(element.fileUrl)) {
            //   print("--- not exist local: " + element.fileUrl);
            // }
            if(ConstInfo.isDownloadExamplePic) {
              downPicList.add(element.fileUrl);
            }
          });
        });
      });
    });
  });
  //开始下载（异步）
  FileUtils.downFileforOther(downPicList, ctx.context);
  //print("########### End analysis pic list");
}