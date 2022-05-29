import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    RulesExplainState state, Dispatch dispatch, ViewService viewService) {
//  return Container();
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text('提现', style: TextStyle(color: Colors.black)),
      brightness: Brightness.light,
    ),
    body: Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        color: Colors.white,
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    "提现规则及说明",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "1、提现次数：每月最多3次，每次提现金额不少于100元。",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "2、提现每月累计9万。",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "3、提现不采取任何手续费。",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "4、到账时间：发起提现成功后2小时内到账。",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "5、请确认银行卡可以使用。",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
