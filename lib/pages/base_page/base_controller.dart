import 'package:get/get.dart';
import 'package:project_view/repo/user_repo.dart';

import '../../model/user/user_login.dart';
import '../home/controller.dart';

abstract class BaseController extends GetxController {
  HomeController homeController = Get.find<HomeController>();

  UserRepo get userRepo => homeController.userRepo;

  bool get isLogin => homeController.isLogin;

  UserLoginModel? get me => homeController.me;
}
