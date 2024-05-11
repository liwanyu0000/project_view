import 'dart:convert';

import 'user.dart';
import 'user_extra_info.dart';

class UserLoginModel extends UserModel {
  final String token;
  const UserLoginModel({
    required super.id,
    required super.userName,
    required super.nickName,
    required super.emails,
    required super.phones,
    required super.addr,
    required super.avatar,
    required super.permission,
    required super.createTime,
    required super.updateTime,
    required super.addrCode,
    required super.extraInfo,
    required this.token,
  });

  @override
  UserLoginModel copyWith({
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
    return UserLoginModel(
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
      token: token,
    );
  }

  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    return UserLoginModel(
      id: json['id'],
      userName: json['userName'],
      nickName: json['nickName'],
      emails: json['emails'],
      phones: json['phones'],
      addr: json['addr'],
      avatar: json['avatar'],
      permission: json['userPermission'],
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
      token: json['token'],
      addrCode: json['addrCode'],
      extraInfo:
          UserExtraInfoModel.fromJson(jsonDecode(json['extraInfo'] ?? '{}')),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickName': nickName,
      'emails': emails,
      'phones': phones,
      'addrCode': addrCode,
      'addr': addr,
      'sex': sex,
      'birthday': birthday,
      'favorite': favorite,
      'signature': signature,
    };
  }
}
