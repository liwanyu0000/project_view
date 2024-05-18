import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';
import '../components/from_view/login_register_view.dart';
import '../components/config/config.dart';
import '../components/customize_widget.dart';
import '../home/controller.dart';

class MessageView extends GetView<HomeController> {
  const MessageView({super.key});

  Widget viewBuild(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(
          () => ListView.separated(
              itemBuilder: (context, index) {
                final item = controller.communicateList[index];
                return SizedBox(
                  height: 20,
                  child: Text("${item.content}xxxx"),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: controller.communicateList.length),
        ));
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
