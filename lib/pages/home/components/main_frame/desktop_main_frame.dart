import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../../../../config/constants.dart';
import 'window_buttons.dart';
import 'main_frame.dart';

/// 桌面
class DesktopMainFrame extends MainFrame {
  final Color? desktopBorderColor;
  final double? desktopBorderWidth;
  const DesktopMainFrame({
    super.key,
    required super.body,
    super.actions,
    super.title,
    super.leading,
    super.ridgetWidth,
    this.desktopBorderColor,
    this.desktopBorderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return DragToResizeArea(
      child:
          // WindowBorder(
          //   color: desktopBorderColor ?? Colors.transparent,
          //   width: desktopBorderWidth,
          //   child:
          Scaffold(
        appBar: AppBar(
          toolbarHeight: titleBarHeight,
          title: SizedBox(
            height: titleBarHeight,
            child: DragToMoveArea(
              child: Row(children: [
                leading ?? const SizedBox(),
                title ?? const SizedBox(),
                const Expanded(child: SizedBox(width: 10)),
                ...actions,
                const WindowButtons()
              ]),
            ),
          ),
        ),
        body: Row(
          children: [
            Expanded(child: body),
            SizedBox(width: ridgetWidth),
          ],
        ),
      ),
    );
  }
}
