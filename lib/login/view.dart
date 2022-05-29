import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterappdemo/resources/base_style.dart';
import 'package:flutterappdemo/utils/adapt.dart';
import 'package:flutterappdemo/widgets/button_group.dart';
import 'package:flutterappdemo/widgets/form_field.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(LoginState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    backgroundColor: Color(0xFF2966C3),
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(0),
      child: AppBar(
        backgroundColor: Color(0x804489F5),
      ),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0x804489F5),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      '华信邮电\nHUAXINGPT',
                      style: TextStyle(
                          color: Colors.white, fontSize: Adapt.px(14)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 16, 16, 16),
                    child: Text(
                      'Log Into \nYour account',
                      style: TextStyle(
                          color: Colors.white, fontSize: Adapt.px(30)),
                    ),
                  ),
                ],
              ),
            ),
            buildForm(state, dispatch, viewService),
            Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 16, 16, 16),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Button(
                "SIGN IN",
                isGradient: true,
                backgroundColor: Color(0x804489F5),
                onTap: () {
                  dispatch(LoginActionCreator.onLogin());
                  //
                  // dispatch(LoginActionCreator.onLogin());
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildForm(LoginState state, Dispatch dispatch, ViewService viewService) {
  var theme = Theme.of(viewService.context);
  return Theme(
    data: theme.copyWith(primaryColor: BStyle.contentColor),
    child: Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: Adapt.px(20),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: createTextFormField(
                labelText: 'User Name',
                maxLength: 30,
                controller: state.loginIdController,
                focusNode: state.loginIdFocusNode,
                keyboardType: TextInputType.text),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Divider(
              height: 1,
              color: Colors.white30,
            ),
          ),
          SizedBox(
            height: Adapt.px(20),
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: createTextFormField(
                    labelText: 'Password',
                    controller: state.loginPwdController,
                    focusNode: state.loginPwdFocusNode,
                    obscureText: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  '',
                  style: TextStyle(
                    color: BStyle.titleColor,
                    fontSize: BStyle.fBody,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Divider(
              height: 1,
              color: Colors.white30,
            ),
          ),
        ],
      ),
    ),
  );
}
