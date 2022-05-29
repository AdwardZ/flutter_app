import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutterappdemo/Api/Api.dart';
import 'package:flutterappdemo/resources/const_info.dart';
import 'package:flutterappdemo/uploadPage/action.dart';
import 'package:flutterappdemo/uploadPicture/upload_picture_view.dart';
import 'package:flutterappdemo/utils/Spkey.dart';
import 'package:flutterappdemo/utils/event_bus.dart';
import 'package:flutterappdemo/utils/net_utils.dart';
import 'package:flutterappdemo/utils/offline_utils.dart';
import 'package:flutterappdemo/utils/util.dart';

import 'action.dart';
import 'state.dart';

Effect<DirOneState> buildEffect() {
  return combineEffects(<Object, Effect<DirOneState>>{
    DirOneAction.back: _back,
    DirOneAction.goNextCategory: _goNextCategory,
    DirOneAction.submit: _request,
    Lifecycle.initState: _init,
  });
}

void _init(Action action, Context<DirOneState> ctx) {
  bus.on(Spkey.updateStatus, (arg) {
    ctx.state.appSite.dirOnes
        .firstWhere((dirOne) => dirOne.bizKey == arg)
        .approveStatus = 2;
    ctx.dispatch(UploadActionCreator.onAction());
  });

  ctx.state.appSite.dirOnes.forEach((dirOne) async {
    var list = await OffineUtils.get43(dirOneId: dirOne.bizKey);
    dirOne.needUploadNumber = list.length;
    ctx.dispatch(DirOneActionCreator.onAction());
  });
}

void _back(Action action, Context<DirOneState> ctx) {
  Navigator.pop(ctx.context);
}

void _goNextCategory(Action action, Context<DirOneState> ctx) {
  Navigator.pushNamed(ctx.context, "dirTwoPage",
      arguments: {"dirOne": action.payload}).then((value) {
    ctx.state.appSite.dirOnes.forEach((dirOne) async {
      var list = await OffineUtils.get43(dirOneId: dirOne.bizKey);
      dirOne.needUploadNumber = list.length;
      if (dirOne.uploadStatus != 3) {
        var bool = await OffineUtils.hasOffline(dirOneId: dirOne.bizKey);
        if (bool) {
          dirOne.uploadStatus = 3;
        }
      }
      int i = 0;
      dirOne.dirTwos.forEach((three) {
        i = i + three.uploadedNumber;
      });
      dirOne.uploadedNumber = i;
      ctx.dispatch(DirOneActionCreator.onAction());
    });
  });
  return;
}

Future<void> _request(Action action, Context<DirOneState> ctx) async {
  if (ctx.state.appSite.approveStatus == 3 || ctx.state.appSite.approveStatus == 4) {
    Msg.toast("Can Not  SUBMIT_REVIEW");
    return;
  }
  bool isShow = true;
  showLoadingDialog(ctx.context);
  var res = await NetUtils.post(
          url: Api.SUBMIT_REVIEW,
          params: {
            'level': ConstInfo.SUBMIT_LEVEL_DIRONE,
            'id': ctx.state.appSite.siteId
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
    ctx.dispatch(DirOneActionCreator.submitSuccess());
    bus.emit(Spkey.updateStatus, ctx.state.appSite.siteId);
    Msg.toast("submit success");
  }
  return;
}
