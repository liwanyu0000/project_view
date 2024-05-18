import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../snackbar.dart';
import 'base_from_view.dart';

class _LoginRegisterView extends BaseFromView {
  const _LoginRegisterView();

  List<Widget> _loginItem(BuildContext context, GlobalKey<FormState> formKey) {
    return [
      creatTextField(context,
          controller: editInfoController.userName,
          hintText: '用户名',
          validator: (value) => value!.isEmpty ? '用户名不能为空' : null),
      creatTextField(context,
          controller: editInfoController.password,
          hintText: '密码',
          obscureText: true,
          validator: (value) => value!.isEmpty ? '密码不能为空' : null),
      verifyCode(context),
      creatButon(
        context,
        label: '登录',
        onTap: () => ok(
          () async {
            if (!(formKey.currentState?.validate() ?? true)) {
              throw '请检查输入';
            }
            await controller.login();
            editInfoController.cleanLogin();
            return controller.isLogin;
          },
        ),
      ),
      creatButon(
        context,
        label: '注册账号',
        onTap: controller.setIsLoginView,
      ),
    ];
  }

  List<Widget> _registerItem(
      BuildContext context, GlobalKey<FormState> formKey) {
    return [
      creatTextField(context,
          controller: editInfoController.userName,
          hintText: '用户名',
          validator: (value) => value!.isEmpty ? '用户名不能为空' : null),
      creatTextField(context,
          controller: editInfoController.password,
          hintText: '密码',
          obscureText: true,
          validator: (value) => value!.isEmpty ? '密码不能为空' : null),
      creatTextField(context,
          controller: editInfoController.secondPassword,
          hintText: '再次确认密码',
          obscureText: true,
          validator: (value) => value!.isEmpty ? '确认密码不能为空' : null),
      creatTextField(context,
          controller: editInfoController.nickName, hintText: '昵称'),
      creatTextField(context,
          controller: editInfoController.emails, hintText: '邮箱'),
      creatTextField(context,
          controller: editInfoController.phones, hintText: '手机号'),
      verifyCode(context),
      creatButon(
        context,
        label: '注册',
        onTap: () => hookExceptionWithSnackbar(() async {
          if (!(formKey.currentState?.validate() ?? true)) {
            throw '请检查输入';
          }
          bool success = await controller.register();
          if (!success) throw '注册失败';
          editInfoController.cleanRegister();
          controller.setIsLoginView();
        }),
      ),
      creatButon(
        context,
        label: '返回登录',
        onTap: controller.setIsLoginView,
      ),
    ];
  }

  @override
  List<Widget> creatItems(BuildContext context, GlobalKey<FormState> formKey) =>
      (controller.isLoginView ? _loginItem : _registerItem)(context, formKey);

  @override
  Widget build(BuildContext context) {
    if (controller.isLoginView) controller.refreshCode();
    return Obx(() => creatFrom(context));
  }
}

Future<dynamic> toLogin([bool isPage = true]) async =>
    toFrom(const _LoginRegisterView(), '登录/注册', isPage);
