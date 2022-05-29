import 'package:fish_redux/fish_redux.dart';
import 'package:flutterappdemo/model/home_res_model.dart';
import 'package:flutterappdemo/utils/offline_utils.dart';

class DirOneState implements Cloneable<DirOneState> {
  AppSite appSite;

  @override
  DirOneState clone() {
    return DirOneState()..appSite = appSite;
  }
}

DirOneState initState(Map<String, dynamic> args) {
  AppSite appSite;
  if (args != null) {
    appSite = args["appSite"];
    //初始化父类id
    appSite.dirOnes.forEach((dirOne) async {
      var list = await OffineUtils.get43(dirOneId: dirOne.bizKey);
      dirOne.siteId = appSite.siteId;
      dirOne.needUploadNumber = list.length;
      if (dirOne.uploadStatus != 3) {
        var bool = await OffineUtils.hasOffline(dirOneId: dirOne.bizKey);
        if (bool) {
          dirOne.uploadStatus = 3;
        }
      }
    });
  }

  return DirOneState()..appSite = appSite;
}
