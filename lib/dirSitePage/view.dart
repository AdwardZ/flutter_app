import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutterappdemo/dirOnePage/action.dart';
import 'package:flutterappdemo/model/home_res_model.dart';
import 'package:flutterappdemo/resources/base_style.dart';
import 'package:flutterappdemo/utils/adapt.dart';
import 'package:flutterappdemo/widgets/item_status_text.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(DirSiteState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: new IconButton(
            icon: Image.asset('assets/images/icon_left_arrow.png'),
            onPressed: () {
              dispatch(DirSiteActionCreator.back());
            }),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Site List', style: TextStyle(color: Colors.black)),
        brightness: Brightness.light,
      ),
      body: Container(
          decoration: new BoxDecoration(
            color: BColors.color_F0F2F5,
          ),
          child: Column(
            children: <Widget>[
              Container(
                  decoration: new BoxDecoration(
                    color: BColors.white,
                  ),
                  child: new ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: 30, maxWidth: double.infinity),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 12.0),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                              color: BStyle.titleColor,
                              fontSize: BStyle.fBody,
                              textBaseline: TextBaseline.alphabetic),
                          textInputAction: TextInputAction.none,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: BColors.color_4489F5, width: 1.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: BColors.color_4489F5, width: 1.0)),
                              prefixIcon: Icon(
                                Icons.search,
                                color: BStyle.contentColor,
                                size: Adapt.px(BStyle.icoSize),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Input site ID",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: BStyle.fBody,
                              )),
                          onChanged: (s) {
                            dispatch(DirSiteActionCreator.searchSite(s));
                            state.easyRefreshController.resetLoadState();
                            state.easyRefreshController.finishRefresh();
                          },
                        ),
                      ))),
              Expanded(
                child: EasyRefresh(
                  controller: state.easyRefreshController,
                  /// 20220321: adward
                  enableControlFinishRefresh: false,
                  //enableControlFinishRefresh: true,
                  taskIndependence: true,
                  onRefresh: () async {
                    dispatch(DirSiteActionCreator.initDate());
                  },
                  child: ListView.separated(
                      itemBuilder: (context, i) {
                        //print("### ListView.Sites.size=" + '${state.showSites.length}');
                        var appSite = state.showSites[i];
                        return buildItem(
                            context,
                            dispatch,
                            appSite.siteId,
                            appSite.uploadedNumber,
                            appSite.specifiedNumber,
                            appSite.uploadStatus,
                            appSite.approveStatus,
                            appSite.needUploadNumber, () {
                          dispatch(DirSiteActionCreator.goDirOnePage(appSite));
                        });
                      },
                      itemCount: state.showSites.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(height: 1.0, color: BColors.greyD)),
                ),
              ),
            ],
          )));
}
