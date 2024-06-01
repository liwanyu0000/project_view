import 'package:get/get.dart';
import 'package:project_view/repo/house_repo.dart';
import 'package:project_view/repo/notify_repo.dart';
import 'package:project_view/repo/trade_repo.dart';
import 'package:project_view/repo/user_repo.dart';

import '../../repo/communicate_repo.dart';
import 'controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(
          UserRepo(Get.find()),
          HouseRepo(Get.find()),
          NotifyRepo(Get.find()),
          CommunicateRepo(Get.find()),
          TradeRepo(Get.find()),
        ));
  }
}
