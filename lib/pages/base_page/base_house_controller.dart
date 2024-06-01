import 'dart:async';

import 'package:get/get.dart';
import 'package:project_view/pages/components/page_notify.dart';

import '../../model/house/house.dart';
import '../../repo/house_repo.dart';
import '../../utils/area.dart';
import '../components/area_filter.dart';
import '../components/from_view/filter_view.dart';
import '../components/select_popmenu.dart';
import '../components/snackbar.dart';
import 'base_controller.dart';

abstract class BaseHouseController extends BaseController {
  HouseRepo get houseRepo => homeController.houseRepo;

  FilterController get fliterHouse => homeController.houseFilter;

  final RxBool _isExpanded = false.obs;
  bool get isExpanded => _isExpanded.value;
  set isExpanded(bool value) => _isExpanded.value = value;

  final RxList<HouseModel> _houseModels = <HouseModel>[].obs;
  List<HouseModel> get houseModels => _houseModels;
  set houseModels(List<HouseModel> value) => _houseModels.value = value;

  final RxList<int> showModels = <int>[].obs;

  RootAreaNode? get rootArea => homeController.area;
  // 房屋交易类型
  final SelectController _houseTradeTypeController = SelectController(const [
    SelectData(label: '买房', data: 'sell'),
    SelectData(label: '租房', data: 'rent'),
  ]);
  SelectController get houseTradeTypeController => _houseTradeTypeController;
  String get houseTradeType => _houseTradeTypeController.firstValue;
  // 房屋属地
  final ProvinceFilterController _houseTerritoryController =
      ProvinceFilterController();
  ProvinceFilterController get houseTerritoryController =>
      _houseTerritoryController;
  String get houseTerritory => _houseTerritoryController.code;
  SelectController houseStateController = SelectController(
    const [
      SelectData(
          label: '已发布', data: HouseModel.houseStatusPublish, isDefault: true),
      SelectData(label: '审核中', data: HouseModel.houseStatusAudit),
      SelectData(label: '已完成交易', data: HouseModel.houseStatusComplete),
      SelectData(label: '未过审', data: HouseModel.houseStatusNotPass),
      SelectData(label: '用户已取消', data: HouseModel.houseStatusOff),
    ],
  );

  bool get infoIsEmpty => houseTradeType.isEmpty || houseTerritory.isEmpty;

  final RxInt _pageNum = 0.obs;
  int get pageNum => _pageNum.value;
  set pageNum(int value) => _pageNum.value = value;

  final RxInt _pageSize = 6.obs;
  int get pageSize => _pageSize.value;
  set pageSize(int value) => _pageSize.value = value;

  final RxBool _isLoad = false.obs;
  bool get isLoad => _isLoad.value;
  set isLoad(bool value) => _isLoad.value = value;

  final RxBool _isEnd = false.obs;
  bool get isEnd => _isEnd.value;
  set isEnd(bool value) => _isEnd.value = value;

  bool get isEmpty => showModels.isEmpty;

  Future<List<HouseModel>> getNetData();

  bool fliterMonth(HouseModel model);

  Future getData() async {
    hookExceptionWithSnackbar(() async {
      if (isEnd || isLoad) return;
      isLoad = true;
      List<HouseModel> item = await getNetData();
      isLoad = false;
      pageNum++;
      _houseModels.addAll(item);
      if (item.length < pageSize) isEnd = true;
    }, exceptionHandle: () => isLoad = false);
  }

  filterData() {
    if (isLoad) return;
    isLoad = true;
    showModels.clear();
    for (int i = 0; i < houseModels.length; i++) {
      if (fliterMonth(houseModels[i])) {
        showModels.add(i);
      }
    }
    isLoad = false;
    if (showModels.isEmpty) getData();
  }

  Future refreshData() async {
    if (isLoad) return;
    isLoad = true;
    pageNum = 0;
    isEnd = false;
    _houseModels.clear();
    isLoad = false;
    await getData();
  }

  clearData() {
    pageNum = 0;
    isEnd = false;
    houseModels.clear();
    showModels.clear();
  }

  Future houseOperate(String key, int index) async {
    dynamic data;
    if (key == HouseModel.houseOperateEdit) {
      data = () async =>
          houseModels[index] = await houseRepo.getHouse(houseModels[index].id);
    }
    if (key == HouseModel.houseOperateNewEdit) {
      data = refreshData;
    }
    if (key == HouseModel.houseOperateReview) {
      data = (bool pass) async => houseModels[index] = houseModels[index]
          .copyWith(
              houseState: pass
                  ? HouseModel.houseStatusPublish
                  : HouseModel.houseStatusNotPass);
    }
    await homeController.houseOperate(key, houseModels[index], data);
    if (key == HouseModel.houseOperateDelete) {
      houseModels[index] =
          houseModels[index].copyWith(houseState: HouseModel.houseStatusOff);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _houseModels.listen((data) async {
      data.isEmpty ? showModels.clear() : filterData();
    });
  }

  @override
  void notify(String key, [dynamic data]) {
    if (key == PageNotify.permission) {
      houseStateController.reset();
      refreshData();
    }
    if (key == PageNotify.houses) {
      bool flag = true;
      for (int i = 0; i < houseModels.length; i++) {
        if (houseModels[i].id == data.data.id) {
          _houseModels[i] = data.data;
          flag = false;
          break;
        }
      }
      if (flag) _houseModels.insert(0, data.data);
    }
  }
}
