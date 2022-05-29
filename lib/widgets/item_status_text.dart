import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutterappdemo/resources/base_style.dart';

///页面顶部蓝色部分
Widget buildBlueTopOne(String siteId, int approveStatus) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
    height: 80,
    decoration: new BoxDecoration(
      color: BColors.color_4489F5,
    ),
    child: Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 14),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: BColors.white,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            border: Border.all(width: 0, style: BorderStyle.none),
          ),
          child: Image.asset('assets/images/icon_site.png'),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(children: <Widget>[
                  Text(
                    "$siteId",
                    style: const TextStyle(color: BColors.white, fontSize: 14),
                  ),
                  //getApproveStatusText(approveStatus),
                ]),
              ),
//              Text("${siteId}",
//                  style: const TextStyle(
//                      color: BColors.white,
//                      fontSize: 16,
//                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
        //approveStatus==3?Icon(Icons.check_circle_outline_rounded,color: Colors.white):Icon(Icons.warning_amber_outlined,color: Colors.white)
      ],
    ),
  );
}

Widget buildBlueTopTwo(String siteId, String dirOneName, int approveStatus) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
    height: 80,
    decoration: new BoxDecoration(
      color: BColors.color_4489F5,
    ),
    child: Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 14),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: BColors.white,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            border: Border.all(width: 0, style: BorderStyle.none),
          ),
          child: Image.asset('assets/images/icon_site.png'),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 6),
                child: Row(children: <Widget>[
                  Text(
                    "${siteId}",
                    style: const TextStyle(color: BColors.white, fontSize: 14),
                  ),
                  //getApproveStatusText(approveStatus),
                ]),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text("└ $dirOneName",
                        style: const TextStyle(
                            color: BColors.white, fontSize: 14)),
                  ),
                ],
              )
            ],
          ),
        ),
        //approveStatus==3?Icon(Icons.check_circle_outline_rounded,color: Colors.white):Icon(Icons.warning_amber_outlined,color: Colors.white)
      ],
    ),
  );
}

///页面顶部蓝色部分
Widget buildBlueTopThree(String siteId, String dirOneName, String dirTwoName, int approveStatus) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
    height: 80,
    decoration: new BoxDecoration(
      color: BColors.color_4489F5,
    ),
    child: Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 14),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: BColors.white,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            border: Border.all(width: 0, style: BorderStyle.none),
          ),
          child: Image.asset('assets/images/icon_site.png'),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(children: <Widget>[
                  Text(
                    "$siteId",
                    style: const TextStyle(color: BColors.white, fontSize: 14),
                  ),
                  // 20220522: adward
                  //getApproveStatusText(approveStatus),
                ]),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text("└ $dirOneName",
                        style: const TextStyle(
                            color: BColors.white, fontSize: 14)),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text("    └ $dirTwoName",
                        style: const TextStyle(
                            color: BColors.white, fontSize: 14)),
                  ),
                ],
              )
            ],
          ),
        ),
        //approveStatus==3?Icon(Icons.check_circle_outline_rounded,color: Colors.white):Icon(Icons.warning_amber_outlined,color: Colors.white)
      ],
    ),
  );
}


///列表item
Widget buildItem(
    BuildContext context,
    Dispatch dispatch,
    String itemTitle,
    int uploadedNumber,
    int specifiedNumber,
    int uploadStatus,
    int approveStatus,
    int needUploadNumber,
    GestureTapCallback gestureTapCallback) {
  return GestureDetector(
    child: Container(
        decoration: new BoxDecoration(
          color: BColors.white,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
          decoration: new BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 0.5, color: BColors.greyD))),
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                    specifiedNumber < 0 ? "$itemTitle(-)" : "$itemTitle($needUploadNumber/$uploadedNumber/$specifiedNumber)",
                    style:
                        const TextStyle(color: BColors.black, fontSize: 14.0)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[getApproveStatusText(approveStatus)],
              ),
            ],
          ),
        )),
    onTap: gestureTapCallback,
  );
}

///列表状态文字
Widget getApproveStatusText(int approveStatus) {
  var text = "";
  var textColor;
  if (approveStatus == 1) {
    text = "To be uploaded";
    textColor = BColors.color_979797;//color_979797
  } else if (approveStatus == 2) {
    text = "To be approved";
    textColor = BColors.color_EE8F00;//color_EE8F00
  } else if (approveStatus == 3) {
    text = "Under approval";
    textColor = BColors.color_FF6EC7;//
  } else if (approveStatus == 4) {
    text = "Accepted";
    textColor = BColors.color_36CE27;//color_36CE27
  } else if (approveStatus == 5) {
    text = "Rejected";
    textColor = BColors.color_EE3A2C;//color_EE3A2C
  } else {
    text = "To be uploaded";
    textColor = BColors.color_979797;//color_979797
  }
  var textWidget =
      Text("    $text", style: TextStyle(color: textColor, fontSize: 12.0));
  return textWidget;
}

///获取图片上传状态
Widget getUploadStatusText(int uploadStatus) {
  var text = "";
  var textColor;
  if (uploadStatus == 1) {
    text = "No photos";
    textColor = BColors.color_979797;
  } else if (uploadStatus == 2) {
    text = "Upload completed";
    textColor = BColors.black;
  } else if (uploadStatus == 3) {
    text = "Offline photos";
    textColor = BColors.color_979797;
  } else {
    text = "No photos";
    textColor = BColors.color_979797;
  }

  var textWidget =
      Text(text, style: TextStyle(color: textColor, fontSize: 12.0));
  return textWidget;
}
