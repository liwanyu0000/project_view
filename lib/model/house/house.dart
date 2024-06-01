import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_view/model/house/house_info.dart';
import 'package:project_view/model/trade/trade_w.dart';
import 'package:project_view/model/user/user.dart';

class StatusModel {
  final String label;
  final Color color;
  const StatusModel({required this.label, required this.color});
  factory StatusModel.fromString(String type) {
    switch (type) {
      case HouseModel.houseStatusAudit:
        return const StatusModel(label: '审核中', color: Colors.orange);
      case HouseModel.houseStatusNotPass:
        return const StatusModel(label: '未过审', color: Colors.red);
      case HouseModel.houseStatusPublish:
        return const StatusModel(label: '已发布', color: Colors.green);
      case HouseModel.houseStatusComplete:
        return const StatusModel(label: '已完成', color: Colors.blue);
      case HouseModel.houseStatusOff:
        return const StatusModel(label: '已取消', color: Colors.grey);
      default:
        throw '未知状态类型';
    }
  }
}

class HouseModel {
  // 房屋交易类型
  // 买房
  static const String sellHouse = 'sell';
  // 租房
  static const String rentHouse = 'rent';
  // 房屋状态
  /// 审核中
  static const String houseStatusAudit = "audit";

  /// 未过审
  static const String houseStatusNotPass = "not_pass";

  /// 已发布
  static const String houseStatusPublish = "publish";

  /// 已完成交易
  static const String houseStatusComplete = "complete";

  /// 用户已取消
  static const String houseStatusOff = "user_off";

  // 操作码
  /// 编辑（修改）
  static const String houseOperateEdit = "edit";

  /// 删除
  static const String houseOperateDelete = "delete";

  /// 详情
  static const String houseOperateDetail = "detail";

  /// 联系
  static const String houseOperateContact = "contact";

  /// 发起交易
  static const String houseOperateTrade = "trade";

  /// 记录
  static const String houseOperateRecord = "record";

  /// 编辑（新）
  static const String houseOperateNewEdit = "new_edit";

  /// 审核
  /// 仅管理员可见
  static const String houseOperateReview = "review";

  /// 房屋ID
  final int id;

  /// 房屋交易类型
  final String houseTardeType;

  /// 房屋所在地区
  final String houseTerritory;

  /// 房屋地址编码
  final String houseAddrCode;

  /// 房屋详细地址
  final String houseAddr;

  /// 房屋信息
  final BaseHouseInfo houseInfo;

  /// 房屋价格
  final double housePrice;

  /// 房屋图片
  final String houseFile;

  /// 房屋状态
  final String houseState;

  /// 房屋所有者
  final BaseUserModel houseOwner;

  /// 创建时间
  final DateTime createTime;

  /// 更新时间
  final DateTime updateTime;

  String get showTardetext => houseTardeType == sellHouse ? '联系卖家' : '联系房东';

  List<String> get houseFileList => houseFile
      .split(RegExp('[ ]*,[ ]*'))
      .where((element) => element.isNotEmpty)
      .toList();

  StatusModel get status => StatusModel.fromString(houseState);

  String get houseType => houseTardeType == sellHouse ? '出售' : '出租';

  String get housePriceStr => houseTardeType == sellHouse
      ? '￥${housePrice.toStringAsFixed(0)}/平米'
      : '￥${housePrice.toStringAsFixed(0)}/月';

  const HouseModel({
    required this.id,
    required this.houseTardeType,
    required this.houseTerritory,
    required this.houseAddrCode,
    required this.houseAddr,
    required this.houseInfo,
    required this.housePrice,
    required this.houseFile,
    required this.houseState,
    required this.houseOwner,
    required this.createTime,
    required this.updateTime,
  });

  factory HouseModel.fromJson(Map<String, dynamic> json) {
    final houseInfo = BaseHouseInfo.fromJson(
        jsonDecode(json['houseInfo']), json['houseTardeType']);
    final houseOwner = BaseUserModel.fromJson(json['houseOwner']);
    return HouseModel(
      id: json['id'],
      houseTardeType: json['houseTardeType'],
      houseTerritory: json['houseTerritory'],
      houseAddrCode: json['houseAddrCode'],
      houseAddr: json['houseAddr'],
      houseInfo: houseInfo,
      housePrice: json['housePrice'],
      houseFile: json['houseFile'],
      houseState: json['houseState'],
      houseOwner: houseOwner,
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> houseInfo = this.houseInfo.toJson();
    return {
      'houseTardeType': houseTardeType,
      'houseTerritory': houseTerritory,
      'houseAddrCode': houseAddrCode,
      'houseAddr': houseAddr,
      'housePrice': housePrice.toString(),
      'houseFile': houseFileList,
      'houseState': houseState,
      ...houseInfo,
    };
  }

  HouseModel copyWith({
    int? id,
    String? houseTardeType,
    String? houseTerritory,
    String? houseAddrCode,
    String? houseAddr,
    double? housePrice,
    String? houseFile,
    String? houseState,
    BaseUserModel? houseOwner,
    DateTime? createTime,
    DateTime? updateTime,
    String? decoration,
    String? rentType,
    String? houseType,
    double? houseArea,
    String? buyPayType,
  }) {
    BaseHouseInfo? tmpInfo;
    if (houseTardeType == HouseModel.rentHouse) {
      tmpInfo = (houseInfo as RentHouseInfo).copyWith(
        decoration: decoration,
        rentType: rentType,
        rentPayType: houseType,
      );
    }
    if (houseTardeType == HouseModel.sellHouse) {
      tmpInfo = (houseInfo as BuyHouseInfo).copyWith(
        decoration: decoration,
        houseArea: houseArea,
        buyPayType: buyPayType,
      );
    }
    return HouseModel(
      id: id ?? this.id,
      houseTardeType: houseTardeType ?? this.houseTardeType,
      houseTerritory: houseTerritory ?? this.houseTerritory,
      houseAddrCode: houseAddrCode ?? this.houseAddrCode,
      houseAddr: houseAddr ?? this.houseAddr,
      houseInfo: tmpInfo ?? houseInfo,
      housePrice: housePrice ?? this.housePrice,
      houseFile: houseFile ?? this.houseFile,
      houseState: houseState ?? this.houseState,
      houseOwner: houseOwner ?? this.houseOwner,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  TradeWriteModel toTradeWriteModel(int userId) {
    return TradeWriteModel(
      sellerId: houseOwner.id,
      buyerId: userId,
      houseId: id,
      tradeType: houseTardeType,
    );
  }
}
