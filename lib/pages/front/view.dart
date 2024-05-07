import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/components/area_filter.dart';

import '../../services/logger.dart';
import 'controller.dart';

class FrontView extends GetView<FrontController> {
  const FrontView({super.key});

  @override
  Widget build(BuildContext context) {
    LoggerService.to.t('build', tag: [runtimeType]);
    return Center(
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (controller.rootArea != null)
              AreaFilter(
                province: controller.rootArea!.children[4],
                onSelected: (node) {
                  print('province: ${node.province} city: ${node.city} county:'
                      ' ${node.county} street: ${node.street} code: ${node.code} name: ${node.name}');
                },
              )
          ],
        ),
      ),
    );
  }
}
