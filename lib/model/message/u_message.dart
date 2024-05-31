import 'package:project_view/model/message/message.dart';
import 'package:project_view/model/user/user.dart';

class UMessageMessage extends MessageModel {
  UMessageMessage({
    required super.time,
    required UserModel super.data,
  }) : super(type: MessageModel.noticeUserType);

  @override
  UserModel get data => super.data;

  factory UMessageMessage.fromJson(Map<String, dynamic> json) {
    return UMessageMessage(
      time: DateTime.parse(json['time']),
      data: UserModel.fromJson(json['data']),
    );
  }
}
