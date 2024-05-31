import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:project_view/model/communicate/communicate.dart';
import 'package:project_view/model/house/house.dart';
import 'package:project_view/model/house/house_w.dart';
import 'package:project_view/model/message/message.dart';
import 'package:project_view/model/user/user_login.dart';
import 'package:project_view/model/user/verify_code.dart';
import 'package:project_view/pages/components/from_view/filter_view.dart';
import 'package:project_view/pages/components/from_view/house_info_view.dart';
import 'package:project_view/pages/components/from_view/show_house_info_view.dart';
import 'package:project_view/pages/components/from_view/communicate_view.dart';
import 'package:project_view/pages/components/snackbar.dart';
import 'package:project_view/pages/pages.dart';
import 'package:project_view/repo/communicate_repo.dart';
import 'package:project_view/repo/house_repo.dart';
import 'package:project_view/repo/notify_repo.dart';
import 'package:project_view/repo/user_repo.dart';
import 'package:project_view/services/notify_channel.dart';
import 'package:project_view/utils/area.dart';
import 'package:project_view/utils/utils.dart';

import '../../model/notify.dart';
import '../../model/user/user.dart';
import '../../services/http.dart';
import '../../services/profile.dart';
import '../components/from_view/edit_info_controller.dart';
import '../components/page_notify.dart';

class HomeController extends GetxController {
  final UserRepo userRepo;
  final HouseRepo houseRepo;
  final NotifyRepo notifyRepo;
  final CommunicateRepo communicateRepo;
  HomeController(
      this.userRepo, this.houseRepo, this.notifyRepo, this.communicateRepo);
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

  NotifyChannel? notifyChannel;
  final List<PageNotify> pageNotifys = [];
  void refreshPage(String key, [dynamic data]) {
    for (var e in pageNotifys) {
      e.notify(key, data);
    }
  }

  Future refreshCode() async => hookExceptionWithSnackbar(
      () async => verifyCode = await userRepo.getCode());

  final Rx<NotifyModel?> _notifyModel = Rx<NotifyModel?>(null);
  NotifyModel? get notifyModel => _notifyModel.value;
  set notifyModel(NotifyModel? value) => _notifyModel.value = value;

  // 登录or注册
  final RxBool _isLoginView = RxBool(true);
  bool get isLoginView => _isLoginView.value;
  EditInfoController editInfoController = EditInfoController();
  Future<bool> register() => userRepo
      .register(editInfoController.registerInfo(verifyCode?.codeToken ?? ''));
  login() async {
    _me.value = await userRepo
        .login(editInfoController.loginInfo(verifyCode?.codeToken ?? ''));
    HttpService.to.token = me?.token;
    ProfileService.to?.write('token', me?.token);
    subscribeRedis();
    refreshPage(PageNotify.login);
    _getCommunicateList();
  }

  setIsLoginView() {
    refreshCode();
    _isLoginView.value = !isLoginView;
  }

  logout() async {
    await userRepo.logout();
    _me.value = null;
    subscribeRedis();
    // rootRouter.toPage(Pages.front);
    HttpService.to.token = me?.token;
    ProfileService.to?.remove('token');
    refreshPage(PageNotify.logout);
    _communicateList.clear();
  }

  // 修改密码
  Future<bool> changePwd() async => userRepo
      .changePwd(editInfoController.pwdInfo(verifyCode?.codeToken ?? ''));
  Future<void> changeInfo() async {
    if (await userRepo.changeInfo(editInfoController.userInfo)) {
      _me.value = editInfoController.copyUser(me);
    }
  }

  final Rx<HouseModel?> _house = Rx(null);
  HouseModel? get house => _house.value;
  set house(HouseModel? value) => _house.value = value;
  Timer? _tmier;

  Future houseOperate(String key, HouseModel model, [dynamic data]) async {
    switch (key) {
      case HouseModel.houseOperateContact:
        loadCommunicate(model.houseOwner);
        toCommunicateView(model.houseOwner, Adaptive.isSmall());
        return;
      case HouseModel.houseOperateDelete:
        houseRepo.deleteHouse(model.id);
        return;
      case HouseModel.houseOperateEdit:
      case HouseModel.houseOperateNewEdit:
        editInfoController.setHouseInfo(model);
        toHouseInfo(Adaptive.isSmall(), key == HouseModel.houseOperateNewEdit,
            model.id, data);
        return;
      case HouseModel.houseOperateRecord:
        return;
      case HouseModel.houseOperateDetail:
        toShowHouse(model, Adaptive.isSmall());
        return;
      case HouseModel.houseOperateReview:
        toShowHouse(model, Adaptive.isSmall(), data);
        return;
      default:
        return;
    }
  }

  // 发布房屋信息
  Future<bool> addHouse() async {
    if (!(me?.canPublish ?? false)) throw '当前账户无法发布房屋信息！！！';
    final HouseWriteModel model = editInfoController.houseInfo;
    return (await houseRepo.addHouse(model)) >= 1;
  }

  // 修改房屋信息
  Future<bool> editHouse(int id) async {
    final HouseWriteModel model = editInfoController.houseInfo;
    return (await houseRepo.updateHouse(model, id)) >= 1;
  }

  Future<bool> reviewHouse(int id, bool pass) async {
    return (await houseRepo.reviewHouse(id, pass)) >= 1;
  }

  // 房屋筛选器
  final FilterController _houseFilter = FilterController();
  FilterController get houseFilter => _houseFilter;

  // 移动端底部导航
  final RxInt _index = 0.obs;
  int get index => _index.value;
  set index(int value) => _index.value = value;

  void changeIndex(int value) {
    index = value;
    final String page = Pages.routeNames[index];
    if (page.isNotEmpty) rootRouter.toPage(page);
  }

  // 订阅redis
  Future _subscribeRedis() async {
    notifyChannel?.stop();
    if (notifyModel != null) await notifyRepo.delete(notifyModel!.channel);
    String? tmpChannel = ProfileService.to?.read('notify');
    if (tmpChannel != null &&
        tmpChannel.isNotEmpty &&
        tmpChannel != notifyModel?.channel) {
      await notifyRepo.delete(tmpChannel);
    }
    notifyChannel = null;
    notifyModel = await notifyRepo.creat();
    ProfileService.to?.write('notify', notifyModel?.channel);
    notifyChannel = NotifyChannel(
      host: notifyModel!.host,
      port: notifyModel!.port ?? 6379,
      onData: (event) {
        if (event is List && event.length >= 3 && event[0] == 'message') {
          MessageModel message = MessageModel.fromJson(jsonDecode(event[2]));
          switch (message.type) {
            case MessageModel.noticeHouseType:
              refreshPage(PageNotify.houses, message);
              break;
            case MessageModel.noticeUserType:
              if (me?.id == message.data.id) {
                if (!(message.data as UserModel).canLogin) {
                  hookExceptionWithSnackbar(() {
                    logout();
                    throw '当前账户已被管理员禁止登录！！！';
                  });
                }
                _me.value = me?.copyWithModel(message.data);
                refreshPage(PageNotify.permission, message);
              }
              if (me?.isAdmin ?? false) {
                for (int i = 0; i < editInfoController.users.length; i++) {
                  if (editInfoController.users[i].id == message.data.id) {
                    editInfoController.setOfIndex(index, message.data);
                    break;
                  }
                }
              }
              break;
            case MessageModel.messageType:
              break;
            default:
              break;
          }
        }
      },
    );
    notifyChannel?.start([notifyModel!.channel], notifyModel!.pwd);
    _tmier?.cancel();
    _tmier = Timer.periodic(
      const Duration(minutes: 5),
      (timer) => hookExceptionWithSnackbar(
        () async => await notifyRepo.keep(notifyModel!.channel),
      ),
    );
  }

  void subscribeRedis() => hookExceptionWithSnackbar(_subscribeRedis);

  // 聊天人员列表
  final RxMap<int, Rx<CommunicateModel>> _communicateList =
      <int, Rx<CommunicateModel>>{}.obs;

  _getCommunicateList() async {
    if (!isLogin) return;
    List<BaseUserModel> users = await communicateRepo.getCommunicateList();
    for (var user in users) {
      if (!_communicateList.containsKey(user.id)) {
        _communicateList[user.id] = Rx<CommunicateModel>(
          CommunicateModel(
            userModelOne: me!,
            userModelTwo: user,
            content: '',
            createTime: DateTime.now(),
            isTmp: true,
          ),
        );
      }
    }
  }

  Rx<CommunicateModel>? getCommunicate(int id) => _communicateList[id];

  loadCommunicate(BaseUserModel to, [bool isInit = false]) async {
    int id = to.id;
    if (!_communicateList.containsKey(id) ||
        _communicateList[id]!.value.isTmp) {
      CommunicateModel? model = await communicateRepo.getCommunicate(id, 0);
      model ??= CommunicateModel(
        userModelOne: me!,
        userModelTwo: to,
        content: '',
        createTime: DateTime.now(),
        isEnd: true,
      );
      _communicateList[id] = Rx<CommunicateModel>(model);
    } else {
      if (isInit) return;
      if (_communicateList[id]!.value.isEnd) return;
      CommunicateModel? model = await communicateRepo.getCommunicate(
          id, _communicateList[id]!.value.pageNum);
      if (model == null) {
        _communicateList[id]!.update((val) => val?.isEnd = true);
        return;
      }

      _communicateList[id]!.update((val) => val?.addALL(model.items));
    }
  }

  List<CommunicateModel> get communicateList =>
      _communicateList.values.map((e) => e.value).toList();

  // 获取聊天记录

  @override
  Future<void> onInit() async {
    super.onInit();
    if (Adaptive.isDesktop) {}
    if (Adaptive.isWeb) {}
    if (Adaptive.isMobile) {}
    String? token = ProfileService.to?.read('token');
    if (token != null) {
      HttpService.to.token = token;
      await hookExceptionWithSnackbar(
        () async {
          _me.value = await userRepo.loginByToken();
          subscribeRedis();
          _getCommunicateList();
        },
        exceptionHandle: () {
          ProfileService.to?.remove('token');
          HttpService.to.token = null;
        },
      );
    }
    AreaNode.loadFile().then((value) => _area.value = value);
    if (me == null) subscribeRedis();
  }

  @override
  void onClose() async {
    notifyChannel?.stop();
    if (notifyModel != null) await notifyRepo.delete(notifyModel!.channel);
    _tmier?.cancel();
    houseFilter.dispose();
    super.onClose();
  }
}
