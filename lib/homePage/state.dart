import 'package:fish_redux/fish_redux.dart';
import 'package:flutterappdemo/model/home_res_model.dart';

class HomeState implements Cloneable<HomeState> {
  HomeResModel model;

  @override
  HomeState clone() {
    return HomeState()..model = model;
  }
}

HomeState initState(Map<String, dynamic> args) {
  return HomeState();
}
