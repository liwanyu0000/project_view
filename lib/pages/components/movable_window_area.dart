import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import '../../utils/adaptive.dart';

class MovableWindowArea extends StatelessWidget {
  /// 是否自动占满剩余空间
  final bool expand;
  final Widget? child;

  /// 默认禁用双击最大化，如果需要启用，需要传入: () => appWindow.maximizeOrRestore()
  final void Function()? onDoubleTap;

  /// 可移动窗口区域适配器(桌面: MoveWindow，移动端: Container)
  const MovableWindowArea({
    super.key,
    this.expand = false,
    this.child,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    final item = Adaptive.isDesktop
        ? MoveWindow(onDoubleTap: onDoubleTap ?? () {}, child: child)
        : Container(child: child);
    return expand ? Expanded(child: item) : item;
  }
}
