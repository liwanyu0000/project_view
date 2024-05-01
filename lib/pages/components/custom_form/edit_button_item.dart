import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/config.dart';
import '../customize_widget.dart';
import 'edit_item_model.dart';

class EditButtonItem extends EditItemModel {
  final String buttonText;
  final void Function()? onTap;
  final IconData? icon;
  final double? height;
  const EditButtonItem({
    super.key,
    super.label,
    super.cellVerticalAlignment,
    super.labelPadding,
    super.contentPadding,
    super.flexible = false,
    required this.buttonText,
    this.onTap,
    this.icon,
    this.height,
  });

  EdgeInsetsGeometry _contentPadding(String state) {
    return const EdgeInsets.symmetric(vertical: 5);
  }

  @override
  Widget builder(BuildContext context, String state) => Padding(
        padding: contentPadding?.call(state) ?? _contentPadding(state),
        child: CustomizeWidget(
          icon: icon,
          label: buttonText,
          onTap: onTap,
          config: CustomizeWidgetConfig(
            height: height ?? 30,
            primaryColor: okMarkColor(context.isDarkMode),
            borderColor: okMarkColor(context.isDarkMode),
            haveBorder: true,
            padding: const EdgeInsets.only(left: 10, right: 10),
          ),
        ),
      );
}
