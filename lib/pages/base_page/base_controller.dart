import 'package:get/get.dart';

import '../../model/user/user_login.dart';
import '../home/controller.dart';

abstract class BaseController extends GetxController {
  HomeController homeController = Get.find<HomeController>();

  bool get isLogin => homeController.isLogin;

  UserLoginModel? get me => homeController.me;
}
