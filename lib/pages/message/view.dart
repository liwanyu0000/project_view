import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/logger.dart';
import '../home/controller.dart';

class MessageView extends GetView<HomeController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    LoggerService.to.t('build', tag: [runtimeType]);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Obx(() => Text('message view  ${controller.counter.value}'))
        ],
      ),
    );
  }
}
