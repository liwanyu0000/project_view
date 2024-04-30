import 'dart:async';

import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt counter = 0.obs;

  @override
  void onInit() {
    super.onInit();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      counter.value++;
    });
  }
}
