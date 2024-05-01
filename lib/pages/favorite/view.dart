import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/logger.dart';
import 'controller.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    LoggerService.to.t('build', tag: [runtimeType]);
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('favorite view')],
      ),
    );
  }
}
