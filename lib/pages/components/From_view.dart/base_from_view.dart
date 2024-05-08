import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';
import '../../home/controller.dart';
import '../base_dialog.dart';
import '../base_page.dart';
import '../config/config.dart';
import '../customize_widget.dart';
import '../snackbar.dart';

abstract class BaseFromView extends GetView<HomeController> {
  const BaseFromView({super.key});

  Future ok(Future<bool> Function() operate) async =>
      hookExceptionWithSnackbar(() async {
        if (await operate()) {
          controller.cleanEditInfo();
          if (Adaptive.isSmall()) {
            Get.back();
          } else {
            SmartDialog.dismiss();
          }
        }
      });

  List<Widget> creatItems(BuildContext context, GlobalKey<FormState> formKey);

  Widget creatFrom(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    List<Widget> item = creatItems(context, formKey);
    return Form(
      key: formKey,
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) => item[index],
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: item.length,
      ),
    );
  }

  Widget creatTextField(
    BuildContext context,
    String key, {
    String? hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool obscureText = false,
    int maxLines = 1,
  }) =>
      TextFormField(
        decoration: decorationConfig(
          context,
          hintText: hintText,
        ),
        keyboardType: keyboardType,
        validator: validator,
        initialValue: controller.getEditInfo(key),
        obscureText: obscureText,
        maxLines: maxLines,
        onChanged: (value) => controller.setEditInfo(key, value),
      );

  Widget verifyCode(BuildContext context) => Row(
        children: [
          Flexible(
            child: TextFormField(
              decoration: decorationConfig(context, hintText: '验证码'),
              onChanged: (value) => controller.setEditInfo('code', value),
              validator: (value) => value!.isEmpty ? '验证码不能为空' : null,
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

  Widget creatButon(
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
}

Future<dynamic> toFrom(BaseFromView child, String title,
        [bool isPage = true, double? width]) async =>
    isPage
        ? await Get.to(() => BasePage(
              title: title,
              child: child,
            ))
        : await showSmartDialog(child: child, keepSingle: false, width: width);
