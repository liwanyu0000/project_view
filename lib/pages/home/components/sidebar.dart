import 'dart:async';
import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../../utils/utils.dart';
import '../../components/base_dialog.dart';

class SideBar {
  static bool isShow = false;
  static bool _isfixed = false;
  static Future close() async {
    await SmartDialog.dismiss(tag: dialogTag);
    isShow = false;
  }

  static void routerClose() {
    if (_isfixed) return;
    close();
  }

  static double rightWidth(BuildContext context) =>
      Adaptive.isSmall(context) ? Adaptive.getWidth(context) * .78 : 320;

  static void setFixed() => _isfixed = !_isfixed;

  static void open(BuildContext context, Widget child, [Widget? title]) {
    if (isShow) return;
    final double topHeight =
        (Adaptive.isDesktop ? appWindow.titleBarHeight : kToolbarHeight) +
            1 +
            // ignore: deprecated_member_use
            MediaQueryData.fromView(window).padding.top;
    showSmartDialog(
      flexible: true,
      usePenetrate: !Adaptive.isSmall(context),
      keepSingle: false,
      clickMaskDismiss: false,
      onMask: () {
        if (_isfixed) return;
        close();
      },
      cancel: close,
      height: Adaptive.getHeight(context),
      width: rightWidth(context),
      titleWidget: title,
      child: child,
      actions: [],
      alignment: Alignment.centerRight,
      dialogTag: dialogTag,
      ignoreArea: Rect.fromLTRB(0, topHeight, 0, 0),
    );
    isShow = true;
  }

  static String dialogTag = "rightDialog";
}
