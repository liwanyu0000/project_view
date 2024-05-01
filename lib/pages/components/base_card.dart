/*
 * @Description: 
 * @Version: 
 * @Author: liwanyu
 * @Date: 2024-03-20 10:10:17
 * @LastEditors: liwanyu
 * @LastEditTime: 2024-03-27 11:10:35
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'config/config.dart';

class BaseCard extends StatelessWidget {
  final Widget? head;
  final Widget? body;
  final Widget? tail;
  final Color? backgroundColor;
  final double? leftWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final bool isHover;
  const BaseCard({
    super.key,
    this.backgroundColor,
    this.leftWidth,
    this.head,
    this.body,
    this.tail,
    this.padding,
    this.margin,
    this.isHover = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          bottomLeft: Radius.circular(4),
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
        gradient: LinearGradient(
          colors: [backgroundColor!, backgroundColor!.withOpacity(0)],
        ),
      ),
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(width: leftWidth ?? 4),
          Expanded(
            child: Container(
              padding: padding ?? const EdgeInsets.all(8),
              margin: margin,
              decoration: BoxDecoration(
                boxShadow: !isHover ? boxShadowConfig(a: 3) : [],
                border: Border.all(
                  width: 1,
                  color: borderColor(context.isDarkMode),
                ),
                color: !isHover
                    ? context.isDarkMode
                        ? const Color(0xff20212e)
                        : const Color(0xfffbfbfd)
                    : context.isDarkMode
                        ? const Color(0xff242738)
                        : Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    head ?? const SizedBox(),
                    const SizedBox(height: 8),
                    body ?? const SizedBox(),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: borderColor(context.isDarkMode),
                    ),
                    const SizedBox(height: 8),
                    tail ?? const SizedBox(),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
