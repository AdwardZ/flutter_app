import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterappdemo/uploadPicture/upload_picture_view.dart';

import 'state.dart';

Widget buildView(
    UploadState state, Dispatch dispatch, ViewService viewService) {
//  return Container();
  return UploadPictureViewPage(
    dirThree: state.dirThree
  );
}
