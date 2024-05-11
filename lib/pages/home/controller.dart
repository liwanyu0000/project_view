import 'dart:async';
import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:get/get.dart';
import 'package:project_view/model/user/change_pwd_w.dart';
import 'package:project_view/model/user/user_login.dart';
import 'package:project_view/model/user/user_login_w.dart';
import 'package:project_view/model/user/user_w.dart';
import 'package:project_view/model/user/verify_code.dart';
import 'package:project_view/pages/components/select_imgs.dart';
import 'package:project_view/pages/components/snackbar.dart';
import 'package:project_view/pages/pages.dart';
import 'package:project_view/repo/house_repo.dart';
import 'package:project_view/repo/user_repo.dart';
import 'package:project_view/utils/area.dart';
import 'package:project_view/utils/utils.dart';

import '../../config/constants.dart';
import '../../model/user/user_register_w.dart';
import '../../services/http.dart';
import '../../services/profile.dart';

class HomeController extends GetxController {
  final UserRepo userRepo;
  final HouseRepo houseRepo;
  HomeController(this.userRepo, this.houseRepo);
  RxInt counter = 0.obs;

  final Rx<RootAreaNode?> _area = Rx(null);
  RootAreaNode? get area => _area.value;

  final Rx<UserLoginModel?> _me = Rx<UserLoginModel?>(null);

  UserLoginModel? get me => _me.value;
  set me(UserLoginModel? value) => _me.value = value;

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
  setEditInfo(String key, dynamic value) => _editInfo[key] = value;
  getEditInfo(String key) => _editInfo[key];
  cleanEditInfo() => _editInfo.clear();
  setAllEditInfo(Map<String, dynamic> value) => _editInfo.addAll(value);
  Future<bool> register() =>
      userRepo.register(UserRegisterWriteModel.fromJson(_editInfo));
  login() async {
    _me.value = await userRepo.login(UserLoginWriteModel.fromJson(_editInfo));
    cleanEditInfo();
    HttpService.to.token = me?.token;
    ProfileService.to?.write('token', me?.token);
  }

  setIsLoginView() {
    refreshCode();
    _isLoginView.value = !isLoginView;
  }

  logout() async {
    await userRepo.logout();
    _me.value = null;
    rootRouter.toPage(Pages.front);
    HttpService.to.token = me?.token;
    ProfileService.to?.remove('token');
  }

  // 修改密码
  Future<bool> changePwd() async =>
      userRepo.changePwd(ChangePwdWriteModel.fromJson(_editInfo));
  Future<void> changeInfo() async {
    if (await userRepo.changeInfo(UserWriteModle.fromJson(_editInfo))) {
      _me.value = me?.copyWith(
        nickName: _editInfo['nickname'],
        phones: _editInfo['phone'],
        emails: _editInfo['email'],
        addrCode: _editInfo['addrCode'],
        addr: _editInfo['addr'],
        sex: _editInfo['sex'],
        birthday: _editInfo['birthday'],
        favorite: _editInfo['favorite'],
        signature: _editInfo['signature'],
      );
    }
  }

  // 发布房屋信息
  Future<bool> addHouse() async {
    final json = {
      'houseInfo': {
        'addrCode': _editInfo['addrCode'],
        'addr': _editInfo['addr'],
        'describe': _editInfo['describe'],
      }.toString(),
      'houseTerritory': _editInfo['houseTerritory'],
      'houseTardeType': _editInfo['houseTardeType'],
      'houseFile': _editInfo['houseFile'].join(','),
      'userID': me?.id,
    };
    return await houseRepo.addHouse(json);
  }

  // 图像选择器
  SelectImgController selectImgController = SelectImgController();

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
    String? token = ProfileService.to?.read('token');
    if (token != null) {
      HttpService.to.token = token;
      hookExceptionWithSnackbar(
          () async => _me.value = await userRepo.loginByToken());
    }
    AreaNode.loadFile().then((value) => _area.value = value);

    if (Adaptive.isWeb) {}
    if (Adaptive.isMobile) {}
    _verifyCode
        .listen((code) => _editInfo['codeToken'] = code?.codeToken ?? '');
    Timer.periodic(const Duration(seconds: 1), (timer) {
      counter.value++;
    });
  }
}
