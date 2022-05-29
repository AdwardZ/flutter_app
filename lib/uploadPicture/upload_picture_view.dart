 import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutterappdemo/Api/Api.dart';
import 'package:flutterappdemo/resources/const_info.dart';
import 'package:flutterappdemo/utils/net_utils.dart';
import 'package:flutterappdemo/utils/util.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutterappdemo/model/home_res_model.dart';
import 'package:flutterappdemo/resources/base_style.dart';
import 'package:flutterappdemo/uploadPicture/tipview_chosse_view.dart';
import 'package:flutterappdemo/uploadPicture/tipview_exampleImage_view.dart';
import 'package:flutterappdemo/uploadPicture/upload_picture_tipview.dart';
import 'package:flutterappdemo/utils/file_utils.dart';
import 'package:flutterappdemo/utils/offline_utils.dart';
import 'package:flutterappdemo/utils/photo_utils.dart';
import 'package:flutter/cupertino.dart';

class UploadPictureViewPage extends StatefulWidget {
  DirThree dirThree;

  UploadPictureViewPage({Key key, DirThree dirThree})
      : super(key: key) {
    this.dirThree = dirThree;
  }

  @override
  _UploadPictureViewPageState createState() => _UploadPictureViewPageState();
}

class _UploadPictureViewPageState extends State<UploadPictureViewPage> {
  TextEditingController textController = new TextEditingController();
  TextEditingController dialogTextController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    //textController.text = this.widget.model.comments;
    String txt = this.widget.dirThree.comments;
    //print(">>>>>>>>>>>txt=" + '$txt');
    if(txt != null){
      txt = txt.replaceAll("<br>", "\n");
    }
    textController.text = txt;
    // dialogTextController.text ="11111";
    // 先心跳判断是否SESSION超时失效
    NetUtils.post(url: Api.HEARTBEAT, params: {}, isCache: true, throwError: true)
        .then((value) async {
      if (value != null) {
        // int code = value["code"];
        // print("# code=" + '$code');
        // if (code == 150) {
        //   Msg.toast("Login timed out, please login again!");
        //   return;
        // }
      }
    }).catchError((e) {
      // print("_onUploadPic.catchError.e=$e");
      // print("e.runtimeType=" + '${e.runtimeType}');
      // if(e.runtimeType == Response){
      //   print("e.runtimeType=Response");
      //   var data = e.data;
      //   int code = data["code"];
      //   print("# code=" + '$code');
      //   if (code == 150) {
      //     Msg.toast("Login timed out, please login again!");
      //     return;
      //   }
      // } else {
      //   Msg.toast("No network, save photos offline!");
      // }
      // // if(e.runtimeType == DioError){
      // //   print("e.runtimeType=DioError");
      // // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: new IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          iconSize: 28,
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,

        /// 1、TOP 导航部分
        title: Text('Upload Pictures', style: TextStyle(color: Colors.black)),
        brightness: Brightness.light,
      ),
      backgroundColor: Color(0xFFF0F2F5),
      body: Column(
        children: [
          Expanded(
            /// 2、[标题蓝底]基站目录名称 + 上传图片部分
            child: _buildContent(context),
          ),

          /// 3、底部递交按钮
          _bottomBuild(context),
        ],
      ),
    );
  }

  /// 3、底部递交按钮
  Widget _bottomBuild(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      // padding: EdgeInsets.fromLTRB(28, 12, 28, 38),
      alignment: Alignment.center,
      height: 75 + bottomPadding,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 14,
          ),
          _normalFlatButton(context)
        ],
      ),
    );
  }

  /// 递交审核按钮
  FlatButton _normalFlatButton(BuildContext context) {
    return FlatButton(
      onPressed: () {
        //print("approveStatus=" + '${widget.model.approveStatus}');
        // 20220404 adward 待审核状态允许继续递交
        // if (widget.model.approveStatus == 2) {
        //   Msg.toast("Please wait for approval");
        //   return;
        // }
        if (widget.dirThree.approveStatus == 3 || widget.dirThree.approveStatus == 4) {
          Msg.toast("Approved and cannot be modified");
          return;
        }
        /// 验证照片数量不能少于规定数量
        if ((widget.dirThree.uploadedNumber + widget.dirThree.uploadedFileUrls.length) < widget.dirThree.specifiedNumber) {
          Msg.toast("Upload at least " +
              //'${widget.model.uploadedNumber + widget.model.uploadedFileUrls.length}/'
              '${widget.dirThree.specifiedNumber}' +
              " Photos&Documents.");
          return;
        }
        // 20220404 adward
        var res = NetUtils.post(
            url: Api.SUBMIT_REVIEW,
            isMask: true,
            params: {
              'level': ConstInfo.SUBMIT_LEVEL_DIRTHREE,
              'id': this.widget.dirThree.bizKey
              //'comments': dialogTextController.text
            },
            throwError: true)
            .catchError((e) {
          Msg.toast("Error submit");
        });
        if (res != null) {
          this.widget.dirThree.approveStatus = 2;
          Msg.toast("Submit Success");
          setState(() {});
        }
        //_showDialog(context);
        return;
      },
      padding: EdgeInsets.fromLTRB(93, 14, 93, 14),
      // splashColor: Color(0xffFfffff),
      child: Text("Submit to approve"),
      textColor: Color(0xffFfffff),
      color:
          (widget.dirThree.approveStatus == 3 || widget.dirThree.approveStatus == 4) ? Colors.grey : Color(0xff4489F5),
      // highlightColor: Color(0xffF88B0A),
    );
  }

  /// 2、[标题蓝底]中间基站名称 + 上传图片部分
  Widget _buildContent(BuildContext context) {
    if (widget.dirThree.specifiedNumber < 0) {
      return SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            /// [标题蓝底]中间基站名称
            children: <Widget>[
              _buildBlueTitleContent(context),
              SizedBox(
                height: 10,
              ),

              /// to > tipview_chosse_view.dart
              /// 行： Upload at least + 弹出拍照图片按钮
              /// 上传的图片矩阵排列
              TipViewChosseImage(
                files: this.widget.dirThree.uploadedPicUrls,
                upload: this.upload,
                delete: this.delete,
                dirThree: this.widget.dirThree,
              ),
            ],
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            /// 中间基站名称
            children: <Widget>[
              _buildBlueTitleContent(context),
              SizedBox(
                height: 10,
              ),

              /// tipview_chosse_view.dart
              /// 行： Upload at least + 弹出拍照图片按钮
              /// 上传的图片矩阵排列
              TipViewChosseImage(
                files: this.widget.dirThree.uploadedPicUrls,
                upload: this.upload,
                delete: this.delete,
                dirThree: this.widget.dirThree,
              ),

              /// Comments + Sample pictures + Documents
              WidgetNodePanel(
                text: 'Comments',
                show: Column(
                  children: [
                    TextField(
                      controller: textController,
                      readOnly: true,
                      maxLines: 5,
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide()),
                      ),
                    )
                  ],
                ),
              ),
              WidgetNodePanel(
                text:
                    'Sample pictures（${this.widget.dirThree.examplePicUrls.length}）',
                show: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNodeTitle(),
                    SizedBox(
                      height: 10,
                    ),
                    TipviewExampleImageView(
                        context: context,
                        files: this.widget.dirThree.examplePicUrls),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              WidgetNodePanel(
                text:
                    'Documents（${this.widget.dirThree.uploadedFileUrls.length ?? 0}）',
                show: Column(
                  children: [
                    ..._buildAttachFiles(context),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildNodeTitle() => Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          Expanded(
            child: Text(
              widget.dirThree.exampleNote ?? "",
              style: TextStyle(color: BColors.black, fontSize: 12),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      );

  List<Widget> _buildAttachFiles(BuildContext context) {
    var theme = Theme.of(context);
    return this
        .widget
        .dirThree
        .uploadedFileUrls
        .map((mode) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Transform.rotate(
                  angle: pi / 4,
                  child: Icon(
                    Icons.attach_file,
                    size: 18,
                    color: theme.primaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                ),
                Text(mode)
              ]),
            ))
        .toList();
  }

  /// [标题蓝底]中间基站名称
  Widget _buildBlueTitleContent(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
      height: 90,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 4),
                child: Row(children: <Widget>[
                  Text("${widget.dirThree.siteId}",
                    style: const TextStyle(color: BColors.white, fontSize: 14),
                  ),
                  getApproveStatusText(widget.dirThree.approveStatus),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(top: 4),
                width: (MediaQuery.of(context).size.width - 100),
                child: Text("└ ${widget.dirThree.dirOneName}",
                    style: const TextStyle(color: BColors.white, fontSize: 14)),
              ),
              Container(
                width: (MediaQuery.of(context).size.width - 100),
                margin: EdgeInsets.only(top: 4),
                child: Text("    └ ${widget.dirThree.dirTwoName}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: BColors.white, fontSize: 14)),
              ),
              Container(
                width: (MediaQuery.of(context).size.width - 100),
                margin: EdgeInsets.only(top: 4),
                child: Row(children: <Widget>[
                  Text("        └ ${widget.dirThree.name}",
                    style: const TextStyle(color: BColors.white, fontSize: 14),
                  ),
                  //getApproveStatusText(widget.dirThree.approveStatus),
                ]),
              )
            ],
          )
        ],
      ),
    );
  }

  ///列表状态文字
  // Widget getApproveStatusText(int approveStatus) {
  //   var text = "";
  //   var textColor;
  //   if (approveStatus == 1) {
  //     text = "To be uploaded";
  //     textColor = BColors.color_979797;
  //   } else if (approveStatus == 2) {
  //     text = "To be approved";
  //     textColor = BColors.color_EE8F00;
  //   } else if (approveStatus == 3) {
  //     text = "Accepted";
  //     textColor = BColors.color_36CE27;
  //   } else if (approveStatus == 4) {
  //     text = "Rejected";
  //     textColor = BColors.color_EE3A2C;
  //   } else {
  //     text = "To be uploaded";
  //     textColor = BColors.color_979797;
  //   }
  //
  //   var textWidget =
  //       Text("    " + text, style: TextStyle(color: textColor, fontSize: 14.0));
  //   return textWidget;
  // }

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

  void delete(UploadedPicUrls file) async {
    //1. 离线存储直接删除
    if (file.id == null || file.id.isEmpty) {
      await OffineUtils.remove(file.filePath);
      setState(() {
        this.widget.dirThree.uploadedPicUrls.remove(file);
      });
      return;
    }
    //2. 线上接口删除
    FileUtils.delFile(this.widget.dirThree.bizKey, file.id).then((res) {
      if (res) {
        Msg.toast('delete success');
        setState(() {
          this.widget.dirThree.uploadedPicUrls.remove(file);

          /// 20220324: adward
          this.widget.dirThree.uploadedNumber -= 1;
        });
        return;
      }
    });
  }

  void upload(File file, BuildContext context) async {
    String filename = basename(file.path);
    try {
      var res = await FileUtils.upload(
          this.widget.dirThree.bizKey, filename, file.path);
      if (res.result == 'true') {
        var addRes = await FileUtils.addFile(
            this.widget.dirThree.bizKey, res.fileUpload.id);
        if (addRes) {
          Msg.toast('upload success');
          setState(() {
            this.widget.dirThree.uploadedPicUrls.add(
                  UploadedPicUrls(
                    fileName: filename,
                    fileUrl: file.path,
                    filePath: file.path,
                    id: res.fileUpload.id,
                  ),
                );

            /// 20220324: adward
            this.widget.dirThree.uploadedNumber += 1;
          });
        } else {
          FileUtils.delFile(this.widget.dirThree.bizKey, res.fileUpload.id)
              .then((res) {
            if (res) {
              print('delete success');
            }
          });
          throw new AssertionError("upload fail");
        }
      } else {
        FileUtils.delFile(this.widget.dirThree.bizKey, res.fileUpload.id)
            .then((res) {
          if (res) {
            print('delete success');
          }
        });
        throw new AssertionError("upload fail");
      }
    } catch (e) {
      Msg.toast('Saved to local successfully!');
      await OffineUtils.add(
          this.widget.dirThree.siteId,
          this.widget.dirThree.dirOneId,
          this.widget.dirThree.dirTwoId,
          this.widget.dirThree.bizKey,
          file.path,
          '');
      setState(() {
        this.widget.dirThree.uploadedPicUrls.add(
              UploadedPicUrls(
                fileName: filename,
                fileUrl: file.path,
                filePath: file.path,
              ),
            );
      });
    } finally {
      Navigator.pop(context);
    }

  }

  void _showDialog(widgetContext) {
    showCupertinoDialog(
      context: widgetContext,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Comments'),
          content: Card(
            elevation: 0.0,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: dialogTextController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide()),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('Commit'),
              onPressed: () async {
                // 20220404 adward 递交时去掉弹窗
                // print("comments=" + '${dialogTextController.text}');
                // if(dialogTextController.text == null || '${dialogTextController.text}'.trim() == ''){
                //   print("comments is empty");
                //   Msg.toast("Comments cannot be empty");
                //   return;
                // }
                // List<UploadedPicUrls> uploadSuccess = this
                //     .widget
                //     .model
                //     .uploadedPicUrls
                //     .where((element) => element.id != null)
                //     .toList();
                // bool isShwo = true;
                // showLoadingDialog(context);
                // var res = await NetUtils.post(
                //         url: Api.SUBMIT_REVIEW,
                //         isMask: true,
                //         params: {
                //           'level': ConstInfo.SUBMIT_LEVEL_DIRTHREE,
                //           'id': this.widget.model.bizKey,
                //           'comments': dialogTextController.text
                //         },
                //         throwError: true)
                //     .catchError((e) {
                //   if (isShwo) {
                //     Navigator.pop(context);
                //     isShwo = false;
                //   }
                // });
                // if (isShwo) {
                //   Navigator.pop(context);
                //   isShwo = false;
                // }
                // if (res != null) {
                //   Navigator.of(context).pop();
                //   this.widget.model.approveStatus = 2;
                //   Msg.toast("Submit Success");
                //   this.widget.model.comments = dialogTextController.text +
                //       "\t\n" +
                //       this.widget.model.comments;
                //   textController.text = this.widget.model.comments;
                //   setState(() {});
                // } else {
                //   Navigator.of(context).pop();
                // }
                // 20220404 adward 递交时去掉弹窗 END
              },
            ),
            CupertinoDialogAction(
              child: Text('Cancel'),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
