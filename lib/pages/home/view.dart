import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(
        () => Text('HomeView is working  ${controller.counter}'),
      ),
    );
  }
}
