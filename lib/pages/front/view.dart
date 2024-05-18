import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/base_page/base_house_view.dart';
import 'package:project_view/pages/components/config/config.dart';
import 'package:project_view/utils/adaptive.dart';

import '../../services/logger.dart';
import '../components/select_popmenu.dart';
import 'controller.dart';

class FrontView extends BaseHouseView<FrontController> {
  const FrontView({super.key});

  @override
  List<Widget> buildExternHeadItem(BuildContext context) => [
        Obx(
          () => (controller.me?.isAdmin ?? false)
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 20),
                    const Text('状态：'),
                    SelectPopMenu(
                      width: 100,
                      controller: controller.houseStateController,
                      onSelect: (_) => controller.refreshData(),
                    ),
                  ],
                )
              : const SizedBox(),
        )
      ];

  @override
  List<Widget> houseItem(BuildContext context) => [
        creatHead(
          context,
          onTrade: (e) {
            if (controller.houseTradeType.isNotEmpty) controller.refreshData();
          },
          onTerritory: (e) {
            if (controller.houseTerritory.isNotEmpty) controller.refreshData();
          },
          clean: () {
            if (controller.fliterHouse.isEmpty) return;
            controller.fliterHouse.clear();
            controller.filterData();
          },
        ),
        buildFilter(context),
        Obx(() => controller.infoIsEmpty
            ? Expanded(
                child: Center(
                  child: Text(
                    "请选择地区与交易类型",
                    style: TextStyle(
                      fontSize: textSizeConfig.bigTitleTextSize,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              )
            : buildHouses(context)),
      ];

  @override
  Widget build(BuildContext context) {
    LoggerService.to.t('build', tag: [runtimeType]);
    return Padding(
      padding: Adaptive.isSmall(context)
          ? const EdgeInsets.only(top: 50)
          : const EdgeInsets.all(20),
      child: Column(children: houseItem(context)),
    );
  }

  @override
  Widget viewBuild(BuildContext context) {
    return const SizedBox();
  }
}
