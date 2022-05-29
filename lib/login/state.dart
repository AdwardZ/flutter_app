import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';

class LoginState implements Cloneable<LoginState> {
  TextEditingController loginIdController = TextEditingController();
  TextEditingController loginPwdController = TextEditingController();
  FocusNode loginIdFocusNode = FocusNode();
  FocusNode loginPwdFocusNode = FocusNode();

  @override
  LoginState clone() {
    return LoginState()
      ..loginIdController = loginIdController
      ..loginIdFocusNode = loginIdFocusNode
      ..loginPwdController = loginPwdController
      ..loginPwdFocusNode = loginPwdFocusNode;
  }
}

LoginState initState(Map<String, dynamic> args) {
  return LoginState();
}
