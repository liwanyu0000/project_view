import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_view/pages/components/config/config.dart';

import '../../utils/utils.dart';
import '../base_page/base_house_view.dart';
import '../components/select_popmenu.dart';
import 'controller.dart';

class FavoriteView extends BaseHouseView<FavoriteController> {
  const FavoriteView({super.key});

  @override
  List<Widget> buildExternHeadItem(BuildContext context) => [
        const SizedBox(width: 20),
        const Text('状态：'),
        SelectPopMenu(
          width: 100,
          controller: controller.houseStateController,
          onSelect: (_) => controller.filterData(),
        ),
      ];

  @override
  List<Widget> houseItem(BuildContext context) => [
        creatHead(
          context,
          onTrade: (e) {
            controller.filterData();
          },
          onTerritory: (e) {
            controller.filterData();
          },
          clean: () {
            controller.houseTerritoryController.reset();
            controller.houseTradeTypeController.clear();
            controller.fliterHouse.clear();
            controller.filterData();
          },
        ),
        buildFilter(context),
        buildHouses(context),
      ];

  @override
  Widget viewBuild(BuildContext context) {
    return Padding(
      padding: Adaptive.isSmall(context)
          ? const EdgeInsets.only(top: 50)
          : const EdgeInsets.all(20),
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '我的发布',
            style: TextStyle(fontSize: textSizeConfig.bigTitleTextSize),
          ),
        ),
        const SizedBox(height: 10),
        ...houseItem(context)
      ]),
    );
  }
}
