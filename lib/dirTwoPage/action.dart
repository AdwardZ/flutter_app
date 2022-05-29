import 'package:fish_redux/fish_redux.dart';
import 'package:flutterappdemo/model/home_res_model.dart';

enum DirTwoAction { action, back, goNextCategory, submit, submitSuccess }

class DirTwoActionCreator {
  static Action onAction() {
    return const Action(DirTwoAction.action);
  }

  static Action back() {
    return const Action(DirTwoAction.back);
  }

  static Action goNextCategory(DirTwo dirTwo) {
    return Action(DirTwoAction.goNextCategory, payload: dirTwo);
  }

  static Action submit() {
    return const Action(DirTwoAction.submit);
  }

  static Action submitSuccess() {
    return const Action(DirTwoAction.submitSuccess);
  }
}
