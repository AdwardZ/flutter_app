import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'adapt.dart';

class PhotoOutView extends StatelessWidget {
  PhotoOutView({Key key, this.onClick, this.imagePath, this.isEdit = true})
      : super(key: key);

  final VoidCallback onClick;
  final String imagePath;

  //是否允许图片删除
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Adapt.px(88),
      width: Adapt.px(87),
      child: Stack(
        children: <Widget>[
          Positioned(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: "assets/images/add_photo.png" == imagePath
                  ? Image(
                      width: Adapt.px(81),
                      height: Adapt.px(88),
                      image: AssetImage("assets/images/add_photo.png"))
                  : (!imagePath.contains("http")
                      ? Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          width: Adapt.px(87),
                          height: Adapt.px(88),
                        )
                      : Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          width: Adapt.px(87),
                          height: Adapt.px(88),
                        )),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            width: Adapt.px(20),
            height: Adapt.px(20),
            child: Container(
              child: Offstage(
                offstage:
                    ("assets/images/add_photo.png" == imagePath || !isEdit),
                child: GestureDetector(
                  child: Image(
                    image: AssetImage("assets/images/ic_close.png"),
                    width: Adapt.px(20),
                    height: Adapt.px(20),
                  ),
                  onTap: () {
                    onClick();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
