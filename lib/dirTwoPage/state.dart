import 'package:fish_redux/fish_redux.dart';
import 'package:flutterappdemo/model/home_res_model.dart';
import 'package:flutterappdemo/utils/offline_utils.dart';

class DirTwoState implements Cloneable<DirTwoState> {
  DirOne dirOne;

  @override
  DirTwoState clone() {
    return DirTwoState()..dirOne = dirOne;
  }
}

DirTwoState initState(Map<String, dynamic> args) {
  DirOne dirOne;
  if (args != null) {
    dirOne = args["dirOne"];
    //初始化父类id
    dirOne.dirTwos.forEach((dirTwo) async {
      var list = await OffineUtils.get43(dirTwoId: dirTwo.bizKey);
      dirTwo.siteId = dirOne.siteId;
      dirTwo.dirOneId = dirOne.bizKey;
      dirTwo.dirOneName = dirOne.name;
      //
      dirTwo.needUploadNumber = list.length;
      if (dirTwo.uploadStatus != 2 && dirTwo.uploadStatus != 3) {
        var bool = await OffineUtils.hasOffline(dirTwoId: dirTwo.bizKey);
        if (bool) {
          dirTwo.uploadStatus = 3;
        }
      }
    });
  }

  return DirTwoState()..dirOne = dirOne;
}
