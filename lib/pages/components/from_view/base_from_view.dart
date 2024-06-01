import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/components/from_view/edit_info_controller.dart';

import '../../../utils/utils.dart';
import '../../home/controller.dart';
import '../base_dialog.dart';
import '../base_page.dart';
import '../config/config.dart';
import '../customize_widget.dart';
import '../snackbar.dart';

abstract class BaseFromView extends GetView<HomeController> {
  const BaseFromView({super.key});

  EditInfoController get editInfoController => controller.editInfoController;

  Future ok(Future<bool> Function() operate) async =>
      hookExceptionWithSnackbar(() async {
        if (await operate()) {
          if (Adaptive.isSmall()) {
            Get.back();
          } else {
            SmartDialog.dismiss(tag: "FromView");
          }
        }
      });

  Widget creatItem(
    BuildContext context, {
    required String label,
    required Widget child,
  }) =>
      Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              label,
              // textAlign:
              //     Adaptive.isSmall(context) ? TextAlign.start : TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 20),
          Flexible(child: child),
        ],
      );

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
    BuildContext context, {
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    bool obscureText = false,
    int maxLines = 1,
  }) =>
      TextFormField(
        decoration: decorationConfig(
          context,
          hintText: hintText,
        ),
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        obscureText: obscureText,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
      );

  Widget verifyCode(BuildContext context) => Row(
        children: [
          Flexible(
            child: TextFormField(
              decoration: decorationConfig(context, hintText: '验证码'),
              controller: editInfoController.verifyCode,
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
    double? width,
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
          width: width,
        ),
      );
}

Future<dynamic> toFrom(
  BaseFromView child,
  String title, [
  bool isPage = true,
  double? width,
  dynamic Function()? onClose,
]) async =>
    isPage
        ? await Get.to(() => BasePage(
              title: title,
              child: child,
            ))?.then((value) => onClose?.call())
        : await showSmartDialog(
            child: child,
            keepSingle: false,
            width: width,
            dialogTag: "FromView",
            onDismiss: () {
              print(' ----close ------------ ');
              onClose?.call();
            },
          );
