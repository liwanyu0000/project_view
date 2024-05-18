import 'dart:convert';

import 'package:project_view/model/communicate/communicate.dart';

class CommunicateItemModel {
  final int from;
  final String text;
  final DateTime time;
  const CommunicateItemModel(
      {required this.from, required this.text, required this.time});

  factory CommunicateItemModel.fromJson(Map<String, dynamic> json) {
    return CommunicateItemModel(
      from: json['from'],
      text: json['text'],
      time: DateTime.parse(json['time']),
    );
  }

  factory CommunicateItemModel.fromStr(String item) {
    Map<String, dynamic> json = jsonDecode(item);
    return CommunicateItemModel.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'text': text,
      'time': time.toIso8601String(),
    };
  }

  String toStr() {
    return '${jsonEncode(toJson())}${CommunicateModel.endText}';
  }
}
