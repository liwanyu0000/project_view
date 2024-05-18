import 'package:project_view/pages/components/page_notify.dart';

import '../../model/house/house.dart';
import '../base_page/base_house_controller.dart';

class FrontController extends BaseHouseController {
  @override
  Future<List<HouseModel>> getNetData() async {
    String state;
    if (me?.isAdmin ?? false) {
      state = houseStateController.firstValue;
    } else {
      state = HouseModel.houseStatusPublish;
    }
    return await houseRepo.getHouses(
      houseTardeType: houseTradeType,
      houseTerritory: houseTerritory,
      houseState: state,
      pageNum: pageNum,
      pageSize: pageSize,
    );
  }

  @override
  bool fliterMonth(HouseModel model) => fliterHouse.filter(model);
  @override
  notify(String key, [dynamic data]) {
    if (key == PageNotify.login || key == PageNotify.logout) {
      refreshData();
    }
  }
}
