import 'package:flutter/material.dart';

import '../../utils/adaptive.dart';
import 'base_dialog.dart';
import 'base_popmenu.dart';

class Converter extends StatelessWidget {
  final Widget Function(bool) builder;
  final String title;
  final Widget Function([dynamic Function()? onTap]) child;
  final BuildContext? targetContext;
  final dynamic Function()? operate;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? dialogMargin;
  final EdgeInsetsGeometry? dialogPadding;
  final Color? shadowColor;
  final Widget? topRightButton;
  final double? dialogWidth;
  final double? dialogHeight;
  final List<Widget>? actions;
  final dynamic Function()? onDismiss;
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;
  final Alignment? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final dynamic Function()? onTap;
  final Offset Function(Offset, Size, int, int)? targetBuilder;
  final bool flexible;
  final String? dialogTag;
  final bool? clickMaskDismiss;
  final bool? keepSingle;
  final bool? usePenetrate;
  const Converter({
    super.key,
    required this.builder,
    required this.child,
    required this.title,
    this.targetContext,
    this.operate,
    this.titleStyle,
    this.titlePadding,
    this.contentPadding,
    this.dialogMargin,
    this.dialogPadding,
    this.shadowColor,
    this.topRightButton,
    this.dialogWidth,
    this.dialogHeight,
    this.actions,
    this.onDismiss,
    this.alignment,
    this.padding,
    this.margin,
    this.decoration,
    this.targetBuilder,
    this.minWidth = 0.0,
    this.maxWidth = 360,
    this.minHeight = 0.0,
    this.maxHeight = 450,
    this.onTap,
    this.flexible = false,
    this.dialogTag,
    this.clickMaskDismiss,
    this.keepSingle,
    this.usePenetrate,
  });

  @override
  Widget build(BuildContext context) {
    return Adaptive.isSmall(context)
        ? child(
            () => showSmartDialog(
              title: title,
              child: builder(false),
              operate: operate,
              onDismiss: onDismiss,
              titleStyle: titleStyle,
              titlePadding: titlePadding,
              contentPadding: contentPadding,
              dialogMargin: dialogMargin,
              dialogPadding: dialogPadding,
              topRightButton: topRightButton,
              width: dialogWidth,
              height: dialogHeight,
              actions: actions,
              flexible: flexible,
              dialogTag: dialogTag,
              clickMaskDismiss: clickMaskDismiss ?? true,
              keepSingle: keepSingle ?? true,
              usePenetrate: usePenetrate ?? false,
            ),
          )
        : PopMenu(
            builder: builder,
            targetContext: targetContext,
            onDismiss: onDismiss,
            alignment: alignment,
            padding: padding,
            margin: margin,
            decoration: decoration,
            targetBuilder: targetBuilder,
            minWidth: minWidth,
            maxWidth: maxWidth,
            minHeight: minHeight,
            maxHeight: maxHeight,
            onTap: onTap,
            clickMaskDismiss: clickMaskDismiss ?? true,
            keepSingle: keepSingle ?? true,
            usePenetrate: usePenetrate ?? false,
            child: child(),
          );
  }
}

class ConverterItem extends StatelessWidget {
  final List<Widget>? item;
  final int? itemCount;
  final Widget? Function(BuildContext, int)? itemBuilder;
  final String title;
  final Widget Function([dynamic Function()? onTap]) child;
  final BuildContext? targetContext;
  final dynamic Function()? operate;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? dialogMargin;
  final EdgeInsetsGeometry? dialogPadding;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final Widget? topRightButton;
  final double? dialogWidth;
  final double? dialogHeight;
  final MainAxisAlignment? actionsAlignment;
  final List<Widget>? actions;
  final dynamic Function()? onDismiss;
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;
  final Alignment? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final dynamic Function()? onTap;
  final Offset Function(Offset, Size, int, int)? targetBuilder;
  final bool flexible;
  final String? dialogTag;
  final bool? clickMaskDismiss;
  final bool? keepSingle;
  final bool? usePenetrate;
  final Widget? separatorWidget;
  const ConverterItem({
    super.key,
    this.item = const [],
    this.itemCount,
    this.itemBuilder,
    required this.title,
    required this.child,
    this.targetContext,
    this.operate,
    this.titleStyle,
    this.titlePadding,
    this.contentPadding,
    this.dialogMargin,
    this.dialogPadding,
    this.shadowColor,
    this.surfaceTintColor,
    this.backgroundColor,
    this.shape,
    this.topRightButton,
    this.dialogWidth,
    this.dialogHeight,
    this.actionsAlignment,
    this.actions,
    this.onDismiss,
    this.alignment,
    this.padding,
    this.margin,
    this.decoration,
    this.onTap,
    this.targetBuilder,
    this.maxHeight = 450,
    this.maxWidth = 360,
    this.minHeight = 0.0,
    this.minWidth = 0.0,
    this.flexible = false,
    this.dialogTag,
    this.clickMaskDismiss,
    this.keepSingle,
    this.usePenetrate,
    this.separatorWidget,
  }) : assert(item != null || (itemCount != null && itemBuilder != null));

  @override
  Widget build(BuildContext context) {
    return Adaptive.isSmall(context)
        ? child(
            () => showSmartItemDialog(
              title: title,
              item: item,
              itemBuilder: itemBuilder,
              itemCount: itemCount,
              operate: operate,
              titleStyle: titleStyle,
              titlePadding: titlePadding,
              contentPadding: contentPadding ?? const EdgeInsets.all(10),
              dialogMargin: dialogMargin,
              dialogPadding: dialogPadding,
              topRightButton: topRightButton,
              width: dialogWidth,
              height: dialogHeight,
              actions: actions,
              flexible: flexible,
              dialogTag: dialogTag,
              clickMaskDismiss: clickMaskDismiss ?? true,
              keepSingle: keepSingle ?? true,
              usePenetrate: usePenetrate ?? false,
              separatorWidget: separatorWidget,
            ),
          )
        : PopMenu.item(
            item: item,
            itemBuilder: itemBuilder,
            itemCount: itemCount,
            targetContext: targetContext,
            onDismiss: onDismiss,
            alignment: alignment,
            padding: padding,
            margin: margin,
            decoration: decoration,
            targetBuilder: targetBuilder,
            minWidth: minWidth,
            maxWidth: maxWidth,
            minHeight: minHeight,
            maxHeight: maxHeight,
            onTap: onTap,
            clickMaskDismiss: clickMaskDismiss ?? true,
            keepSingle: keepSingle ?? true,
            usePenetrate: usePenetrate ?? false,
            separatorWidget: separatorWidget,
            child: child(),
          );
  }
}
