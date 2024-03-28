import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension Adaptive on Platform {
  static final bool isWindows = Platform.isWindows;
  static final bool isLinux = Platform.isLinux;
  static final bool isMacOS = Platform.isMacOS;

  /// 是否是桌面：Windows、Linux、MacOS
  static final bool isDesktop = isWindows || isLinux || isMacOS;

  /// 是否使用窗口按钮：Windows、Linux
  static final bool useWindowButtons = isWindows || isLinux;

  static final bool isAndroid = Platform.isAndroid;
  static final bool isIOS = Platform.isIOS;
  static final bool isFuchsia = Platform.isFuchsia;

  /// 是否是移动端：Android、IOS、Fuchsia
  static final bool isMobile = isAndroid || isIOS || isFuchsia;

  /// 是否是Web
  static const bool isWeb = kIsWeb;

  /// 小屏幕: [0, 600)
  static const small = Breakpoint(begin: 0, end: 600);

  /// 中屏幕: [600, 840)
  static const medium = Breakpoint(begin: 600, end: 840);

  /// 大屏幕: [840, +∞)
  static const large = Breakpoint(begin: 840);

  static double getWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double getHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static bool useDrawerOf(BuildContext context) => !large.isActive(context);
  static bool isSmall([BuildContext? context]) =>
      small.isActive(context ?? Get.context!);
  // 判断当前设备的屏幕方向是否为横向（landscape）模式
  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;
  // 判断当前设备的屏幕方向是否为纵向（portrait）模式
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;
}

class Breakpoint {
  final double? begin, end;

  const Breakpoint({this.begin, this.end});

  bool isActive(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final lowerBound = begin ?? double.negativeInfinity;
    final upperBound = end ?? double.infinity;
    return width >= lowerBound && width < upperBound;
  }
}
