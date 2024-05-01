import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class MovableWindowArea extends StatelessWidget {
  /// 是否自动占满剩余空间
  final bool expand;
  final Widget? child;

  /// 默认启用双击最大化
  final bool disableOnDoubleTap;

  /// 可移动窗口区域适配器(桌面: MoveWindow，移动端: Container)
  const MovableWindowArea({
    super.key,
    this.expand = true,
    this.child,
    this.disableOnDoubleTap = false,
  });

  @override
  Widget build(BuildContext context) {
    final item = MoveWindow(
        onDoubleTap:
            disableOnDoubleTap ? () {} : () => appWindow.maximizeOrRestore(),
        child: child);
    return expand ? Expanded(child: item) : item;
  }
}
