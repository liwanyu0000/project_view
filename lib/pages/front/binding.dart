import 'package:get/get.dart';

import 'controller.dart';

class FrontBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FrontController>(() => FrontController());
  }
}
