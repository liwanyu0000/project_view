import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/config/config.dart';
import '../../components/customize_widget.dart';
import '../controller.dart';

class LoginRegisterView extends GetView<HomeController> {
  const LoginRegisterView({super.key});

  Widget _creatTextField(BuildContext context, String key,
          {String? hintText}) =>
      TextFormField(
        decoration: decorationConfig(
          context,
          hintText: hintText,
        ),
        initialValue: controller.getEditInfo(key),
        onChanged: (value) => controller.setEditInfo(key, value),
      );

  Widget _verifyCode(BuildContext context) => Row(
        children: [
          Flexible(
            child: TextFormField(
              decoration: decorationConfig(context, hintText: '验证码'),
              onChanged: (value) => controller.setEditInfo('code', value),
            ),
          ),
          GestureDetector(
            onTap: controller.refreshCode,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor(context.isDarkMode)),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Obx(
                () => controller.verifyCode != null
                    ? Image.memory(controller.verifyCode!.img, fit: BoxFit.fill)
                    : Container(
                        height: 40,
                        width: 80,
                        color: labelColor(context.isDarkMode),
                        child: const Icon(Icons.refresh),
                      ),
              ),
            ),
          ),
        ],
      );

  Widget _creatButon(
    BuildContext context, {
    required String label,
    dynamic Function()? onTap,
  }) =>
      CustomizeWidget(
        label: label,
        onTap: onTap,
        config: CustomizeWidgetConfig(
          height: 46,
          haveBorder: true,
          backgroundColor: Theme.of(context).primaryColor,
          borderColor: Theme.of(context).primaryColor,
          primaryColor: Theme.of(context).canvasColor,
        ),
      );

  List<Widget Function(BuildContext context)> get _loginItem => [
        (context) => _creatTextField(context, 'username', hintText: '用户名'),
        (context) => _creatTextField(context, 'password', hintText: '密码'),
        _verifyCode,
        (context) => _creatButon(
              context,
              label: '登录',
              onTap: controller.login,
            ),
        (context) => _creatButon(
              context,
              label: '注册账号',
              onTap: controller.setIsLoginView,
            ),
      ];

  List<Widget Function(BuildContext context)> get _registerItem => [
        (context) => _creatTextField(context, 'username', hintText: '用户名'),
        (context) => _creatTextField(context, 'password', hintText: '密码'),
        (context) => _creatTextField(context, 'sPassword', hintText: '再次确认密码'),
        (context) => _creatTextField(context, 'nickName', hintText: '昵称'),
        (context) => _creatTextField(context, 'email', hintText: '邮箱'),
        (context) => _creatTextField(context, 'phone', hintText: '手机号'),
        (context) => _creatTextField(context, 'addr', hintText: '住址'),
        _verifyCode,
        (context) => _creatButon(
              context,
              label: '注册',
              onTap: controller.register,
            ),
        (context) => _creatButon(
              context,
              label: '返回登录',
              onTap: controller.setIsLoginView,
            ),
      ];

  List<Widget Function(BuildContext context)> get _item =>
      controller.isLoginView ? _loginItem : _registerItem;

  @override
  Widget build(BuildContext context) {
    printInfo(info: "BUILD LOGIN");
    if (controller.isLoginView) controller.refreshCode();
    return Obx(
      () => Form(
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) => _item[index](context),
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemCount: _item.length,
        ),
      ),
    );
  }
}
