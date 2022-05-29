import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutterappdemo/utils/LocationUtil.dart';
import 'package:flutterappdemo/utils/datetime_utils.dart';
import 'package:flutterappdemo/utils/file_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';


//import 'package:image_picker_saver/image_picker_saver.dart' hide ImageSource;
import 'dart:ui' as ui;

import '../main.dart';
import 'logger.dart';

class PhotoUtils {
  static takePhoto(String siteId, String threeDir) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    String path = await addWirte(image.path, siteId, threeDir);
    File file = File(path);
    return file;
  }

  static takeAlbum(String other) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
//    String path = await addWirte(image.path, other);
    File file = File(image.path);
    return file;
  }

  //读出图片流
  static Future<ui.Image> loadImage(var path, bool isUrl) async {
    File file = new File(path);
    Codec codec = await ui.instantiateImageCodec(file.readAsBytesSync());
    FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  //返回ui.Image
  static Future<ui.Image> getAssetImage(String asset,{width,height}) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),targetWidth:width,targetHeight:height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  // 给图片加上水印 返回打了水印的文件地址
  static Future<String> addWirte(String path, String siteId, String threeDir) async {
    var pictureRecorder = new ui.PictureRecorder(); // 图片记录仪
    var canvas = new Canvas(pictureRecorder); //canvas接受一个图片记录仪
    var images = await loadImage(path, false); // 使用方法获取Unit8List格式的图片
    print(images);

    //print("width=" + '${images.width}' + ", width=" + '${images.height}');

    // 绘制图片
    Paint _linePaint = new Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 30.0;
    canvas.drawImage(images, Offset(0, 0), _linePaint); // 直接画图
    canvas.save();

    // 绘制公司LOG图片
    ui.Image imagesLog = await getAssetImage('assets/images/log.png'); // 使用方法获取ui.Image格式的图片
    Paint _linePaintLog = new Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..isAntiAlias = true//抗锯齿
      ..strokeCap = StrokeCap.round//线条末端的处理方式
      ..strokeWidth = 20.0;
    canvas.drawImage(imagesLog, Offset(50, 50), _linePaintLog); // 直接画图
    canvas.save();

    // 在图片上部绘制半透明灰色蒙版
    // var paintRect = Paint()
    //   ..isAntiAlias = true
    //   ..strokeWidth = 1.0
    //   ..style = PaintingStyle.fill
    //   ..color = Colors.white30
    //   ..invertColors = false;
    // double radius = images.width / 4;
    // Rect rect = Rect.fromLTRB(0.0, 0, images.width.toDouble(),
    //     (images.width / 30 < 30 ? 30 : images.width / 30) * 6);
    // canvas.drawRect(rect, paintRect);
    // canvas.save();

    // 绘制文字
    var text = "";
    //var dateTime = DateTimeUtils.format(DateTime.now(), format: 'yyyy-MM-dd HH:mm');
    var dateTime = DateTimeUtils.format(DateTime.now(), format: 'dd MMM yyyy HH:mm:ss');
    var gps = "";
    // longitude: 经度    latitude: 纬度
    if (Platform.isAndroid) {
      print("is Android");
      var res = await AndroidApi.invokeMethod('getDate');
      //print(res.runtimeType);
      if(res != null && res != ""){
        print("Android.res=" + res);
        String ll = res.toString();
        List<String> locaList = ll.split(",");
        //print("length1=" + '${locaList.length}');
        if(locaList.length > 1){
          String longitude = locaList.elementAt(0);
          String latitude = locaList.elementAt(1);
          //print("longitude=" + longitude);
          //print("latitude=" + latitude);
          gps = latitude + "N " + longitude + "E";
        } else {
          print("Android.res.length=" + '${locaList.length}');
          gps = gps + res;
        }
      } else {
        print("Android.res is null or empty!");
        gps = gps + res ?? "";
      }
    } else {
      print("is not Android");
      var localtion = LocaltionUtil();
      Position locationData = await localtion.getLocaltion();
      if (locationData != null) {
        gps = gps + locationData.longitude.toString() + "N " + locationData.latitude.toString() + "E";
      }
    }
    text = gps       + "\n"
         + siteId    + " " + threeDir + "\n"
         + dateTime  + "\n";

    // 画日期等文字
    ui.ParagraphBuilder pb = ui.ParagraphBuilder(
      ui.ParagraphStyle(
          textAlign: TextAlign.right,
          fontFamily: "Arial",
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.normal,
          height: 2,
          fontSize: images.width / 30 < 30 ? 30 : images.width / 30),
    );
    pb.pushStyle(ui.TextStyle(color: Colors.white));
    pb.addText(text);
    // 设置文本的宽度约束
    ParagraphConstraints pc = ui.ParagraphConstraints(width: images.width.toDouble());
    ui.Paragraph paragraph = pb.build()..layout(pc);
    //
    canvas.drawParagraph(paragraph, Offset(-100, (images.height.toDouble() - 700)));

    // 画公司LOG等
    // var xinhuax = '华信邮电    \nHUAXINGPT    ';
    // ui.ParagraphBuilder pb1 = ui.ParagraphBuilder(
    //   ui.ParagraphStyle(
    //       textAlign: TextAlign.right,
    //       fontWeight: FontWeight.w900,
    //       fontStyle: FontStyle.normal,
    //       height: 2,
    //       fontSize: images.width / 40 < 30 ? 30 : images.width / 40),
    // );
    // pb1.pushStyle(ui.TextStyle(color: Colors.black));
    // pb1.addText(xinhuax);
    // // 设置文本的宽度约束
    // ParagraphConstraints pc1 = ui.ParagraphConstraints(width: images.width.toDouble());
    // ui.Paragraph paragraph1 = pb1.build()..layout(pc1);
    // canvas.drawParagraph(paragraph1, Offset(0, 0));



    //下面的代码是生成图片的关键代码，以上绘制文字和圆圈的代码可以忽略不计
    ui.Image picture = await pictureRecorder
        .endRecording()
        .toImage(images.width, images.height); //设置生成图片的宽和高
    //print(">>>>>>>>>>>>>>>>>>>>1");
    ByteData pngImageBytes = await picture.toByteData(format: ui.ImageByteFormat.png);
    //print(">>>>>>>>>>>>>>>>>>>>2");
    //iso android 用不同的库
    String result = "";
    result = await ImageGallerySaver.saveImage(
      pngImageBytes.buffer.asUint8List(),
    );
    //print(">>>>>>>>>>>>>>>>>>>>>>>>result=" + result);
    result = result.replaceAll("file://", "");
    //print(">>>>>>>>>>>>>>>>>>>>replaceAll=" + result);
    return result;
  }
}
