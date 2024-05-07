import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/components/From_view.dart/login_register_view.dart';

import '../../utils/utils.dart';
import '../components/config/config.dart';
import '../components/customize_widget.dart';
import 'base_controller.dart';

abstract class BaseView<T extends BaseController> extends GetView<T> {
  const BaseView({super.key});

  Widget viewBuild(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLogin
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
            ),
    );
  }
}
