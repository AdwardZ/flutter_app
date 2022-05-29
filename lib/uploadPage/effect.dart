import 'dart:convert';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutterappdemo/Api/Api.dart';
import 'package:flutterappdemo/main.dart';
import 'package:flutterappdemo/model/home_res_model.dart';
import 'package:flutterappdemo/model/upLoadPicModel.dart';
import 'package:flutterappdemo/resources/const_info.dart';
import 'package:flutterappdemo/utils/Spkey.dart';
import 'package:flutterappdemo/utils/file_utils.dart';
import 'package:flutterappdemo/utils/net_utils.dart';
import 'package:flutterappdemo/utils/offline_utils.dart';
import 'package:flutterappdemo/utils/util.dart';
import 'action.dart';
import 'state.dart';

Effect<UploadState> buildEffect() {
  return combineEffects(<Object, Effect<UploadState>>{
    Lifecycle.initState: _init,
  });
}

Future<void> _init(Action action, Context<UploadState> ctx) async {
  ctx.state.dirThree.examplePicUrls.forEach((file) async {
    file.filePath = await FileUtils.picPath(file.fileUrl);
    ctx.dispatch(UploadActionCreator.onAction());
  });
  ctx.state.dirThree.uploadedPicUrls.forEach((file) async {
    if (file.filePath == null || file.filePath.isEmpty) {
      file.filePath = await FileUtils.picPath(file.fileUrl);
      ctx.dispatch(UploadActionCreator.onAction());
    }
  });
  // 获取三级目录下对应的离线图片
  // !!BUG：获取图片需要时间，导致上传图片界面先生成，此时没有离线图片，待返回上级（三级）目录后再进入上传图片页面就能看到离线图片
  // 修改：在DirThreeState initState中先初始化数据
  var offlines = await OffineUtils.get(ctx.state.dirThree.bizKey);
  offlines.forEach((x) {
    if (!ctx.state.dirThree.uploadedPicUrls.any((element) => element.filePath == x.path)) {
      ctx.state.dirThree.uploadedPicUrls.add(UploadedPicUrls(
        fileName: '',
        fileUrl: x.path,
        filePath: x.path,
      ));
    }
  });
}
