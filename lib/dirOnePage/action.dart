import 'package:fish_redux/fish_redux.dart';
import 'package:flutterappdemo/model/home_res_model.dart';

enum DirOneAction { action, back, goNextCategory, submit, submitSuccess }

class DirOneActionCreator {
  static Action onAction() {
    return const Action(DirOneAction.action);
  }

  static Action back() {
    return const Action(DirOneAction.back);
  }

  static Action goNextCategory(DirOne dirOne) {
    return Action(DirOneAction.goNextCategory, payload: dirOne);
  }

  static Action submit() {
    return const Action(DirOneAction.submit);
  }

  static Action submitSuccess() {
    return const Action(DirOneAction.submitSuccess);
  }
}
