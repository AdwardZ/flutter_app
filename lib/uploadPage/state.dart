import 'package:fish_redux/fish_redux.dart';
import 'package:flutterappdemo/model/home_res_model.dart';

class UploadState implements Cloneable<UploadState> {
  DirThree dirThree;

  @override
  UploadState clone() {
    return UploadState()
      ..dirThree = dirThree;
  }
}

UploadState initState(Map<String, dynamic> args) {
  return UploadState()
    ..dirThree = args['dirThree'];
}
