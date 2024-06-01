import 'package:project_view/model/trade/trade.dart';

import 'message.dart';

class TMessage extends MessageModel {
  TMessage({
    required super.time,
    required TradeModel super.data,
  }) : super(type: MessageModel.noticeTradeType);

  @override
  TradeModel get data => super.data;

  factory TMessage.fromJson(Map<String, dynamic> json) {
    return TMessage(
      time: DateTime.parse(json['time']),
      data: TradeModel.fromJson(json['data']),
    );
  }
}
