import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';
import '../base_dialog.dart';
import '../config/config.dart';
import '../operate_botton.dart';

Future<void> showEditDialog(
  BuildContext context, {
  required String title,
  double? width,
  double? height,
  String? dialogTag,
  TextEditingController? textEditingController,
  String? hintText,
  String? errorHintText,
  int maxLines = 1,
  bool Function(String? value)? validator,
  dynamic Function(String value)? operate,
  Widget? prefixIcon,
  TextInputType? keyboardType,
  EdgeInsetsGeometry? contentPadding,
}) async {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController textController =
      textEditingController ?? TextEditingController();
  TextFormField textFormField(BuildContext context, [void Function()? fn]) =>
      TextFormField(
        autofocus: true,
        mouseCursor: MaterialStateMouseCursor.textable,
        decoration: decorationConfig(
          context,
          prefixIcon: prefixIcon,
          hintText: hintText,
          contentPadding: contentPadding ?? const EdgeInsets.all(10),
        ),
        style: TextStyle(fontSize: textSizeConfig.primaryTextSize),
        controller: textController,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if ((validator?.call(value) ?? (value ?? '').isEmpty)) {
            fn?.call();
            return errorHintText ?? 'Enter at least one character'.tr;
          } else {
            return null;
          }
        },
      );
  await showSmartDialog(
    width: width ?? min(Adaptive.getWidth(context) * .9, 420),
    height: height,
    dialogTag: dialogTag,
    child: Column(
      children: [
        textFormField(context),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(child: SizedBox()),
            creatCancelButton(() => SmartDialog.dismiss(tag: dialogTag)),
            const SizedBox(width: 10),
            creatOkButton(() {
              if (!formKey.currentState!.validate()) return;
              operate?.call(textController.text);
              SmartDialog.dismiss(tag: dialogTag);
            }),
          ],
        )
      ],
    ),
  );
}
