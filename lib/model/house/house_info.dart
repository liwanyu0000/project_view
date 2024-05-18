import 'package:project_view/model/house/house.dart';

abstract class BaseHouseInfo {
  final String decoration;
  const BaseHouseInfo({
    required this.decoration,
  });

  factory BaseHouseInfo.fromJson(Map<String, dynamic> json, String type) {
    switch (type) {
      case HouseModel.rentHouse:
        return RentHouseInfo.fromJson(json);
      case HouseModel.sellHouse:
        return BuyHouseInfo.fromJson(json);
      default:
        throw Exception('Unknown house type');
    }
  }
  String get payTypeText;

  Map<String, dynamic> toJson();

  BaseHouseInfo copyWith({
    String? decoration,
  });
}

// 租房
class RentHouseInfo extends BaseHouseInfo {
  // 租房类型
  final String rentType;

  // 整租
  static const String rentTypeWhole = 'Whole';
  // 合租
  static const String rentTypeJoint = 'Joint';

  // 租房支付方式
  final String rentPayType;

  /// 月付
  static const String rentPayMonth = 'Month';
  // 季付
  static const String rentPayQuarter = 'Quarter';
  // 半年付
  static const String rentPayHalfYear = 'HalfYear';
  // 年付
  static const String rentPayYear = 'Year';

  @override
  String get payTypeText {
    List<String> payTypeList = [];
    if (rentPayType.contains(rentPayMonth)) {
      payTypeList.add('月付');
    }
    if (rentPayType.contains(rentPayQuarter)) {
      payTypeList.add('季付');
    }
    if (rentPayType.contains(rentPayHalfYear)) {
      payTypeList.add('半年付');
    }
    if (rentPayType.contains(rentPayYear)) {
      payTypeList.add('年付');
    }
    return payTypeList.join('、');
  }

  String addPayType(String value) {
    if (rentPayType.contains(value)) {
      return rentPayType;
    }
    return rentPayType + value;
  }

  String removePayType(String value) {
    return rentPayType.replaceAll(value, '');
  }

  RentHouseInfo({
    required super.decoration,
    required this.rentType,
    required this.rentPayType,
  });

  @override
  RentHouseInfo copyWith({
    String? decoration,
    String? rentType,
    String? rentPayType,
  }) {
    return RentHouseInfo(
      decoration: decoration ?? this.decoration,
      rentType: rentType ?? this.rentType,
      rentPayType: rentPayType ?? this.rentPayType,
    );
  }

  factory RentHouseInfo.fromJson(Map<String, dynamic> json) {
    if (json['rentType'] == null) {
      throw "请选择租房类型";
    }
    String rentPayType;
    if (json['rentPayType'] == null) {
      throw "请选择支付方式";
    }
    if (json['rentPayType'] is String) {
      rentPayType = json['rentPayType'];
    } else {
      rentPayType = (json['rentPayType'] ?? []).cast<String>().join('');
    }
    if (rentPayType.isEmpty) {
      throw "请选择支付方式";
    }
    return RentHouseInfo(
      decoration: json['decoration'],
      rentType: json['rentType'],
      rentPayType: rentPayType,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'decoration': decoration,
      'rentType': rentType,
      'rentPayType': rentPayType,
    };
  }
}

// 买房
class BuyHouseInfo extends BaseHouseInfo {
  // 房屋面积
  final double houseArea;

  // 买房支付方式
  final String buyPayType;

  /// 全款
  static const String buyPayOnce = 'Once';
  // 按揭
  static const String buyPayMortgage = 'Mortgage';
  // 分期
  static const String buyPayInstallment = 'Installment';

  String addPayType(String value) {
    if (buyPayType.contains(value)) {
      return buyPayType;
    }
    return buyPayType + value;
  }

  @override
  String get payTypeText {
    List<String> payTypeList = [];
    if (buyPayType.contains(buyPayOnce)) {
      payTypeList.add('全款');
    }
    if (buyPayType.contains(buyPayMortgage)) {
      payTypeList.add('按揭');
    }
    if (buyPayType.contains(buyPayInstallment)) {
      payTypeList.add('分期');
    }
    return payTypeList.join('、');
  }

  String removePayType(String value) {
    return buyPayType.replaceAll(value, '');
  }

  BuyHouseInfo({
    required super.decoration,
    required this.houseArea,
    required this.buyPayType,
  });

  @override
  BuyHouseInfo copyWith({
    String? decoration,
    double? houseArea,
    String? buyPayType,
  }) {
    return BuyHouseInfo(
      decoration: decoration ?? this.decoration,
      houseArea: houseArea ?? this.houseArea,
      buyPayType: buyPayType ?? this.buyPayType,
    );
  }

  factory BuyHouseInfo.fromJson(Map<String, dynamic> json) {
    double? houseArea = double.tryParse(json['houseArea'].toString());
    if (houseArea == null) {
      throw "请输入房屋面积";
    }
    if (houseArea <= 1) {
      throw "房屋面积不能太小";
    }
    if (json['buyPayType'] == null) {
      throw "请选择支付方式";
    }
    String buyPayType;
    if (json['buyPayType'] is String) {
      buyPayType = json['buyPayType'];
    } else {
      buyPayType = (json['buyPayType'] ?? []).cast<String>().join('');
    }
    if (buyPayType.isEmpty) {
      throw "请选择支付方式";
    }
    return BuyHouseInfo(
      decoration: json['decoration'],
      houseArea: houseArea,
      buyPayType: buyPayType,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'decoration': decoration,
      'houseArea': houseArea.toString(),
      'buyPayType': buyPayType,
    };
  }
}
