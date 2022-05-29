import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutterappdemo/model/home_res_model.dart';
import 'package:flutterappdemo/resources/base_style.dart';
import 'package:flutterappdemo/widgets/item_status_text.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(DirThreeState state, Dispatch dispatch,
    ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      leading: new IconButton(
          icon: Image.asset('assets/images/icon_left_arrow.png'),
          onPressed: () {
            dispatch(DirThreeActionCreator.back());
          }),
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text('Third level catalog', style: TextStyle(color: Colors.black)),
      brightness: Brightness.light,
    ),
    body: Container(
      decoration: new BoxDecoration(
        color: BColors.color_F0F2F5,
      ),
      child: Column(
        children: <Widget>[
          ///蓝色部分
          buildBlueTopThree(state.dirTwo.siteId, state.dirTwo.dirOneName, state.dirTwo.name, state.dirTwo.approveStatus),

          ///列表
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, i) {
                  var dirThree = state.dirTwo.dirThrees[i];
                  return buildItem(
                      context,
                      dispatch,
                      dirThree.name,
                      dirThree.uploadedNumber,
                      dirThree.specifiedNumber,
                      dirThree.uploadStatus,
                      dirThree.approveStatus,
                      dirThree.needUploadNumber, () {
                    dispatch(
                        DirThreeActionCreator.goDetail(dirThree));
                  });
                },
                itemCount: state.dirTwo.dirThrees.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(height: 1.0, color: BColors.greyD)),
          ),

          ///底部
          // Container(
          //   margin: EdgeInsets.only(top: 1),
          //   alignment: Alignment.topLeft,
          //   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20.0),
          //   height: 100,
          //   decoration: new BoxDecoration(
          //     color: BColors.white,
          //   ),
          //   child: SizedBox(
          //     width: double.infinity,
          //     height: 50,
          //     child: RaisedButton(
          //       child: Text('Submit to approve'),
          //       onPressed: () {
          //         dispatch(DirThreeActionCreator.submit());
          //       },
          //       textColor: Colors.white,
          //       color: (state.dirTwo.approveStatus == 2 ||
          //               state.dirTwo.approveStatus == 4)
          //           ? Colors.white70
          //           : BColors.color_4489F5,
          //     ),
          //   ),
          // )
        ],
      ),
    ),
  );
}
