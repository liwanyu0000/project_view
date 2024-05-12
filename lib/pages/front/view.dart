import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/components/select_popmenu.dart';
import 'package:project_view/utils/adaptive.dart';

import '../../services/logger.dart';
import '../components/area_filter.dart';
import 'controller.dart';

class FrontView extends GetView<FrontController> {
  const FrontView({super.key});

  @override
  Widget build(BuildContext context) {
    LoggerService.to.t('build', tag: [runtimeType]);
    return Obx(
      () => Padding(
        padding: Adaptive.isSmall(context)
            ? const EdgeInsets.only(top: 50)
            : const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectPopMenu(
                    item: const [
                      SelectData(label: '买房', value: 'sell'),
                      SelectData(label: '租房', value: 'rent'),
                    ],
                    onSelect: (value) =>
                        controller.houseTradeType = value.value,
                    initValue: controller.houseTradeType,
                  ),
                  if (controller.rootArea != null)
                    ProvinceFilter(
                      area: controller.rootArea!,
                      onSelected: (e) => controller.houseTerritory = e.code,
                    ),
                ],
              ),
            ),
            if (!controller.infoIsEmpty)
              Flexible(
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('title$index'),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: 40),
              )
          ],
        ),
      ),
    );
  }
}
