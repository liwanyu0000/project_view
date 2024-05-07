import 'package:flutter/material.dart';

import 'base_from_view.dart';

class ChangePwdView extends BaseFromView {
  const ChangePwdView({super.key});
  @override
  List<Widget> creatItem(BuildContext context, GlobalKey<FormState> formKey) =>
      [
        creatTextField(context, 'oldPwd',
            hintText: '旧密码',
            obscureText: true,
            validator: (value) => value!.isEmpty ? '旧密码不能为空' : null),
        creatTextField(context, 'newPwd',
            hintText: '新密码',
            obscureText: true,
            validator: (value) => value!.isEmpty ? '新密码不能为空' : null),
        creatTextField(context, 'sNewPwd',
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
            return await controller.changePwd();
          }),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    if (controller.isLoginView) controller.refreshCode();
    return creatFrom(context);
  }
}

Future<dynamic> toChangPwd([bool isPage = true]) async =>
    toFrom(const ChangePwdView(), '修改密码', isPage);
