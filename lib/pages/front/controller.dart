import 'dart:async';

import 'package:get/get.dart';
import 'package:project_view/pages/base_page/base_controller.dart';
import 'package:project_view/utils/area.dart';

class FrontController extends BaseController {
  RootAreaNode? get rootArea => homeController.area;
  RxInt counter = 0.obs;
  late Timer x;
  @override
  void onInit() {
    super.onInit();
    x = Timer.periodic(const Duration(seconds: 1), (timer) {
      counter.value++;
    });
  }

  @override
  void onClose() {
    x.cancel();
    super.onClose();
  }
}
