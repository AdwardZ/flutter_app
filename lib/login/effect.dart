import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutterappdemo/Api/Api.dart';
import 'package:flutterappdemo/model/user.dart';
import 'package:flutterappdemo/utils/StringUtile.dart';
import 'package:flutterappdemo/utils/data_utils.dart';
import 'package:flutterappdemo/utils/net_utils.dart';
import 'package:flutterappdemo/utils/shared_preferences.dart';
import 'package:flutterappdemo/utils/util.dart';
import 'action.dart';
import 'state.dart';

Effect<LoginState> buildEffect() {
  return combineEffects(<Object, Effect<LoginState>>{
    LoginAction.action: _onAction,
    LoginAction.login: _onLogin,
    Lifecycle.initState: _init,
  });
}

void _onAction(Action action, Context<LoginState> ctx) {}

Future<void> _init(Action action, Context<LoginState> ctx) async {
  SpUtil sp = await SpUtil.getInstance();
  ctx.state.loginIdController.text = sp.get("loginName") ?? "";
  ctx.state.loginPwdController.text = sp.get("pass") ?? "";
}

Future<void> _onLogin(Action action, Context<LoginState> ctx) async {
  if (StringUtile.isEmpty(ctx.state.loginIdController.text.trim())) {
    Msg.toast("账户不能为空");
    return;
  }
  if (StringUtile.isEmpty(ctx.state.loginPwdController.text.trim())) {
    Msg.toast("密码不能为空");
    return;
  }
  bool isShow = true;
  showLoadingDialog(ctx.context);
  var res = await NetUtils.post(
          url: Api.LOGIN,
          params: {
            'loginName': ctx.state.loginIdController.text.trim(),
            'password': ctx.state.loginPwdController.text.trim()
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
    User user = User();
    user.userName = res['userName'];
    //user.userType = res['userType'];
    DataUtils.setUser(user);
    DataUtils.setUserName(user.userName);
    SpUtil sp = await SpUtil.getInstance();
    sp.putString("loginName", ctx.state.loginIdController.text);
    sp.putString("pass", ctx.state.loginPwdController.text);
    Navigator.pushNamedAndRemoveUntil(
        ctx.context, 'homePage', (Route<dynamic> route) => false);
  }
}
