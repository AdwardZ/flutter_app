import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterappdemo/model/home_res_model.dart';

import 'choose_image_screen.dart';

class TipviewExampleImageView extends StatelessWidget {
  List<ExamplePicUrls> files;
  BuildContext context;

  TipviewExampleImageView(
      {Key key, BuildContext context, List<ExamplePicUrls> files})
      : super(key: key) {
    this.context = context;
    this.files = files;
  }

  @override
  Widget build(BuildContext context) {
    return _loadFromAssets(context);
  }

  Widget _loadFromAssets(BuildContext context) {
    if (this.files.any((x) => x.filePath == null)) {
      return Row();
    }
    return Wrap(
      textDirection: TextDirection.ltr,
      children: this.files.map<Widget>((file) {
        return Stack(
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
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new PhotoViewSimpleScreen(
                                      backgroundDecoration:
                                          BoxDecoration(color: Colors.black),
                                      imageProvider: file.filePath
                                              .startsWith('http')
                                          ? Image.network(file.filePath).image
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
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
