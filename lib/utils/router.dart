import 'package:flutter/material.dart';
import 'package:get/get.dart';

GetDelegate get rootRouter => Get.rootDelegate;

extension RouterExtension on BuildContext {
  GetDelegate get router => Get.rootDelegate;
  bool get isLightMode => !isDarkMode;
}

extension GetDelegateExtension on GetDelegate {
  /// 清除所有的路由并跳转，主要用到跳转/login页面(目前测试没问题，但不确定是不是有问题)
  Future<T> offAllPage<T>(
    String page, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    while (rootRouter.history.length > 1) {
      rootRouter.history.removeLast();
    }
    return rootRouter.offPage(page,
        arguments: arguments, parameters: parameters);
  }

  Future<T> offPage<T>(
    String page, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    return rootRouter.offNamed(page,
        arguments: arguments, parameters: parameters);
  }

  Future<T> toPage<T>(
    String page, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    return rootRouter.toNamed(page,
        arguments: arguments, parameters: parameters);
  }

  Uri? get uri => rootRouter.currentConfiguration?.uri;

  /// 路由位置
  String? get location => uri?.path;
}
