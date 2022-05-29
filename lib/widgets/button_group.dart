import 'package:flutter/material.dart';
import 'package:flutterappdemo/resources/base_style.dart';
import 'package:flutterappdemo/utils/Spkey.dart';
import 'package:flutterappdemo/utils/adapt.dart';
import 'package:flutterappdemo/utils/event_bus.dart';

class ButtonGroup extends StatelessWidget {
  List<Button> children;
  BoxDecoration decoration;
  EdgeInsets padding;
  double buttonSpace;

  ButtonGroup({this.children, this.padding, this.buttonSpace, this.decoration});

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [];
    for (int i = 0; i < this.children.length; i++) {
      if (i > 0 && buttonSpace != null && i % 2 == 1) {
        _children.add(SizedBox(
          width: this.buttonSpace,
        ));
      }
      _children.add(Expanded(
        child: this.children[i],
      ));
    }
    return Container(
      padding: this.padding,
      child: Row(
        children: _children,
      ),
    );
  }
}

class Button extends StatefulWidget {
  Button(
    this.text, {
    this.color = Colors.white,
    this.isGradient = false,
    this.disabled = false,
    this.isLoading = false,
    this.endBackgroundColor,
    this.backgroundColor,
    this.isBorderRadius = true,
    this.bantouming = false,
    this.height,
    this.border,
    this.onTap,
    this.margin,
    this.fontWeight = FontWeight.w400,
  });

  EdgeInsets margin;
  FontWeight fontWeight;
  String text;

  //是否渐变
  bool isGradient;

  //是否禁用
  bool disabled;

  //是否加载中
  bool isLoading;

  //是否圆解
  bool isBorderRadius;

  //文本颜色
  Color color;

  //背景色
  Color backgroundColor;

  //渐变背景色
  Color endBackgroundColor;

  //边框
  Border border;
  double height;
  VoidCallback onTap;

  bool bantouming;

  @override
  _buttonStatus createState() => _buttonStatus();
}

class _buttonStatus extends State<Button> {
  bool dis = false;

  @override
  void dispose() {
    // TODO: implement dispose
    dis = true;
    super.dispose();
  }

  void _handleLoading() {
    setState(() {
      widget.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bus.on(Spkey.NetError, (arg) {
      if (!dis) {
        _handleLoading();
      }
    });

    BoxDecoration decoration;
    var borderRadius =
        widget.isBorderRadius ? BorderRadius.circular(Adapt.px(6)) : null;
    var textStyle = TextStyle(
      fontSize: Adapt.px(16),
      color: widget.disabled
          ? BColors.black9
          : (widget.color ?? BStyle.titleColor),
      fontWeight: widget.fontWeight,
      decoration: TextDecoration.none,
    );

    if (widget.disabled) {
      decoration = BoxDecoration(
        color: BColors.greyE,
        border: widget.border,
        borderRadius: borderRadius,
      );
    } else if (widget.isGradient) {
      decoration = BoxDecoration(
        color: widget.backgroundColor ?? BStyle.themeColor,
        borderRadius: borderRadius,
        border: widget.border,
        //   gradient: LinearGradient(colors: [BStyle.themeColor, BColors.orange]),
      );
    } else if (widget.bantouming) {
      decoration = BoxDecoration(
        color: widget.backgroundColor ?? BStyle.themeColor,
        borderRadius: borderRadius,
        border: widget.border,
        // gradient:
        // LinearGradient(colors: [Color(0x55ea5029), Color(0x55f39937)]),
      );
    } else {
      decoration = BoxDecoration(
        color: widget.backgroundColor ?? BStyle.themeColor,
        borderRadius: borderRadius,
        border: widget.border,
      );
    }
    return GestureDetector(
      onTap: (widget.isLoading || widget.disabled) ? null : widget.onTap,
      child: Container(
        margin: widget.margin,
        decoration: decoration,
        height: widget.height == null ? Adapt.px(50) : widget.height,
        alignment: Alignment.center,
        child: _buildBody(textStyle),
      ),
    );
  }

  Widget _buildBody(TextStyle textStyle) {
    Widget child = Text(
      widget.text,
      style: textStyle,
    );
    if (widget.isLoading) {
      child = SizedBox(
        width: Adapt.px(24),
        height: Adapt.px(24),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(BStyle.themeColor),
        ),
      );
    }
    return child;
  }
}
