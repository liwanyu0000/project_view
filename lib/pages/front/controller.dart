import 'dart:async';

import 'package:get/get.dart';

class FrontController extends GetxController {
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
