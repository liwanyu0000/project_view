import 'package:flutter/material.dart';

import 'base_from_view.dart';

class _ChangePwdView extends BaseFromView {
  const _ChangePwdView();
  @override
  List<Widget> creatItems(BuildContext context, GlobalKey<FormState> formKey) {
    return [
      creatTextField(context,
          controller: editInfoController.oldPassword,
          hintText: '旧密码',
          obscureText: true,
          validator: (value) => value!.isEmpty ? '旧密码不能为空' : null),
      creatTextField(context,
          controller: editInfoController.password,
          hintText: '新密码',
          obscureText: true,
          validator: (value) => value!.isEmpty ? '新密码不能为空' : null),
      creatTextField(context,
          controller: editInfoController.secondPassword,
          hintText: '确认密码',
          obscureText: true,
          validator: (value) => value!.isEmpty ? '确认密码不能为空' : null),
      verifyCode(context),
      creatButon(
        context,
        label: '修改密码',
        onTap: () => ok(() async {
          if (!(formKey.currentState?.validate() ?? true)) {
            throw '请检查输入';
          }
          bool res = await controller.changePwd();
          editInfoController.clearPwd();
          return res;
        }),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (controller.isLoginView) controller.refreshCode();
    return creatFrom(context);
  }
}

Future<dynamic> toChangPwd([bool isPage = true]) async =>
    toFrom(const _ChangePwdView(), '修改密码', isPage);
