import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../utils/utils.dart';
import 'desktop_main_frame.dart';
import 'normal_main_frame.dart';
import 'small_main_frame.dart';

abstract class MainFrame extends StatelessWidget {
  final Widget body;
  final List<Widget> actions;
  final Widget? title;
  final Widget? leading;
  final double ridgetWidth;
  const MainFrame({
    super.key,
    required this.body,
    this.actions = const [],
    this.title,
    this.leading,
    this.ridgetWidth = 0,
  });

  factory MainFrame.builder({
    Key? key,
    required BuildContext context,
    required Widget body,
    required Widget bottomNavigationBar,
    Widget? floatingActionButton,
    List<Widget> actions = const [],
    Widget? title,
    Widget? leading,
    double ridgetWidth = 0,
  }) {
    if (Adaptive.isDesktop) {
      return DesktopMainFrame(
        key: key,
        body: body,
        actions: actions,
        title: title,
        leading: leading,
      );
    }
    if (Adaptive.isSmall(context)) {
      return SmallMainFrame(
        key: key,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      );
    }
    return NormalMainFrame(
      key: key,
      body: body,
      actions: actions,
      title: title,
      leading: leading,
    );
  }
}
