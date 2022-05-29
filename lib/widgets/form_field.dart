import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterappdemo/resources/base_style.dart';
import 'package:flutterappdemo/utils/adapt.dart';

TextFormField createTextFormField({
  String labelText,
  TextEditingController controller,
  FocusNode focusNode,
  IconData iconData,
  FormFieldValidator<String> validator,
  bool autovalidate = false,
  bool obscureText = false,
  int maxLength = 100000,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextFormField(
    controller: controller,
    focusNode: focusNode,
    keyboardType: keyboardType,
    autovalidate: autovalidate,
    validator: validator,
    maxLength: maxLength,
//    enableInteractiveSelection: false,
    style: TextStyle(
      color: Colors.white,
      fontSize: BStyle.fBody,
    ),
    obscureText: obscureText,
    decoration: InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none), //
      labelText: labelText,
      labelStyle: TextStyle(color: Color(0xFFDDDDDD)),
      counterText: '',
    ),
    onEditingComplete: () {
      if (focusNode != null) {
        focusNode.nextFocus();
      }
    },
  );
}

TextFormField createTextFormFieldPassWord({
  String labelText,
  TextEditingController controller,
  FocusNode focusNode,
  IconData iconData,
  IconData iconData2,
  int maxLength = 8,
  FormFieldValidator<String> validator,
  bool autovalidate = false,
  bool obscureText = false,
  VoidCallback onClick,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextFormField(
    controller: controller,
    focusNode: focusNode,
    keyboardType: keyboardType,
    autovalidate: autovalidate,
    validator: validator,
    maxLength: maxLength,
//    enableInteractiveSelection: false,
    style: TextStyle(
      color: BStyle.titleColor,
      fontSize: BStyle.fBody,
    ),
    obscureText: obscureText,
    decoration: InputDecoration(
      labelText: labelText,
      icon: Icon(
        iconData,
        color: BStyle.contentColor,
        size: Adapt.px(BStyle.icoSize),
      ),
      suffix: GestureDetector(
        onTap: () {
          onClick();
        },
        child: Icon(
          iconData2,
          color: BStyle.contentColor,
          size: Adapt.px(BStyle.icoSize),
        ),
      ),
    ),
    onEditingComplete: () {
      if (focusNode != null) {
        focusNode.nextFocus();
      }
    },
  );
}
