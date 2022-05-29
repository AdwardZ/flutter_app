import 'package:fish_redux/fish_redux.dart';
import 'package:flutterappdemo/model/home_res_model.dart';
import 'package:flutterappdemo/utils/offline_utils.dart';

class DirThreeState implements Cloneable<DirThreeState> {
  DirTwo dirTwo;

  @override
  DirThreeState clone() {
    return DirThreeState()..dirTwo = dirTwo;
  }
}

DirThreeState initState(Map<String, dynamic> args) {
  DirTwo dirTwo;
  if (args != null) {
    dirTwo = args["dirTwo"];
    dirTwo.dirThrees.forEach((dirThree) async {
      dirThree.siteId = dirTwo.siteId;
      dirThree.dirOneId = dirTwo.dirOneId;
      dirThree.dirOneName = dirTwo.dirOneName;
      dirThree.dirTwoId = dirTwo.bizKey;
      dirThree.dirTwoName = dirTwo.name;
      //
      // !!BUG：获取图片需要时间，导致上传图片界面先生成，此时没有离线图片，待返回上级（三级）目录后再进入上传图片页面就能看到离线图片
      // 修改：在DirThreeState initState中先初始化数据
      var offlines = await OffineUtils.get(dirThree.bizKey);
      offlines.forEach((x) {
        if (!dirThree.uploadedPicUrls.any((element) => element.filePath == x.path)) {
          dirThree.uploadedPicUrls.add(UploadedPicUrls(
            fileName: '',
            fileUrl: x.path,
            filePath: x.path,
          ));
        }
      });
     // var list = await OffineUtils.get43(dirThreeId: dirThree.bizKey);
      dirThree.needUploadNumber = offlines.length;
      //寻找是否有离线图片
      if (dirThree.uploadStatus != 3 && offlines.length > 0) {
        dirThree.uploadStatus = 3;
      }
    });
  }
  return DirThreeState()..dirTwo = dirTwo;
}
