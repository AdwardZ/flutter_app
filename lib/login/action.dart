import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum LoginAction { action, login }

class LoginActionCreator {
  static Action onAction() {
    return const Action(LoginAction.action);
  }

  static Action onLogin() {
    return const Action(LoginAction.login);
  }
}
