import 'package:get/get.dart';
import 'package:project_view/repo/user_repo.dart';

import 'controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(UserRepo(Get.find())));
  }
}
