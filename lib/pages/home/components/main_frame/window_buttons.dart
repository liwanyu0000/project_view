import 'package:flutter/material.dart';
import 'package:project_view/pages/components/customize_widget.dart';
import 'package:window_manager/window_manager.dart';

class WindowButtons extends StatefulWidget {
  final bool onlyCloseBtn;
  const WindowButtons({super.key, this.onlyCloseBtn = false});

  @override
  State<WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  bool isMaximized = false;

  void maximizeOrRestore() => windowManager.isMaximized().then((value) {
        value ? windowManager.restore() : windowManager.maximize();
        setState(() => isMaximized = !isMaximized);
      });

  Widget _close() => CustomizeWidget(
        prefixWidget: (_) => const WindowCaptionButtonIcon(
          name: 'images/ic_chrome_close.png',
          color: Colors.white,
        ),
        onTap: windowManager.close,
        config: const CustomizeWidgetConfig(
          backgroundColor: Colors.transparent,
          hoverBackgroundColor: Color(0xffC42B1C),
          width: 52,
        ),
      );
  Widget _other(
    BuildContext context, {
    required dynamic Function() onTap,
    required String name,
  }) =>
      CustomizeWidget(
        onTap: onTap,
        prefixWidget: (_) => WindowCaptionButtonIcon(
          name: name,
          color: Colors.white,
        ),
        config: CustomizeWidgetConfig(
          backgroundColor: Colors.transparent,
          hoverBackgroundColor: Colors.white.withOpacity(0.0605),
          width: 52,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!widget.onlyCloseBtn) ...[
          _other(context,
              onTap: windowManager.minimize,
              name: 'images/ic_chrome_minimize.png'),
          isMaximized
              ? _other(context,
                  onTap: maximizeOrRestore,
                  name: 'images/ic_chrome_unmaximize.png')
              : _other(context,
                  onTap: maximizeOrRestore,
                  name: 'images/ic_chrome_maximize.png'),
        ],
        _close(),
      ],
    );
  }
}
