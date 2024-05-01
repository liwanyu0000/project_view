import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/components/customize_widget.dart';
import 'package:project_view/pages/home/components/sidebar.dart';
import 'package:project_view/pages/message/view.dart';
import 'package:project_view/utils/router.dart';

import '../../config/constants.dart';
import '../../services/logger.dart';
import '../pages.dart';
import 'components/main_frame/main_frame.dart';
import 'controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  Widget _creatActionBut(
    BuildContext context, {
    String? label,
    IconData? icon,
    Widget Function(bool)? child,
    double? width,
    double? gap,
    required Function() onTap,
  }) =>
      CustomizeWidget(
        icon: icon,
        label: label,
        prefixWidget: child,
        config: CustomizeWidgetConfig(
          gap: gap,
          iconSize: 16,
          width: width,
          iconColor: Theme.of(context).colorScheme.surface,
          hoverBackgroundColor: Colors.grey.withOpacity(0.2),
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    LoggerService.to.t('build', tag: [runtimeType]);
    return Obx(
      () => MainFrame.builder(
        context: context,
        title: _creatActionBut(
          context,
          icon: Icons.home,
          label: kProductName,
          onTap: () => rootRouter.toPage(Pages.front),
        ),
        actions: [
          _creatActionBut(
            context,
            icon: Icons.message_outlined,
            onTap: () => SideBar.open(context, const MessageView()),
          ),
          _creatActionBut(
            context,
            icon: Icons.favorite_border,
            onTap: () => rootRouter.toPage(Pages.favorite),
          ),
          _creatActionBut(
            context,
            icon: Icons.person,
            onTap: () => rootRouter.toPage(Pages.person),
          ),
          const SizedBox(width: 10),
        ],
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.index,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '首页',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.messenger_outline_sharp),
              activeIcon: Icon(Icons.messenger_sharp),
              label: '消息',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: "收藏",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              activeIcon: Icon(Icons.person_2),
              label: "我的",
            ),
          ],
          onTap: controller.changeIndex,
        ),
        body: GetRouterOutlet(
          initialRoute: Pages.front,
          anchorRoute: Pages.home,
        ),
      ),
    );
  }
}
