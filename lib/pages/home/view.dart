import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/components/from_view/change_pwd_view.dart';
import 'package:project_view/pages/components/from_view/house_info_view.dart';
import 'package:project_view/pages/components/base_popmenu.dart';
import 'package:project_view/pages/components/custom_circle_avatar.dart';
import 'package:project_view/pages/components/customize_widget.dart';
import 'package:project_view/pages/components/from_view/login_register_view.dart';
import 'package:project_view/pages/components/from_view/users_manage_view.dart';
import 'package:project_view/pages/components/snackbar.dart';
import 'package:project_view/pages/home/components/sidebar.dart';
import 'package:project_view/pages/message/view.dart';
import 'package:project_view/utils/router.dart';
import 'package:project_view/utils/utils.dart';

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
    String? tooltip,
    Function()? onTap,
  }) =>
      CustomizeWidget(
        icon: icon,
        label: label,
        prefixWidget: child,
        tooltip: tooltip,
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
          tooltip: '主页',
          label: kProductName,
          onTap: () => rootRouter.toPage(Pages.front),
        ),
        actions: [
          if (controller.me?.isAdmin ?? false)
            _creatActionBut(
              context,
              label: '用户管理',
              onTap: () => toUsersManageView(Adaptive.isSmall()),
            ),
          if (controller.me?.canPublish ?? false)
            _creatActionBut(
              context,
              label: '发布房源',
              onTap: () => toHouseInfo(false),
            ),
          if (controller.isLogin)
            _creatActionBut(
              context,
              icon: Icons.message_outlined,
              tooltip: '消息',
              onTap: () {
                // Get.lazyPut(() => MessageController());
                SideBar.open(context, const MessageView());
              },
            ),
          if (controller.isLogin)
            _creatActionBut(
              context,
              icon: Icons.article,
              tooltip: '发布',
              onTap: () => rootRouter.toPage(Pages.favorite),
            ),
          if (!controller.isLogin)
            _creatActionBut(
              context,
              label: '登录/注册',
              onTap: () => toLogin(false),
            ),
          if (controller.isLogin)
            PopMenu.item(
              item: [
                CustomizeWidget.menuItem(
                  icon: Icons.person_2_outlined,
                  label: "个人信息",
                  onTap: () => rootRouter.toPage(Pages.person),
                ),
                CustomizeWidget.menuItem(
                  icon: Icons.lock_outlined,
                  label: "修改密码",
                  onTap: () => toChangPwd(false),
                ),
                CustomizeWidget.menuItem(
                  icon: Icons.logout,
                  label: "退出登录",
                  onTap: controller.logout,
                )
              ],
              child: _creatActionBut(
                context,
                child: (_) => CustomCircleAvatar(
                  text: controller.me!.nickName,
                  avatarImageUrl: controller.me?.avatar,
                  radius: 12,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(width: 10),
        ],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!controller.isLogin) {
              toLogin(true);
            } else {
              if (controller.me?.canPublish ?? false) {
                toHouseInfo(true);
              } else {
                snackbar('您没有发布权限');
              }
            }
          },
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
              activeIcon: Icon(Icons.article),
              label: "发布",
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
