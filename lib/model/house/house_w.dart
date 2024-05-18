import 'dart:convert';

import 'package:project_view/model/house/house_info.dart';

class HouseWriteModel {
  /// 房屋交易类型
  final String houseTardeType;

  /// 房屋所在地区
  final String houseTerritory;

  /// 房屋地址编码
  final String houseAddrCode;

  /// 房屋详细地址
  final String houseAddr;

  /// 房屋价格
  final double housePrice;

  /// 房屋图片
  final String houseFile;

  /// 房屋信息
  final BaseHouseInfo houseInfo;

  const HouseWriteModel({
    required this.houseTardeType,
    required this.houseTerritory,
    required this.houseAddrCode,
    required this.houseAddr,
    required this.housePrice,
    required this.houseFile,
    required this.houseInfo,
  });

  factory HouseWriteModel.fromJson(Map<String, dynamic> json) {
    double? housePrice = double.tryParse(json['housePrice'].toString());
    if (housePrice == null || housePrice <= 0) {
      throw "价格不能太小";
    }
    return HouseWriteModel(
      houseTardeType: json['houseTardeType'],
      houseTerritory: json['houseTerritory'],
      houseAddrCode: json['houseAddrCode'],
      houseAddr: json['houseAddr'],
      housePrice: housePrice,
      houseFile: (json['houseFile'] ?? '').join(','),
      houseInfo: BaseHouseInfo.fromJson(json, json['houseTardeType']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'houseTardeType': houseTardeType,
      'houseTerritory': houseTerritory,
      'houseAddrCode': houseAddrCode,
      'houseAddr': houseAddr,
      'housePrice': housePrice,
      'houseFile': houseFile,
      'houseInfo': jsonEncode(houseInfo.toJson()),
    };
  }
}
