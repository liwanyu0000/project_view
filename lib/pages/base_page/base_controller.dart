import 'package:get/get.dart';
import 'package:project_view/repo/user_repo.dart';
import 'package:project_view/utils/area.dart';

import '../../model/user/user_login.dart';
import '../components/page_notify.dart';
import '../home/controller.dart';

abstract class BaseController extends GetxController implements PageNotify {
  HomeController homeController = Get.find<HomeController>();

  UserRepo get userRepo => homeController.userRepo;

  bool get isLogin => homeController.isLogin;

  RootAreaNode? get area => homeController.area;

  UserLoginModel? get me => homeController.me;

  @override
  void onInit() {
    super.onInit();
    homeController.pageNotifys.add(this);
  }

  @override
  void onClose() {
    homeController.pageNotifys.remove(this);
    super.onClose();
  }
}
