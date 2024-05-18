import 'package:project_view/model/message/message.dart';

class NotifyModel {
  final String host;
  final int? port;
  final String? pwd;
  final String channel;
  final List<MessageModel>? data;
  const NotifyModel({
    required this.host,
    this.port,
    required this.channel,
    this.pwd,
    this.data,
  });
  factory NotifyModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return NotifyModel(
      host: json['host'],
      port: json['port'],
      channel: json['channel'],
      pwd: json['pwd'],
      data: json['data'] != null
          ? List<MessageModel>.from(
              json['data'].map((x) => MessageModel.fromJson(x)))
          : null,
    );
  }
}
