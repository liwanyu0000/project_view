import 'dart:async';
import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:get/get.dart';
import 'package:project_view/model/user/user_login.dart';
import 'package:project_view/model/user/verify_code.dart';
import 'package:project_view/pages/components/snackbar.dart';
import 'package:project_view/pages/pages.dart';
import 'package:project_view/repo/user_repo.dart';
import 'package:project_view/utils/utils.dart';

import '../../config/constants.dart';

class HomeController extends GetxController {
  final UserRepo userRepo;
  HomeController(this.userRepo);
  RxInt counter = 0.obs;

  final Rx<UserLoginModel?> _me = Rx<UserLoginModel?>(null);

  UserLoginModel? get me => _me.value;

  bool get isLogin => me != null;

  final Rx<VerifyCodeModel?> _verifyCode = Rx(null);
  VerifyCodeModel? get verifyCode => _verifyCode.value;
  set verifyCode(VerifyCodeModel? value) => _verifyCode.value = value;

  Future refreshCode() async => hookExceptionWithSnackbar(
      () async => verifyCode = await userRepo.getCode());

  // 登录or注册
  final RxBool _isLoginView = RxBool(true);
  bool get isLoginView => _isLoginView.value;
  final Map<String, dynamic> _editInfo = {};
  setEditInfo(String key, String value) => _editInfo[key] = value;
  getEditInfo(String key) => _editInfo[key];
  cleanEditInfo() => _editInfo.clear();
  Future<bool> register() => userRepo.register(_editInfo);
  login() => hookExceptionWithSnackbar(
      () async => _me.value = await userRepo.login(_editInfo));
  setIsLoginView() {
    refreshCode();
    _isLoginView.value = !isLoginView;
  }

  logout() {
    _me.value = null;
    rootRouter.toPage(Pages.front);
  }

  // 修改密码
  Future<bool> changePwd() async {
    _editInfo['id'] = me?.id;
    return await userRepo.changePwd(_editInfo);
  }

  // 移动端底部导航
  final RxInt _index = 0.obs;
  int get index => _index.value;
  set index(int value) => _index.value = value;

  void changeIndex(int value) {
    index = value;
    final String page = Pages.routeNames[index];
    if (page.isNotEmpty) rootRouter.toPage(page);
  }

  @override
  void onInit() {
    super.onInit();
    if (Adaptive.isDesktop) {
      doWhenWindowReady(() {
        if (appWindow.isMaximized) appWindow.restore();
        appWindow.title = kProductName;
        appWindow.minSize = appWindow.size = const Size(1024, 600);
        appWindow.maxSize = const Size(3840, 2160);
        appWindow.maximize();
        if (!appWindow.isVisible) appWindow.show();
      });
    }
    if (Adaptive.isWeb) {}
    if (Adaptive.isMobile) {}
    _verifyCode
        .listen((code) => _editInfo['codeToken'] = code?.codeToken ?? '');
    Timer.periodic(const Duration(seconds: 1), (timer) {
      counter.value++;
    });
  }
}
