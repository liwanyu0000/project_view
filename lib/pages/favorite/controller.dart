import 'package:project_view/pages/base_page/base_house_controller.dart';
import 'package:project_view/pages/components/page_notify.dart';

import '../../model/house/house.dart';

class FavoriteController extends BaseHouseController {
  @override
  void onInit() {
    super.onInit();
    if (homeController.isLogin) refreshData();
  }

  @override
  bool fliterMonth(HouseModel model) {
    bool flag = true;
    flag = flag &&
        (houseTradeType.isEmpty || model.houseTardeType == houseTradeType);
    flag = flag &&
        (houseTerritory.isEmpty || model.houseTerritory == houseTerritory);
    flag = flag && (houseStateController.firstValue == model.houseState);
    flag = flag && (fliterHouse.filter(model));
    return flag;
  }

  @override
  Future<List<HouseModel>> getNetData() async {
    return await houseRepo.getHousesForToken(pageNum, pageSize);
  }

  @override
  notify(String key, [dynamic data]) {
    if (key == PageNotify.login) refreshData();
    if (key == PageNotify.logout) clearData();
  }
}
