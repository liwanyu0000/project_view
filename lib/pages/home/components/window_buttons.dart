import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WindowButtons extends StatefulWidget {
  final bool onlyCloseBtn;
  const WindowButtons({super.key, this.onlyCloseBtn = false});

  @override
  State<WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final indicatorColor = Theme.of(context).indicatorColor;
    final btnColors = WindowButtonColors(
      iconNormal: indicatorColor.withOpacity(context.isDarkMode ? 0.6 : 0.8),
      iconMouseOver: indicatorColor,
      iconMouseDown: indicatorColor,
      mouseOver: Colors.grey.withOpacity(0.2),
      mouseDown: Colors.grey.withOpacity(0.3),
    );
    final closeBtnColors = WindowButtonColors(
      iconNormal: indicatorColor.withOpacity(context.isDarkMode ? 0.8 : 1.0),
      iconMouseOver: indicatorColor,
      iconMouseDown: indicatorColor,
      mouseOver: Colors.red,
      mouseDown: Colors.red.withOpacity(0.6),
    );
    return Row(
      children: [
        if (!widget.onlyCloseBtn) MinimizeWindowButton(colors: btnColors),
        if (!widget.onlyCloseBtn)
          appWindow.isMaximized
              ? RestoreWindowButton(
                  colors: btnColors, onPressed: maximizeOrRestore)
              : MaximizeWindowButton(
                  colors: btnColors, onPressed: maximizeOrRestore),
        CloseWindowButton(colors: closeBtnColors),
      ],
    );
  }
}
