import 'package:flutterappdemo/utils/util.dart';

class ValidateUtils {
  static String password(String value) {
    if (value.isEmpty) return "请输入您的密码";
    if (!Util.isPassword(value)) return "";
    return null;
  }

  static String phone(String value) {
    if (value.isEmpty) return "请输入您的手机号码";
    if (!Util.isPhone(value.trim())) return "请输入正确手机号";
    return null;
  }

  static String code(String value) {
    if (value.isEmpty) return "请输入您的验证码";
    return null;
  }
}
