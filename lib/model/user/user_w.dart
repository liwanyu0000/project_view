import 'dart:convert';

import 'package:project_view/model/user/user_extra_info.dart';

class UserWriteModle {
  final String nickname;
  final String? emails;
  final String? phones;
  final String? addrCode;
  final String? addr;
  final String? avatar;
  final UserExtraInfoModel? extraInfo;

  const UserWriteModle({
    required this.nickname,
    required this.emails,
    required this.phones,
    required this.addrCode,
    required this.addr,
    required this.avatar,
    required this.extraInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'nickName': nickname,
      'emails': emails,
      'phones': phones,
      'addrCode': addrCode,
      'addr': addr,
      'avatar': avatar,
      'extraInfo': jsonEncode(extraInfo?.toJson()),
    };
  }

  factory UserWriteModle.fromJson(Map<String, dynamic> json) {
    return UserWriteModle(
      nickname: json['nickName'],
      emails: json['emails'],
      phones: json['phones'],
      addrCode: json['addrCode'],
      addr: json['addr'],
      avatar: json['avatar'],
      extraInfo: UserExtraInfoModel.fromJson(json),
    );
  }
}
