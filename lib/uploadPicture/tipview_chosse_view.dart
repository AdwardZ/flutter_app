import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterappdemo/model/home_res_model.dart';
import 'package:flutterappdemo/resources/base_style.dart';
import 'package:flutterappdemo/uploadPicture/choose_image_screen.dart';
import 'package:flutterappdemo/utils/file_utils.dart';
import 'package:flutterappdemo/utils/photo_utils.dart';
import 'package:flutterappdemo/utils/offline_utils.dart';
import 'package:flutterappdemo/utils/util.dart';
import 'package:toggle_rotate/toggle_rotate.dart';

typedef UploadCallback = void Function(File file, BuildContext viewContext);
typedef DeleteCallback = void Function(UploadedPicUrls file);

class TipViewChosseImage extends StatefulWidget {
  List<UploadedPicUrls> files;
  UploadCallback upload;
  DeleteCallback delete;
  DirThree dirThree;
  BuildContext viewContext;

  TipViewChosseImage(
      {Key key,
      this.delete,
      this.files,
      this.upload,
      this.dirThree,
      this.viewContext})
      : super(key: key);

  @override
  _TipViewChosseImageState createState() => _TipViewChosseImageState();
}

class _TipViewChosseImageState extends State<TipViewChosseImage> {
  bool isFirst = false;

  @override
  Widget build(BuildContext context) {
    if(widget.dirThree.specifiedNumber < 0){
      return Container(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            /// 行： Upload at least + 弹出拍照图片按钮
            _buildNodeTitle(context),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),

            /// 行： Upload at least + 弹出拍照图片按钮
            _buildNodeTitle(context),
            SizedBox(
              height: 10,
            ),
            Wrap(
              /// 上传的图片矩阵排列
              children: _buildImages(context),
            ),
            SizedBox(
              height: this.widget.files.isEmpty ? 0 : 10,
            ),
          ],
        ),
      );
    }
  }

  /// 行： Upload at least
  Widget _buildNodeTitle(BuildContext context) => Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            // child: Circle(
            //   color: themeColor,
            //   radius: 5,
            // ),
          ),
          Expanded(
            child: Text(
              (widget.dirThree.specifiedNumber < 0 || widget.dirThree.type == 2) ? 'You don\'t need to upload any photos!' : 'Upload at least '+'${widget.dirThree.specifiedNumber}' + (widget.dirThree.type == 1 ? ' Photos' : ' Photos&Documents'),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: BColors.black,
                  fontSize: 12),
            ),
          ),
          /// 点击上传图片图标
          _buildCodeButton(context)
        ],
      );

  /// 点击上传图片图标
  Widget _buildCodeButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: ToggleRotate(
            rad: 0,
            durationMs: 0,
            child: Icon(
              Icons.image,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {
              /// 20220326: adward
              if(widget.dirThree.specifiedNumber < 0 || widget.dirThree.type == 2){
                Msg.toast("You don\'t need to upload any photos!");
              } else {
                /// 弹出拍照图片
                _modelBottomSheet();
              }
            }),
      );

  /// 弹出拍照图片
  _modelBottomSheet() async {
    if (widget.dirThree.approveStatus == 3 || widget.dirThree.approveStatus == 4) {
      Msg.toast("Approval in progress, unable to upload!");
      return;
    }
    // 底部
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    var result = await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        context: context,
        builder: (context1) {
          return Container(
            height: 210 + bottomPadding, //配置底部弹出框高度
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('Take a Picture', textAlign: TextAlign.center),
                  onTap: () async {
                    Navigator.pop(context1);
                    showLoadingDialog(context);
                    var image = await PhotoUtils.takePhoto(widget.dirThree.siteId, widget.dirThree.name);
                    if (image != null) {
                      if (this.widget.upload != null) {
                        this.widget.upload(image, context);
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                Divider(),
                ListTile(
                  title:
                      Text('Select from the File', textAlign: TextAlign.center),
                  onTap: () async {
                    Navigator.pop(context1);
                    showLoadingDialog(context);
                    var image = await PhotoUtils.takeAlbum(widget.dirThree.siteId);
                    if (image != null) {
                      if (this.widget.upload != null) {
                        this.widget.upload(image, context);
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                Container(
                  color: Color(0xFFF0F2F5),
                  height: 10,
                ),
                ListTile(
                  title: Text('Cancel', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  /// 上传的图片矩阵排列
  List<Widget> _buildImages(BuildContext context) {
    if (this.widget.files == null || this.widget.files.any((x) => x.filePath == null)) {
      return [];
    }
    if (this.widget.files.length == 0) {
      return [
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        Text(
          (widget.dirThree.type == 2 ? 'Only document can be upload on pc.' : 'Note: No photos'),
          style: TextStyle(color: BColors.black, fontSize: 12),
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 30,
        ),
      ];
    }
    return this
        .widget
        .files
        .map((file) => Stack(
              children: <Widget>[
                Container(
                  width: 74,
                  height: 80,
                  child: Stack(
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 16),
                          width: 74,
                          height: 74,
                          color: Colors.grey.withAlpha(88),
                          child: GestureDetector(
                            onLongPressStart: (v) {
                              setState(() {
                                isFirst = true;
                              });
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        new PhotoViewSimpleScreen(
                                          backgroundDecoration: BoxDecoration(
                                              color: Colors.black),
                                          imageProvider: file.filePath
                                                  .startsWith('http')
                                              ? Image.network(file.filePath)
                                                  .image
                                              : Image.file(File(file.filePath))
                                                  .image,
                                          heroTag: 'simple',
                                        )),
                              );
                            },
                            child: file.filePath.startsWith('http')
                                ? Image.network(file.filePath)
                                : Image.file(File(file.filePath)),
                          )),
                      isFirst
                          ? Container(
                              margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
                              height: 24,
                              width: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              // color: Color.fromARGB(100, 100, 100, 0),
                              child: IconButton(
                                iconSize: 20,
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.close),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    isFirst = false;
                                  });
                                  Msg.confirm(context, 'confirm delete?', () {
                                    this.widget.delete(file);
                                  });
                                },
                              ))
                          : SizedBox(),
                      Positioned(
                        bottom: 0,
                        left: 10,
                        child:
                            !file.filePath.startsWith('http') && file.id == null
                                ? Center(
                                    child: Text(
                                      'no upload',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  )
                                : SizedBox(),
                      )
                    ],
                  ),
                ),
              ],
            ))
        .toList();
  }
}
