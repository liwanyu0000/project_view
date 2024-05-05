import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../utils/adaptive.dart';
import 'config/config.dart';

class BaseDialog extends StatelessWidget {
  const BaseDialog({
    super.key,
    this.child,
    this.contentPadding,
    this.dialogMargin,
    this.dialogPadding,
    this.boxShadow,
    this.decoration,
    this.width,
    this.height,
    this.flexible = false,
  });

  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? dialogMargin;
  final EdgeInsetsGeometry? dialogPadding;
  final List<BoxShadow>? boxShadow;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final Widget? child;
  final bool flexible;
  // ! 注意：当flexible为false时，height属性为最大高度
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: width ?? max(Adaptive.getWidth(context) * .25, 360),
        maxHeight: height ?? Adaptive.getHeight(context) * .7,
      ),
      decoration: decoration ??
          BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: boxShadow ?? boxShadowConfig(),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
      margin: dialogMargin,
      padding: dialogPadding ?? const EdgeInsets.all(25),
      child: child,
    );
  }
}

dynamic showSmartDialog({
  Widget? child,
  EdgeInsetsGeometry? contentPadding,
  EdgeInsetsGeometry? dialogMargin,
  EdgeInsetsGeometry? dialogPadding,
  final List<BoxShadow>? boxShadow,
  Decoration? decoration,
  Alignment? alignment,
  Color? maskColor,
  double? width,
  double? height,
  bool flexible = false,
  bool clickMaskDismiss = true,
  bool keepSingle = true,
  bool usePenetrate = false,
  String? dialogTag,
  void Function()? onDismiss,
  void Function()? onMask,
  Rect? ignoreArea,
}) async {
  await SmartDialog.show(
    tag: dialogTag,
    keepSingle: keepSingle,
    maskColor: maskColor,
    usePenetrate: usePenetrate,
    alignment: alignment ?? Alignment.center,
    clickMaskDismiss: clickMaskDismiss,
    onDismiss: onDismiss,
    onMask: onMask,
    ignoreArea: ignoreArea,
    builder: (context) => BaseDialog(
      contentPadding: contentPadding,
      dialogMargin: dialogMargin,
      dialogPadding: dialogPadding,
      boxShadow: boxShadow,
      decoration: decoration,
      width: width,
      height: height,
      flexible: flexible,
      child: child,
    ),
  );
}
