import 'package:flutter/material.dart';

class Selector extends StatelessWidget {
  final int index;
  final List<Widget Function(Widget? child)> wraps;
  final Widget? child;

  /// 返回wraps[index](child), 如果index超出wraps范围, 返回child
  const Selector({
    super.key,
    required this.index,
    required this.wraps,
    this.child,
  });

  /// 返回enabled ? wrap(child) : child
  Selector.single({
    Key? key,
    required bool enabled,
    required Widget Function(Widget? child) wrap,
    Widget? child,
  }) : this(key: key, index: enabled ? 0 : -1, wraps: [wrap], child: child);

  @override
  Widget build(BuildContext context) {
    return index >= 0 && index < wraps.length
        ? wraps[index](child)
        : (child ?? Container());
  }
}
