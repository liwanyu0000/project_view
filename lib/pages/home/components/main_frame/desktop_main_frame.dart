import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:project_view/pages/home/components/movable_window_area.dart';

import '../window_buttons.dart';
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
    return WindowBorder(
      color: desktopBorderColor ?? Colors.transparent,
      width: desktopBorderWidth,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: appWindow.titleBarHeight,
          title: SizedBox(
            height: appWindow.titleBarHeight,
            child: Row(children: [
              MovableWindowArea(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      leading ?? const SizedBox(),
                      title ?? const SizedBox(),
                      const Expanded(child: SizedBox(width: 10)),
                      ...actions,
                    ],
                  ),
                ),
              ),
              const WindowButtons()
            ]),
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
