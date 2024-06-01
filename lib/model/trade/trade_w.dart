import 'dart:convert';

import 'package:project_view/model/trade/trade.dart';

class TradeWriteModel {
  int sellerId;
  int buyerId;
  int houseId;
  String tradeType;
  String status;
  TradeWriteModel({
    required this.sellerId,
    required this.buyerId,
    required this.houseId,
    required this.tradeType,
  }) : status = TradeModel.tradeStatusStart;

  String get info => jsonEncode({
        'tradeType': tradeType,
        'status': status,
      });

  Map<String, dynamic> toJson() => {
        'sellerId': sellerId,
        'buyerId': buyerId,
        'houseId': houseId,
        'info': info,
      };
}
