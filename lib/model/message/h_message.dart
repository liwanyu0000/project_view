import 'package:project_view/model/house/house.dart';
import 'package:project_view/model/message/message.dart';

class HMessageMessage extends MessageModel {
  HMessageMessage({
    required super.time,
    required HouseModel super.data,
  }) : super(type: MessageModel.noticeHouseType);

  @override
  HouseModel get data => super.data;

  factory HMessageMessage.fromJson(Map<String, dynamic> json) {
    return HMessageMessage(
      time: DateTime.parse(json['time']),
      data: HouseModel.fromJson(json['data']),
    );
  }
}
