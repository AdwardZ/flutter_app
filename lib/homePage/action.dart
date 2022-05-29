import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action

enum HomePageAction { action, goList, downPic, uploadPic }

class HomePageActionCreator {
  static Action onAction() {
    return const Action(HomePageAction.action);
  }

  static Action goList() {
    return const Action(HomePageAction.goList);
  }

  static Action onDownPic() {
    return const Action(HomePageAction.downPic);
  }

  static Action onUploadPic() {
    return const Action(HomePageAction.uploadPic);
  }
}
