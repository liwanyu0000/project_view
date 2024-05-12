import 'package:get/get.dart';
import 'package:project_view/pages/base_page/base_controller.dart';
import 'package:project_view/utils/area.dart';

class FrontController extends BaseController {
  RootAreaNode? get rootArea => homeController.area;

  final Rx<String?> _houseTradeType = Rx(null);
  String get houseTradeType => _houseTradeType.value ?? '';
  set houseTradeType(String value) => _houseTradeType.value = value;

  final Rx<String?> _houseTerritory = Rx(null);
  String get houseTerritory => _houseTerritory.value ?? '';
  set houseTerritory(String value) => _houseTerritory.value = value;

  bool get infoIsEmpty => houseTradeType.isEmpty || houseTerritory.isEmpty;

  final Rx<List> _houseList = Rx([]);
  List get houseList => _houseList.value;
  set houseList(List value) => _houseList.value = value;
}
