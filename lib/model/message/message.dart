import 'package:project_view/model/user/user.dart';

class MessageModel {
  final String message;
  final String type;
  final BaseUserModel? from;
  final int? to;
  final DateTime time;
  const MessageModel({
    required this.message,
    required this.type,
    this.from,
    this.to,
    required this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'],
      type: json['type'],
      from: json['from'] != null ? BaseUserModel.fromJson(json['from']) : null,
      to: json['to'],
      time: DateTime.parse(json['time']),
    );
  }
}
