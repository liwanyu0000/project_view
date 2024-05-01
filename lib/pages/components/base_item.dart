import 'package:flutter/material.dart';

import 'mouse_enter_exit.dart';
import 'base_card.dart';
import 'base_list_item.dart';

class BaseItem extends StatelessWidget {
  final bool isCard;
  final void Function()? onTap;

  /// card 参数
  final Color? backgroundColor;
  final double? leftWidth;
  final Widget? head;
  final Widget? body;
  final Widget? tail;
  final EdgeInsetsGeometry? cardPadding;
  final EdgeInsetsGeometry? cardMargin;

  /// list item 参数
  final List<Widget> Function(bool isSmall, double maxWidth)? builder;
  final EdgeInsetsGeometry? listItemPadding;
  final EdgeInsetsGeometry? listItemMargin;

  const BaseItem({
    super.key,
    required this.isCard,
    this.onTap,
    this.backgroundColor,
    this.leftWidth,
    this.head,
    this.body,
    this.tail,
    this.cardPadding,
    this.cardMargin,
    this.builder,
    this.listItemPadding,
    this.listItemMargin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseEnterExit(
        builder: (isHover) => isCard
            ? BaseCard(
                backgroundColor: backgroundColor,
                leftWidth: leftWidth,
                head: head,
                tail: tail,
                padding: cardPadding,
                margin: cardMargin,
                isHover: isHover,
                body: body,
              )
            : BaseListItem(
                builder: builder,
                padding: listItemPadding,
                margin: listItemMargin,
                isHover: isHover,
              ),
      ),
    );
  }
}
