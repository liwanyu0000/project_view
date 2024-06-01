import 'package:project_view/model/message/h_message.dart';
import 'package:project_view/model/message/m_message.dart';
import 'package:project_view/model/message/t_message.dart';
import 'package:project_view/model/message/u_message.dart';
import 'package:project_view/model/user/user.dart';

class MessageModel {
  final String type;
  final DateTime time;
  final dynamic data;
  final BaseUserModel? from;
  final int? to;
  const MessageModel({
    required this.type,
    required this.data,
    required this.time,
    this.from,
    this.to,
  });

  static const String messageType = "MESSAGE";
  static const String noticeHouseType = "NOTICE_HOUSE";
  static const String noticeUserType = "NOTICE_USER";
  static const String noticeTradeType = "NOTICE_TRADE";

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    String type = json['type'];
    switch (type) {
      case messageType:
        return MMessageMessage.fromJson(json);
      case noticeHouseType:
        return HMessageMessage.fromJson(json);
      case noticeUserType:
        return UMessageMessage.fromJson(json);
      case noticeTradeType:
        return TMessage.fromJson(json);
      default:
        throw 'no type found in json';
    }
  }
}
