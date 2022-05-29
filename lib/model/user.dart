import 'package:fish_redux/fish_redux.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String id;
  String name;
  String password;
  String token;

  String userName;
  String userType;

  User({this.id, this.name, this.password, this.token, this.userName, this.userType});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

//  @override
//  String toString() {
//    return 'User{id: $id, managerName: $managerName, fullName: $fullName, cityName: $cityName, provinceName: $provinceName, areaName: $areaName, idCardNo:$idCardNo, score: $score, levelName: $levelName, password: $password, avatar: $avatar, loginId: $loginId, sex: $sex, age: $age, area: $area, province: $province, city: $city, status: $status, mobile: $mobile, token: $token,userType:$userType}';
//  }
//
//  @override
//  User clone() {
//    return User()
//      ..id = id
//      ..fullName = fullName
//      ..idCardNo = idCardNo
//      ..password = password
//      ..levelName = levelName
//      ..score = score
//      ..avatar = avatar
//      ..loginId = loginId
//      ..sex = sex
//      ..age = age
//      ..area = area
//      ..areaName = areaName
//      ..province = province
//      ..provinceName = provinceName
//      ..city = city
//      ..cityName = cityName
//      ..status = status
//      ..mobile = mobile
//      ..token = token
//      ..birthday = birthday
//      ..managerName = managerName
//      ..stores = stores
//      ..userType = userType
//      ..email = email;
//  }
}
