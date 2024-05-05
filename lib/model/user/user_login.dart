import 'user.dart';

class UserLoginModel extends UserModel {
  String token;
  UserLoginModel({
    required super.id,
    required super.username,
    required super.nickname,
    required super.email,
    required super.phone,
    required super.addr,
    required super.avatar,
    required super.role,
    required super.permission,
    required super.createTime,
    required super.updateTime,
    required this.token,
  });

  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    return UserLoginModel(
      id: json['id'],
      username: json['userName'],
      nickname: json['nickName'],
      email: json['email'],
      phone: json['phone'],
      addr: json['addr'],
      role: json['userRole'],
      avatar: json['avatar'],
      permission: json['userPermission'],
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
      token: json['token'],
    );
  }
}
