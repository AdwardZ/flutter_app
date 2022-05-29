import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterappdemo/Api/Api.dart';
import 'package:flutterappdemo/utils/adapt.dart';
import 'package:flutterappdemo/utils/net_utils.dart';
import 'package:flutterappdemo/utils/util.dart';
import 'package:flutterappdemo/utils/data_utils.dart';
import 'package:flutterappdemo/widgets/button_group.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    HomeState state, Dispatch dispatch, ViewService viewService) {
//  return Container();
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(0),
      child: AppBar(
        backgroundColor: Color(0xFF66AFF0),
      ),
    ),
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: Adapt.px(450),
            decoration: BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('assets/images/bg_first.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Center(
                    child: Text(
                      "Welcome\n" + '${DataUtils.getUserName()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: Adapt.px(24),
                          color: Colors.white70),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 20),
                  child: Center(
                    child: Text(
                      "Acceptance upload",
                      style: TextStyle(
                          fontSize: Adapt.px(34), color: Colors.white70),
                    ),
                  ),
                ),
                Center(
                    child: GestureDetector(
                        onTap: () {
                          dispatch(HomePageActionCreator.goList());
                        },
                        child: Image.asset('assets/images/bg_first_icon.png')))
              ],
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 0, 32, 0),
          child: Container(
            height: Adapt.px(50),
            color: Color(0xFF4489F5),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  dispatch(HomePageActionCreator.onDownPic());
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 50,
                    ),
                    Image.asset(
                      'assets/images/down_icon.png',
                      width: 20,
                      height: 20,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Download Sites&Example',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Adapt.px(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 16, 32, 8),
          child: Container(
            height: Adapt.px(50),
            color: Color(0xFF4489F5),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  dispatch(HomePageActionCreator.onUploadPic());
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 50,
                    ),
                    Image.asset(
                      'assets/images/upload_icon.png',
                      width: 20,
                      height: 20,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Upload offline image     ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Adapt.px(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 16, 32, 8),
          child: Container(
            height: Adapt.px(50),
            color: Color(0xFF4489F5),
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  bool isShwo = true;
                  showLoadingDialog(viewService.context);
                  var res = await NetUtils.post(
                          url: Api.LOGINOUT, params: {}, throwError: true)
                      .catchError((e) {
                    if (isShwo) {
                      Navigator.pop(viewService.context);
                      isShwo = false;
                    }
                  });
                  if (isShwo) {
                    Navigator.pop(viewService.context);
                    isShwo = false;
                  }
                  if (res != null) {
                    navigatorKey.currentState.pushNamedAndRemoveUntil(
                        'login', (Route<dynamic> route) => false);
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Text(
                          'LoginOut',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Adapt.px(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
