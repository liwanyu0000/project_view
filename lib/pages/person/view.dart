import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/logger.dart';
import 'controller.dart';

class PersonView extends GetView<PersonController> {
  const PersonView({super.key});

  @override
  Widget build(BuildContext context) {
    LoggerService.to.t('build', tag: [runtimeType]);
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('person view')],
      ),
    );
  }
}
