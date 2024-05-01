import 'package:get/get.dart';

import 'controller.dart';

class PersonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonController>(() => PersonController());
  }
}
