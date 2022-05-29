import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action

enum UploadAction {
  action,
  goList,
  downPic,
  showPic,
}

class UploadActionCreator {
  static Action onAction() {
    return const Action(UploadAction.action);
  }

  static Action goList() {
    return const Action(UploadAction.goList);
  }

  static Action onDownPic() {
    return const Action(UploadAction.downPic);
  }

  static Action onShowPic() {
    return const Action(UploadAction.showPic);
  }
}
