import 'dart:convert';

import 'package:project_view/model/communicate/communicate.dart';
import 'package:project_view/model/communicate/communicate_item.dart';
import 'package:project_view/model/message/message.dart';
import 'package:project_view/model/user/user.dart';

class MMessageMessage extends MessageModel {
  MMessageMessage({
    required super.time,
    required CommunicateItemModel super.data,
    super.from,
    super.to,
  }) : super(type: MessageModel.messageType);

  @override
  CommunicateItemModel get data => super.data;

  factory MMessageMessage.fromJson(Map<String, dynamic> json) {
    String data = json['data'];
    data = data.replaceAll(CommunicateModel.endText, '');
    return MMessageMessage(
      time: DateTime.parse(json['time']),
      data: CommunicateItemModel.fromJson(jsonDecode(data)),
      from: BaseUserModel.fromJson(json['from']),
      to: json['to'],
    );
  }
}
