import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutterappdemo/Api/Api.dart';
import 'package:flutterappdemo/uploadPage/action.dart';
import 'package:flutterappdemo/resources/const_info.dart';
import 'package:flutterappdemo/uploadPicture/upload_picture_view.dart';
import 'package:flutterappdemo/utils/Spkey.dart';
import 'package:flutterappdemo/utils/event_bus.dart';
import 'package:flutterappdemo/utils/net_utils.dart';
import 'package:flutterappdemo/utils/offline_utils.dart';
import 'package:flutterappdemo/utils/util.dart';

import 'action.dart';
import 'state.dart';

Effect<DirTwoState> buildEffect() {
  return combineEffects(<Object, Effect<DirTwoState>>{
    DirTwoAction.back: _back,
    DirTwoAction.goNextCategory: _goNextCategory,
    DirTwoAction.submit: _request,
    Lifecycle.initState: _init,
  });
}

void _init(Action action, Context<DirTwoState> ctx) {
  bus.on(Spkey.updateStatus, (arg) {
    ctx.state.dirOne.dirTwos
        .firstWhere((dirTwo) => dirTwo.bizKey == arg)
        .approveStatus = 2;
    ctx.dispatch(UploadActionCreator.onAction());
  });
  ctx.state.dirOne.dirTwos.forEach((dirTwo) async {
    var list = await OffineUtils.get43(dirTwoId: dirTwo.bizKey);
    dirTwo.needUploadNumber = list.length;
    ctx.dispatch(DirTwoActionCreator.onAction());
  });
}

void _back(Action action, Context<DirTwoState> ctx) {
  Navigator.pop(ctx.context);
}

void _goNextCategory(Action action, Context<DirTwoState> ctx) {
  print("&& Two -> Three  _goNextCategory");
  Navigator.pushNamed(ctx.context, "dirThreePage",
      arguments: {"dirTwo": action.payload}).then((value) {
    ctx.state.dirOne.dirTwos.forEach((dirTwo) async {
      var list = await OffineUtils.get43(dirTwoId: dirTwo.bizKey);
      dirTwo.needUploadNumber = list.length;
      if (dirTwo.uploadStatus != 3) {
        var bool = await OffineUtils.hasOffline(dirTwoId: dirTwo.bizKey);
        if (bool) {
          dirTwo.uploadStatus = 3;
        }
      }
      int i = 0;
      dirTwo.dirThrees.forEach((three) {
        i = i + three.uploadedNumber;
      });
      dirTwo.uploadedNumber = i;
      ctx.dispatch(DirTwoActionCreator.onAction());
    });
  });
  return;
}

Future<void> _request(Action action, Context<DirTwoState> ctx) async {
  if (ctx.state.dirOne.approveStatus == 3 || ctx.state.dirOne.approveStatus == 4) {
    Msg.toast("Can Not  SUBMIT_REVIEW");
    return;
  }
  bool isShow = true;
  showLoadingDialog(ctx.context);
  var res = await NetUtils.post(
          url: Api.SUBMIT_REVIEW,
          params: {
            'level': ConstInfo.SUBMIT_LEVEL_DIRTWO,
            'id': ctx.state.dirOne.siteId
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
    ctx.dispatch(DirTwoActionCreator.submitSuccess());
    bus.emit(Spkey.updateStatus, ctx.state.dirOne.siteId);
    Msg.toast("submit success");
  }
  return;
}
