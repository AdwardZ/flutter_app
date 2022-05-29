import 'package:flutter/material.dart';
import 'package:flutterappdemo/utils/adapt.dart';

class BStyle {
  //fontSize
  static const double fOverline = 10.0;
  static const double fCaption = 12.0;
  static const double fBody = 14.0;
  static const double fSubtitle = 16.0;
  static const double fTitle = 20.0;
  static const double fHeadline = 24.0;

  //padding && margin
  static double p0 = Adapt.px(0.0);
  static double p1 = Adapt.px(4.0);
  static double p2 = Adapt.px(8.0);
  static double p3 = Adapt.px(12.0);
  static double p4 = Adapt.px(16.0);
  static double p5 = Adapt.px(20.0);
  static double p6 = Adapt.px(24.0);
  static double p7 = Adapt.px(28.0);
  static double p8 = Adapt.px(32.0);
  static double p9 = Adapt.px(36.0);
  static double p10 = Adapt.px(40.0);
  static double p11 = Adapt.px(15.0);

  static double icoSize = p6;

  //帮助颜色
  static const Color titleColor = BColors.black;
  static const Color contentColor = BColors.black6;
  static const Color tipColor = BColors.black9;
  static const Color arrowRightColor = BColors.black9;

  static const Color bgColor = BColors.greyF1;
  static const Color borderColor = BColors.greyD;
  static const Color ButtonGrey = BColors.greyE;
  static const Color spliterColor = BColors.greyF8;
  static const Color towBodyColor = Color(0xFF8B8C90);

  static const Color themeColor = BColors.red;
}

//color
class BColors {
  //color
  static const Color black0 = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color black = Color(0xFF333333);
  static const Color black6 = Color(0xFF666666);
  static const Color black9 = Color(0xFF3A3B40);

  static const Color grey = Color(0xFFCCCCCC);
  static const Color greyD = Color(0xFFDDDDDD);
  static const Color greyE = Color(0xFFEEEEEE);
  static const Color greyF1 = Color(0xFFF1F3F5);
  static const Color greyF8 = Color(0xFFF8F8F8);

  static const Color red = Color(0xffff6046);
  static const Color blue = Color(0xFF3E89E1);
  static const Color lightGreen = Color(0xFF41B828);
  static const Color green = Color(0xFF21aa44);
  static const Color brightGreen = Color(0xFF51BA3B);
  static const Color yellow = Color(0xFFFFDFA0);
  static const Color darkYellow = Color(0xFFEEAE00);
  static const Color lightOrange = Color.fromRGBO(243, 153, 55, 0.2);
  static const Color orange = Color(0xFFf39937);

  static const Color bulu2 = Color(0XFF3E89E1);

  static const Color badgeBgColor = Color(0xFF57585C);
  static const Color bgMyButton = Color(0xffFF735C);

  static const Color color_4489F5 = Color(0xff4489F5);
  static const Color color_EE8F00 = Color(0xffEE8F00);
  static const Color color_EE3A2C = Color(0xffEE3A2C);
  static const Color color_36CE27 = Color(0xff36CE27);
  static const Color color_F0F2F5 = Color(0xffF0F2F5);
  static const Color color_979797 = Color(0xff979797);
  // 20220522: adward
  static const Color color_FF8C00 = Color(0xffFF8C00);
  static const Color color_0000FF = Color(0xff0000FF);
  static const Color color_FF6EC7 = Color(0xffFF6EC7);
  static const Color color_006400 = Color(0xff006400);
  static const Color color_FF0000 = Color(0xffFF0000);

}
