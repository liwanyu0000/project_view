import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'config/config.dart';

class RotateIcon extends StatefulWidget {
  const RotateIcon({
    super.key,
    this.iconData,
    this.color,
    this.isExpanded = false,
    this.size = 24.0,
    this.begin = 0,
    this.end = .5,
  });

  final bool isExpanded;
  final double size;
  final double? begin;
  final double? end;
  final IconData? iconData;
  final Color? color;

  @override
  State<RotateIcon> createState() => _RotateIconState();
}

class _RotateIconState extends State<RotateIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;

  late Animatable<double> _iconTurnTween;

  @override
  void initState() {
    super.initState();
    _iconTurnTween = Tween<double>(begin: widget.begin, end: widget.end)
        .chain(CurveTween(curve: Curves.fastOutSlowIn));
    _controller =
        AnimationController(duration: kThemeAnimationDuration, vsync: this);
    _iconTurns = _controller.drive(_iconTurnTween);
    if (widget.isExpanded) {
      _controller.value = math.pi;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RotateIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns,
      child: Icon(
        widget.iconData ?? Icons.expand_more,
        size: widget.size,
        color: widget.color ?? labelColor(context.isDarkMode),
      ),
    );
  }
}
