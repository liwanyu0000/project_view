import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/logger.dart';
import 'controller.dart';

class FrontView extends GetView<FrontController> {
  const FrontView({super.key});

  @override
  Widget build(BuildContext context) {
    LoggerService.to.t('build', tag: [runtimeType]);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Obx(() => Text('front view ${controller.counter.value}'))
        ],
      ),
    );
  }
}
