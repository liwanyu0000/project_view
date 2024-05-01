import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseListItem extends StatelessWidget {
  final List<Widget> Function(bool isSmall, double maxWidth)? builder;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final bool isHover;
  const BaseListItem({
    super.key,
    this.builder,
    this.padding,
    this.margin,
    this.isHover = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constains) {
      bool isSmall = constains.maxWidth < 600;
      return Container(
        height: 44,
        padding: padding ?? const EdgeInsets.only(left: 20, right: 20),
        margin: margin,
        decoration: BoxDecoration(
          color: isHover
              ? context.isDarkMode
                  ? const Color(0xff1c1d2a)
                  : const Color(0xfffbfbfc)
              : Theme.of(context).colorScheme.background,
        ),
        child: Row(children: builder?.call(isSmall, constains.maxWidth) ?? []),
      );
    });
  }
}
