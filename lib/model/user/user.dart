import 'dart:convert';

import 'package:project_view/model/user/user_extra_info.dart';

class BaseUserModel {
  final int id;
  final String nickName;
  final String? addrCode;
  final String? addr;
  final String? avatar;
  const BaseUserModel({
    required this.id,
    required this.nickName,
    required this.addrCode,
    required this.addr,
    required this.avatar,
  });

  factory BaseUserModel.fromJson(Map<String, dynamic> json) {
    return BaseUserModel(
      id: json['id'],
      nickName: json['nickName'],
      addrCode: json['addrCode'],
      addr: json['addr'],
      avatar: json['avatar'],
    );
  }
}

class UserModel extends BaseUserModel {
  final String userName;
  final String? emails;
  final String? phones;
  final String permission;
  final UserExtraInfoModel extraInfo;
  final DateTime createTime;
  final DateTime updateTime;
  String get sex => extraInfo.sex;
  String? get birthday => extraInfo.birthday;
  String? get favorite => extraInfo.favorite;
  String? get signature => extraInfo.signature;
  const UserModel({
    required super.id,
    required this.userName,
    required super.nickName,
    required this.emails,
    required this.phones,
    required super.addrCode,
    required super.addr,
    required super.avatar,
    required this.permission,
    required this.extraInfo,
    required this.createTime,
    required this.updateTime,
  });

  static const String permissionAdmin = 'admin';
  static const String permissionLogin = 'login';
  static const String permissionPublish = 'publish';
  static String addPermission(String value, String oldPermission) {
    if (oldPermission.contains(value)) {
      return value;
    }
    return oldPermission + value;
  }

  static String removePermission(String value, String oldPermission) =>
      oldPermission.replaceAll(value, '');

  List<String> get permissionList {
    List<String> list = [];
    if (isAdmin) {
      list.add(permissionAdmin);
    }
    if (canLogin) {
      list.add(permissionLogin);
    }
    if (canPublish) {
      list.add(permissionPublish);
    }
    return list;
  }

  UserModel copyWith({
    String? nickName,
    String? emails,
    String? phones,
    String? addrCode,
    String? addr,
    String? avatar,
    String? permission,
    String? sex,
    String? birthday,
    String? favorite,
    String? signature,
  }) {
    return UserModel(
      id: id,
      userName: userName,
      nickName: nickName ?? this.nickName,
      emails: emails ?? this.emails,
      phones: phones ?? this.phones,
      addrCode: addrCode ?? this.addrCode,
      addr: addr ?? this.addr,
      avatar: avatar ?? this.avatar,
      permission: permission ?? this.permission,
      extraInfo: UserExtraInfoModel(
        sex: sex ?? this.sex,
        birthday: birthday ?? this.birthday,
        favorite: favorite ?? this.favorite,
        signature: signature ?? this.signature,
      ),
      createTime: createTime,
      updateTime: updateTime,
    );
  }

  /// Check if the user has the permission to admin
  bool get isAdmin => permission.contains(permissionAdmin);

  /// Check if the user has the permission to login
  bool get canLogin => permission.contains(permissionLogin);

  /// Check if the user has the permission to create
  bool get canPublish => permission.contains(permissionPublish);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['userName'],
      nickName: json['nickName'],
      emails: json['emails'],
      phones: json['phones'],
      addrCode: json['addrCode'],
      addr: json['addr'],
      avatar: json['avatar'],
      permission: json['userPermission'],
      extraInfo:
          UserExtraInfoModel.fromJson(jsonDecode(json['extraInfo'] ?? '{}')),
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
    );
  }
}
