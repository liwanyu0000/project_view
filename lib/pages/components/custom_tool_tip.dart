import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'config/config.dart';

class CustomToolTip extends StatelessWidget {
  final String? text;
  final double? maxWidth;
  final double? maxHeight;
  final double? minWidth;
  final double? minHeight;
  final double? verticalOffset;
  final double? radius;
  final double? fontSize;
  final double? borderWidth;
  final double? sigmaX;
  final double? sigmaY;
  final Color? backgroundColor;
  final Color? textColor;
  final Duration? showDuration;
  final Duration? waitDuration;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final List<BoxShadow>? boxShadow;
  final Widget? child;
  final Widget? toolWidget;
  const CustomToolTip({
    super.key,
    this.text,
    this.maxWidth,
    this.maxHeight,
    this.minWidth,
    this.minHeight,
    this.verticalOffset,
    this.radius,
    this.fontSize,
    this.borderWidth,
    this.sigmaX,
    this.sigmaY,
    this.backgroundColor,
    this.textColor,
    this.showDuration,
    this.waitDuration,
    this.margin,
    this.padding,
    this.boxShadow,
    this.child,
    this.toolWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      padding: EdgeInsets.zero,
      margin: margin ?? EdgeInsets.zero,
      verticalOffset: verticalOffset ?? 16,
      showDuration: showDuration ?? const Duration(milliseconds: 50),
      waitDuration: waitDuration ?? const Duration(milliseconds: 50),
      decoration: BoxDecoration(
        color: const Color(0x00000000),
        borderRadius: BorderRadius.circular(radius ?? 6.0),
      ),
      message: ((text == null || text!.replaceAll(' ', '') == '') &&
              toolWidget == null)
          ? ''
          : null,
      richMessage: ((text == null || text!.replaceAll(' ', '') == '') &&
              toolWidget == null)
          ? null
          : WidgetSpan(
              child: Container(
              decoration: BoxDecoration(
                  color: backgroundColor ??
                      (context.isDarkMode
                          ? const Color.fromARGB(255, 37, 38, 53)
                              .withOpacity(.7)
                          : const Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(.88)),
                  border: Border.all(
                      color: context.isDarkMode
                          ? const Color.fromARGB(255, 52, 54, 80)
                          : const Color.fromARGB(255, 216, 216, 216),
                      width: borderWidth ?? 1),
                  boxShadow: boxShadow ??
                      (context.isDarkMode
                          ? const [
                              BoxShadow(
                                blurRadius: 4,
                                spreadRadius: 1,
                                color: Color.fromARGB(64, 0, 0, 0),
                              ),
                            ]
                          : const [
                              BoxShadow(
                                offset: Offset(1, 1),
                                blurRadius: 2,
                                spreadRadius: 0,
                                color: Color.fromARGB(20, 0, 0, 0),
                              ),
                            ]),
                  borderRadius: BorderRadius.all(Radius.circular(radius ?? 4))),
              constraints: BoxConstraints(
                  maxWidth: maxWidth ?? 420,
                  maxHeight: maxHeight ?? 120,
                  minWidth: minWidth ?? 0,
                  minHeight: minHeight ?? 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius ?? 6.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: sigmaX ?? 5, sigmaY: sigmaY ?? 5),
                  child: Padding(
                    padding: padding ?? const EdgeInsets.fromLTRB(8, 6, 8, 6),
                    child: SingleChildScrollView(
                      child: toolWidget ??
                          Text(
                            text ?? '',
                            style: TextStyle(
                              color: textColor ??
                                  (context.isDarkMode
                                      ? const Color(0xFFd9dae7)
                                      : null),
                              fontSize:
                                  fontSize ?? textSizeConfig.secondaryTextSize,
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            )),
      child: child ??
          Text(
            text ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize ?? textSizeConfig.secondaryTextSize,
              color: textColor ?? logTextEmphasisColor(context.isDarkMode),
              fontWeight: FontWeight.w500,
            ),
          ),
    );
  }
}
