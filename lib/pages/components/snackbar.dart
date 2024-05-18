import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:project_view/config/constants.dart';
import 'package:project_view/utils/utils.dart';

Future<dynamic> snackbar(
  String message, {
  BuildContext? context,
  Alignment? alignment,
  Color? textColor,
  Color? backgroundColor,
  Duration? duration = const Duration(seconds: 2),
  EdgeInsetsGeometry? margin,
  Widget Function(AnimationController controller, Widget child,
          AnimationParam animationParam)?
      animationBuilder,
  Offset offset = const Offset(0, 0),
}) async {
  final effectiveContext = context ?? Get.context;
  if (effectiveContext == null) return null;

  return SmartDialog.showNotify(
    keepSingle: true,
    msg: '',
    alignment: alignment ?? Alignment.topCenter,
    notifyType: NotifyType.error,
    displayTime: duration,
    animationTime: const Duration(milliseconds: 600),
    animationType: SmartAnimationType.fade,
    animationBuilder: animationBuilder,
    builder: (context) => Transform.translate(
      offset: offset,
      child: Container(
        constraints: const BoxConstraints(minWidth: 300),
        margin: margin ?? const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: backgroundColor ?? const Color(0xFFFFD9D9),
        ),
        child: Text(
          message,
          style: TextStyle(
              color: textColor ?? Theme.of(effectiveContext).colorScheme.error,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

Future<void> hookExceptionWithSnackbar(
  Function fn, {
  Function? exceptionHandle,
  Duration? duration = const Duration(seconds: 2),
  Duration? delay,
  Alignment? alignment,
  EdgeInsetsGeometry? margin,
  Widget Function(AnimationController controller, Widget child,
          AnimationParam animationParam)?
      animationBuilder,
  Offset? offset,
}) async {
  try {
    if (fn is Future Function()) {
      await fn();
    } else {
      fn();
    }
  } catch (e) {
    if (delay != null) await Future.delayed(delay);
    if (exceptionHandle != null) exceptionHandle.call();
    snackbar(e.toString(),
        duration: duration,
        alignment: alignment,
        margin: margin,
        animationBuilder: animationBuilder,
        offset: offset ??
            Offset(
              0,
              Adaptive.isSmall() ? kBottomNavigationBarHeight : titleBarHeight,
            ));
  }
}
