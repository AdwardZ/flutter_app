import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutterappdemo/uploadPicture/upload_picture_view.dart';
import 'package:flutterappdemo/utils/Spkey.dart';
import 'package:flutterappdemo/utils/event_bus.dart';
import 'package:flutterappdemo/utils/net_utils.dart';
import 'package:flutterappdemo/utils/offline_utils.dart';
import 'package:flutterappdemo/utils/util.dart';
import 'package:flutterappdemo/Api/Api.dart';
import 'package:flutterappdemo/resources/const_info.dart';

import 'action.dart';
import 'state.dart';

Effect<DirThreeState> buildEffect() {
  return combineEffects(<Object, Effect<DirThreeState>>{
    DirThreeAction.back: _back,
    DirThreeAction.detail: _goDetail,
    DirThreeAction.submit: _request,
    Lifecycle.initState: _init
  });
}

void _back(Action action, Context<DirThreeState> ctx) {
  Navigator.pop(ctx.context);
}

void _init(Action action, Context<DirThreeState> ctx) {
  ctx.state.dirTwo.dirThrees.forEach((dirThree) async {
    var list = await OffineUtils.get43(dirThreeId: dirThree.bizKey);
    dirThree.needUploadNumber = list.length;
    if (dirThree.uploadStatus != 3) {
      var bool = await OffineUtils.hasOffline(dirThreeId: dirThree.bizKey);
      if (bool) {
        dirThree.uploadStatus = 3;
      }
    }
    ctx.dispatch(DirThreeActionCreator.onAction());
  });
}

void _goDetail(Action action, Context<DirThreeState> ctx) {
  Navigator.pushNamed(ctx.context, 'uploadPage', arguments: {
    "dirThree": action.payload
  }).then((value) {
    ctx.state.dirTwo.dirThrees.forEach((dirThree) async {
      // 从上传图片页面返回到这里(三级目录)时调用，从二级目录到这里不会调用
      var list = await OffineUtils.get43(dirThreeId: dirThree.bizKey);
      dirThree.needUploadNumber = list.length;
      if (dirThree.uploadStatus != 3) {
        var bool = await OffineUtils.hasOffline(dirThreeId: dirThree.bizKey);
        if (bool) {
          dirThree.uploadStatus = 3;
        }
      }
      /// 20220324: adward
      //dirThree.uploadedNumber = dirThree.uploadedPicUrls.where((pic) => pic.id != null).length;
      ctx.dispatch(DirThreeActionCreator.onAction());
    });
  });
  return;
}

///提交该目录
Future<void> _request(
    Action action, Context<DirThreeState> ctx) async {
  if (ctx.state.dirTwo.approveStatus == 3 ||ctx.state.dirTwo.approveStatus == 4) {
    Msg.toast("Can Not  SUBMIT_REVIEW");
    return;
  }
  bool isShow = true;
  showLoadingDialog(ctx.context);
  var res = await NetUtils.post(
          url: Api.SUBMIT_REVIEW,
          isMask: true,
          params: {
            'level': ConstInfo.SUBMIT_LEVEL_DIRTHREE,
            'id': ctx.state.dirTwo.bizKey
          },
          throwError: true)
      .catchError((e) {
    if (isShow) {
      Navigator.pop(ctx.context);
      isShow = false;
    }
  });
  if (isShow) {
    Navigator.pop(ctx.context);
    isShow = false;
  }
  if (res != null) {
    ctx.dispatch(DirThreeActionCreator.submitSuccess());
    bus.emit(Spkey.updateStatus, ctx.state.dirTwo.bizKey);
    Msg.toast("submit success ");
  }
  return;
}
