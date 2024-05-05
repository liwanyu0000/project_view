import 'package:flutter/material.dart';

import 'config/config.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    super.key,
    this.text = ' ',
    this.isAvatar = false,
    this.radius = 1,
    this.backgroundColor,
    this.fontSize,
    this.tooltip,
    this.avatarImageUrl,
    this.padding,
    this.onTap,
    this.cursor = SystemMouseCursors.click,
  });

  final bool isAvatar;
  final double radius;
  final Color? backgroundColor;
  final String text;
  final double? fontSize;
  final String? tooltip;
  final String? avatarImageUrl;
  final EdgeInsets? padding;
  final void Function()? onTap;
  final MouseCursor cursor;

  @override
  Widget build(BuildContext context) {
    return avatarImageUrl != null
        ? CircleAvatar(
            radius: radius,
            backgroundImage: NetworkImage(avatarImageUrl!),
          )
        : CircleAvatar(
            radius: radius,
            backgroundColor: backgroundColor ?? getAvatarColor(text),
            child: Padding(
              padding: padding ?? const EdgeInsets.only(left: .5),
              child: Center(
                child: Text(
                  text
                      .split(' ')
                      .where((e) => e.isNotEmpty)
                      .take(2)
                      .map((e) => e[0].toUpperCase())
                      .join(),
                  style: TextStyle(
                      fontSize: fontSize ?? textSizeConfig.assistTextSize),
                ),
              ),
            ),
          );
  }
}
