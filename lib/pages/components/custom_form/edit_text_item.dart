import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../base_dialog.dart';
import '../config/config.dart';
import 'custom_form.dart';
import 'edit_item_model.dart';

class EditTextFieldItem extends EditItemModel {
  final String? hintText;
  final String? Function(String? text)? validator;
  final bool error;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final int maxLines;
  final void Function(String value)? onChanged;
  final Widget? textSuffixIcon;

  EditTextFieldItem({
    super.key,
    super.label,
    super.cellVerticalAlignment,
    super.labelPadding,
    super.contentPadding,
    super.readOnly,
    super.editOnTap,
    super.readOnTap,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.hintText,
    this.validator,
    this.textSuffixIcon,
    this.maxLines = 1,
    this.error = false,
    this.obscureText = false,
  });

  TextStyle style = TextStyle(
    fontSize: textSizeConfig.primaryTextSize,
    color: Theme.of(Get.context!).colorScheme.onSurface,
  );
  TextStyle hintStyle = TextStyle(
    fontSize: textSizeConfig.primaryTextSize,
    color: labelColor(Get.context!.isDarkMode),
  );

  creatEdit(BuildContext context, String state,
      [bool canRequestFocus = false, bool notHeight = false]) {
    if (state == 'EMIDDLE') {
      return SizedBox(
        height: 16 + 1 * 20 + (error ? 24 : 0),
        child: TextFormField(
          maxLines: 1,
          style: style,
          enabled: false,
          textAlign: TextAlign.end,
          obscureText: obscureText,
          decoration: decorationConfig(
            context,
            hintText: hintText ?? '请输入',
            hintStyle: hintStyle,
            contentPadding: const EdgeInsets.only(top: 1, bottom: 1),
          ),
          controller: controller,
          validator: validator,
        ),
      );
    } else if (state == 'RMIDDLE') {
      return Text(
        controller?.text ?? '',
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
      );
    } else if (state == 'READ') {
      return SingleChildScrollView(
        child: Text(
          controller?.text ?? '',
          style: style,
        ),
      );
    } else {
      FocusNode focusNode = FocusNode();
      if (canRequestFocus) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          focusNode.requestFocus();
        });
      }
      return SizedBox(
        height: notHeight ? null : 16 + maxLines * 20 + (error ? 24 : 0),
        child: TextFormField(
          focusNode: focusNode,
          maxLines: maxLines,
          style: style,
          onChanged: onChanged,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          decoration: decorationConfig(
            context,
            hintText: hintText ?? '请输入',
            hintStyle: hintStyle,
            contentPadding: const EdgeInsets.all(10),
            suffixIcon: textSuffixIcon,
          ),
          controller: controller,
          validator: validator,
        ),
      );
    }
  }

  @override
  Widget get suffixIcon =>
      textSuffixIcon ??
      (super.readOnly ?? false ? const SizedBox() : creatSuffixIcon());

  EdgeInsets _contentPadding(String state) {
    if (state == 'EMIDDLE') {
      return const EdgeInsets.symmetric(vertical: 5);
    } else if (state == 'RMIDDLE') {
      return const EdgeInsets.symmetric(vertical: 12);
    } else {
      return const EdgeInsets.all(0);
    }
  }

  @override
  Widget builder(BuildContext context, String state) => Padding(
      padding: contentPadding?.call(state) ?? _contentPadding(state),
      child: creatEdit(context, state));

  void _editOnTap() => showSmartDialog(
        title: '编辑',
        child: creatEdit(Get.context!, 'EDIT', true, true),
        actions: [],
      );

  void _readOnTap() => showSmartDialog(
        title: '查看',
        child: creatEdit(Get.context!, 'READ'),
        actions: [],
      );

  @override
  void Function()? get editOnTap =>
      super.editOnTap ?? super.editOnTap ?? _editOnTap;

  @override
  void Function()? get readOnTap => super.readOnTap ?? _readOnTap;
}
