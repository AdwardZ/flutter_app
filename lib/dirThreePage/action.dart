import 'package:fish_redux/fish_redux.dart';
import 'package:flutterappdemo/model/home_res_model.dart';

enum DirThreeAction { action, back, detail, submit, submitSuccess }

class DirThreeActionCreator {
  static Action onAction() {
    return const Action(DirThreeAction.action);
  }

  static Action back() {
    return const Action(DirThreeAction.back);
  }

  static Action goDetail(DirThree dirThree) {
    return Action(DirThreeAction.detail, payload: dirThree);
  }

  static Action submit() {
    return const Action(DirThreeAction.submit);
  }

  static Action submitSuccess() {
    return const Action(DirThreeAction.submitSuccess);
  }
}
