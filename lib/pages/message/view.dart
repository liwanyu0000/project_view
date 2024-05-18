import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/components/custom_circle_avatar.dart';
import 'package:project_view/pages/components/from_view/communicate_view.dart';
import 'package:project_view/pages/components/mouse_enter_exit.dart';

import '../../utils/utils.dart';
import '../components/from_view/login_register_view.dart';
import '../components/config/config.dart';
import '../components/customize_widget.dart';
import '../home/controller.dart';

class MessageView extends GetView<HomeController> {
  const MessageView({super.key});

  Widget viewBuild(BuildContext context) {
    return Obx(
      () => ListView.separated(
          itemBuilder: (context, index) {
            final item = controller.communicateList[index];
            final user = item.getUserModel(controller.me!.id);
            return GestureDetector(
              onTap: () {
                controller.loadCommunicate(user);
                toCommunicateView(user, Adaptive.isSmall(context));
              },
              child: MouseEnterExit(
                builder: (isHover) => Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isHover
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 4),
                    ],
                  ),
                  child: Row(
                    children: [
                      CustomCircleAvatar(
                        text: user.nickName,
                        avatarImageUrl: user.avatar,
                        radius: iconSizeConfig.middleAvatarIconSize,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        user.nickName,
                        style:
                            TextStyle(fontSize: textSizeConfig.contentTextSize),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: controller.communicateList.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return controller.isLogin
        ? viewBuild(context)
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_circle_outlined,
                  color: labelColor(context.isDarkMode),
                  size: iconSizeConfig.hugAvatarIconSize,
                ),
                const SizedBox(height: 20),
                const Text('你还未登录，请先登录'),
                const SizedBox(height: 20),
                CustomizeWidget(
                  label: '登录/注册',
                  onTap: () => toLogin(Adaptive.isSmall(context)),
                  config: CustomizeWidgetConfig(
                    haveBorder: true,
                    width: 100,
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    borderColor: Theme.of(context).colorScheme.primary,
                    primaryColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ],
            ),
          );
  }
}
