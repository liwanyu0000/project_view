import 'dart:convert';

import 'package:project_view/model/user/user.dart';
import 'package:project_view/utils/utils.dart';

class TradeModel {
  int id;
  BaseUserModel seller;
  BaseUserModel buyer;
  int houseId;
  String tradeType;
  String status;
  DateTime createdAt;
  DateTime? finishAt;

  static const String tradeStatusStart = 'start';
  static const String tradeStatusFinish = 'finish';
  static const String tradeStatusCancel = 'cancel';
  static const String tradeStatusPass = 'pass';

  TradeModel({
    required this.id,
    required this.seller,
    required this.buyer,
    required this.houseId,
    required this.tradeType,
    required this.status,
    required this.createdAt,
    required this.finishAt,
  });

  String setState(String status) {
    this.status = status;
    finishAt = DateTime.now();
    return info;
  }

  String get info => jsonEncode({
        'tradeType': tradeType,
        'status': status,
        'finishAt': stringify(finishAt),
      });
  factory TradeModel.fromJson(Map<String, dynamic> json) {
    final seller = BaseUserModel.fromJson(json['seller']);
    final buyer = BaseUserModel.fromJson(json['buyer']);
    final info = jsonDecode(json['info']);
    return TradeModel(
      id: json['id'],
      seller: seller,
      buyer: buyer,
      houseId: json['houseId'],
      tradeType: info['tradeType'],
      status: info['status'],
      createdAt: DateTime.parse(json['createTime']),
      finishAt: toDateTime(info['finishAt']),
    );
  }
}
