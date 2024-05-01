import 'package:flutter/material.dart';

import 'main_frame.dart';

/// 手机, 网页
class SmallMainFrame extends MainFrame {
  final Widget bottomNavigationBar;
  final Widget? floatingActionButton;
  const SmallMainFrame({
    super.key,
    required super.body,
    required this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}
