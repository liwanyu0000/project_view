import 'dart:async';
import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/pages.dart';
import 'package:project_view/utils/utils.dart';

import '../../config/constants.dart';

class HomeController extends GetxController {
  RxInt counter = 0.obs;

  // 移动端底部导航
  final RxInt _index = 0.obs;
  int get index => _index.value;
  set index(int value) => _index.value = value;

  void changeIndex(int value) {
    index = value;
    final String page = Pages.routeNames[index];
    if (page.isNotEmpty) rootRouter.toPage(page);
  }

  @override
  void onInit() {
    super.onInit();
    if (Adaptive.isDesktop) {
      doWhenWindowReady(() {
        if (appWindow.isMaximized) appWindow.restore();
        appWindow.title = kProductName;
        appWindow.minSize = appWindow.size = const Size(1024, 600);
        appWindow.maxSize = const Size(3840, 2160);
        appWindow.maximize();
        if (!appWindow.isVisible) appWindow.show();
      });
    }
    if (Adaptive.isWeb) {}
    if (Adaptive.isMobile) {}
    Timer.periodic(const Duration(seconds: 1), (timer) {
      counter.value++;
    });
  }
}
