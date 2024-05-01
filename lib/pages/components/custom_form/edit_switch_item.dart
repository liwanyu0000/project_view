import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/config.dart';
import 'edit_item_model.dart';

class EditSwitchItem extends EditItemModel {
  final bool value;
  final void Function(bool)? onChanged;
  final double? height;
  final double? scale;

  EditSwitchItem({
    super.key,
    super.label,
    super.cellVerticalAlignment,
    super.labelPadding,
    super.contentPadding,
    super.readOnly,
    super.flexible = false,
    required this.value,
    this.onChanged,
    this.height,
    this.scale,
  });

  EdgeInsetsGeometry _contentPadding(String state) {
    return const EdgeInsets.symmetric(vertical: 0);
  }

  @override
  Widget builder(BuildContext context, String state) {
    return Container(
      height: height ?? 36,
      padding: contentPadding?.call(state) ?? _contentPadding(state),
      child: Transform.scale(
        scale: scale ?? .8,
        child: Switch(
          value: value,
          onChanged: state == 'READ' || state == 'RMIDDLE' ? null : onChanged,
          thumbColor: MaterialStateColor.resolveWith((states) => Colors.white),
          trackColor: MaterialStateColor.resolveWith((states) =>
              value ? Colors.green : borderColor(context.isDarkMode)),
          trackOutlineColor: MaterialStateColor.resolveWith((states) =>
              value ? Colors.green : borderColor(context.isDarkMode)),
        ),
      ),
    );
  }
}
