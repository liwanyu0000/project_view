import 'dart:convert';

import 'package:flutter/services.dart';

abstract class AreaNode {
  final String province;
  final String city;
  final String county;
  final String street;
  final String name;
  final String code;
  final List<AreaNode> children;
  const AreaNode({
    required this.name,
    required this.code,
    this.children = const [],
    this.province = '',
    this.city = '',
    this.county = '',
    this.street = '',
  });

  // 使用loadFile的构建逻辑 -
  // 当下级信息存在时，上级信息必定存在 -
  // 当上级信息不存在时，下级信息必定不存在 -
  // 例如: 当haveCity为true时，该节点必定为市或市的下级节点 -
  // 在创建CityAreaNode时，province为必要参数 -
  // 在创建CountyAreaNode时，province和city为必要参数 -
  // 在创建StreetAreaNode时，province、city和county为必要参数 -

  /// 当前节点无信息
  bool get noInfo => province.isEmpty;

  /// 省级节点
  bool get haveProvince => province.isNotEmpty;

  /// 市级节点
  bool get haveCity => city.isNotEmpty;

  /// 区级节点
  bool get haveCounty => county.isNotEmpty;

  /// 街道级节点
  bool get haveStreet => street.isNotEmpty;

  /// 获取省code
  String get provinceCode => haveProvince ? code.substring(0, 2) : '';

  static Future<RootAreaNode> loadFile() async {
    final String data = await rootBundle.loadString("assets/json/area.json");
    dynamic json = jsonDecode(data);
    return RootAreaNode.fromJson(json);
  }

  static String getProvinceCode(String? code) {
    if (code == null) return '';
    if (code.length < 2) return '';
    return code.substring(0, 2);
  }

  static String getCityCode(String? code) {
    if (code == null) return '';
    if (code.length < 4) return '';
    return code.substring(0, 4);
  }

  static String getCountyCode(String? code) {
    if (code == null) return '';
    if (code.length < 6) return '';
    return code.substring(0, 6);
  }

  static String getStreetCode(String? code) {
    if (code == null) return '';
    if (code.length < 9) return '';
    return code.substring(0, 9);
  }

  AreaNode? findFromCode(String code);
}

class RootAreaNode extends AreaNode {
  const RootAreaNode({List<ProvinceAreaNode> children = const []})
      : super(children: children, code: '', name: '');

  factory RootAreaNode.fromJson(dynamic json) {
    if (json is List) {
      return RootAreaNode(
        children: json.map((e) => ProvinceAreaNode.fromJson(e)).toList(),
      );
    }
    throw "data error";
  }

  @override
  List<ProvinceAreaNode> get children =>
      super.children as List<ProvinceAreaNode>;

  @override
  AreaNode? findFromCode(String code) {
    if (code.length < 2) return null;
    String tmpCode = code.substring(0, 2);
    for (ProvinceAreaNode e in children) {
      if (e.code == tmpCode) {
        return e.findFromCode(code) ?? e;
      }
    }
    return null;
  }
}

class ProvinceAreaNode extends AreaNode {
  const ProvinceAreaNode(
      {required super.name,
      required super.code,
      List<CityAreaNode> children = const []})
      : assert(code.length == 2),
        super(children: children, province: name);

  factory ProvinceAreaNode.fromJson(Map<String, dynamic> json) {
    List children = json['children'] ?? [];
    return ProvinceAreaNode(
      name: json['name'],
      code: json['code'],
      children: children
          .map((e) => CityAreaNode.fromJson(e, json['name'] ?? ""))
          .toList(),
    );
  }

  @override
  List<CityAreaNode> get children => super.children as List<CityAreaNode>;

  @override
  AreaNode? findFromCode(String code) {
    if (code.length < 4) return null;
    String tmpCode = code.substring(0, 4);
    for (CityAreaNode e in children) {
      if (e.code == tmpCode) {
        return e.findFromCode(code) ?? e;
      }
    }
    return null;
  }
}

class CityAreaNode extends AreaNode {
  const CityAreaNode(
      {required super.name,
      required super.code,
      required super.province,
      List<CountyAreaNode> children = const []})
      : assert(code.length == 4),
        super(children: children, city: name);

  factory CityAreaNode.fromJson(Map<String, dynamic> json, String province) {
    List children = json['children'] ?? [];
    return CityAreaNode(
      name: json['name'],
      code: json['code'],
      province: province,
      children: children
          .map((e) => CountyAreaNode.fromJson(e, province, json['name'] ?? ''))
          .toList(),
    );
  }
  @override
  List<CountyAreaNode> get children => super.children as List<CountyAreaNode>;

  @override
  AreaNode? findFromCode(String code) {
    if (code.length < 6) return null;
    String tmpCode = code.substring(0, 6);
    for (CountyAreaNode e in children) {
      if (e.code == tmpCode) {
        return e.findFromCode(code) ?? e;
      }
    }
    return null;
  }
}

class CountyAreaNode extends AreaNode {
  CountyAreaNode(
      {required super.name,
      required super.code,
      required super.province,
      required super.city,
      List<StreetAreaNode> children = const []})
      : assert(code.length == 6),
        super(children: children, county: name);

  factory CountyAreaNode.fromJson(
      Map<String, dynamic> json, String province, String city) {
    List children = json['children'] ?? [];
    return CountyAreaNode(
      name: json['name'],
      code: json['code'],
      province: province,
      city: city,
      children: children
          .map((e) =>
              StreetAreaNode.fromJson(e, province, city, json['name'] ?? ''))
          .toList(),
    );
  }

  @override
  List<StreetAreaNode> get children => super.children as List<StreetAreaNode>;

  @override
  AreaNode? findFromCode(String code) {
    if (code.length < 9) return null;
    for (StreetAreaNode e in children) {
      if (e.code == code) {
        return e.findFromCode(code) ?? e;
      }
    }
    return null;
  }
}

class StreetAreaNode extends AreaNode {
  StreetAreaNode({
    required super.name,
    required super.code,
    required super.province,
    required super.city,
    required super.county,
  })  : assert(code.length == 9),
        super(street: name);

  factory StreetAreaNode.fromJson(Map<String, dynamic> json, String province,
          String city, String county) =>
      StreetAreaNode(
        name: json['name'],
        code: json['code'],
        province: province,
        city: city,
        county: county,
      );

  @override
  AreaNode? findFromCode(String code) => null;
}
