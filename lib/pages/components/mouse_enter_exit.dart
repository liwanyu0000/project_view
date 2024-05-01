import 'package:flutter/material.dart';

class MouseEnterExit extends StatefulWidget {
  final Widget Function(bool isHover) builder;
  final bool enable;
  final MouseCursor cursor;
  final Duration? duration;
  const MouseEnterExit(
      {required this.builder,
      this.enable = true,
      this.cursor = MouseCursor.defer,
      this.duration,
      super.key});

  @override
  State<MouseEnterExit> createState() => _MouseEnterExitState();
}

class _MouseEnterExitState extends State<MouseEnterExit> {
  bool _isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: widget.cursor,
        onEnter: widget.enable
            ? (event) => mounted ? setState(() => _isHover = true) : null
            : null,
        onExit: widget.enable
            ? widget.duration == null
                ? mounted
                    ? (_) => setState(() => _isHover = false)
                    : null
                : (event) => Future.delayed(widget.duration ?? const Duration(),
                    () => mounted ? setState(() => _isHover = false) : null)
            : null,
        child: widget.builder(_isHover));
  }
}
