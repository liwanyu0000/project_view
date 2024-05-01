import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'config/config.dart';

const List<List<Alignment>> _alignments = [
  [Alignment.bottomLeft, Alignment.topLeft, Alignment.centerRight],
  [Alignment.bottomRight, Alignment.topRight, Alignment.centerLeft],
  [Alignment.bottomCenter, Alignment.topCenter, Alignment.center]
];

Future<dynamic> showPopMenu({
  required BuildContext targetContext,
  required Widget Function(bool probe) builder,
  double minWidth = 0.0,
  double maxWidth = 360,
  double minHeight = 0.0,
  double maxHeight = 450,
  Alignment? alignment,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  Decoration? decoration,
  bool? clickMaskDismiss,
  bool? keepSingle,
  bool? usePenetrate,
  Offset Function(Offset targetOffset, Size targetSize, int indexW, int indexH)?
      targetBuilder,
  dynamic Function()? onDismiss,
}) async {
  Widget creatContexts(BuildContext context, [double? width, double? height]) =>
      Container(
        constraints: BoxConstraints(
          minWidth: minWidth,
          maxWidth: width ?? maxWidth,
          minHeight: minHeight,
          maxHeight: height ?? maxHeight,
        ),
        alignment: alignment,
        padding: padding,
        margin: margin ??
            const EdgeInsets.only(right: 5, bottom: 8, top: 4, left: 5),
        decoration: decoration ??
            BoxDecoration(
              border: Border.all(
                width: 1,
                color: borderColor(context.isDarkMode),
              ),
              color: context.isDarkMode
                  ? const Color(0xff242738)
                  : const Color(0xfffbfbfc),
              boxShadow: boxShadowConfig(),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
        child: builder(width == null),
      );
  bool flag = true;
  return await SmartDialog.showAttach(
    targetContext: targetContext,
    builder: (context) => creatContexts(targetContext),
    maskColor: const Color(0x00000000),
    keepSingle: true,
    replaceBuilder: (targetOffset, targetSize, selfOffset, selfSize) {
      /// 跳过第一次重构
      if (flag) {
        flag = false;
        return const SizedBox();
      }
      flag = true;
      Size size = MediaQuery.of(targetContext).size;
      SmartDialog.dismiss();
      // if (selfSize.height <= 14) return const SizedBox();
      int indexW = size.width - targetOffset.dx >= selfSize.width
          ? 0
          : targetOffset.dx + targetSize.width >= selfSize.width
              ? 1
              : 2;
      int indexH =
          size.height - targetOffset.dy - targetSize.height >= selfSize.height
              ? 0
              : targetOffset.dy >= selfSize.height
                  ? 1
                  : 2;
      SmartDialog.showAttach(
        maskColor: const Color(0x00ffffff),
        keepSingle: keepSingle ?? true,
        usePenetrate: usePenetrate ?? false,
        clickMaskDismiss: clickMaskDismiss ?? true,
        targetContext: targetContext,
        targetBuilder: (targetOffset, targetSize) => targetBuilder == null
            ? Offset(targetOffset.dx - (indexW == 2 ? 0 : 5),
                targetOffset.dy + (indexH == 1 ? 4 : 0))
            : targetBuilder(targetOffset, targetSize, indexW, indexH),
        alignment: _alignments[indexW][indexH],
        builder: (context) => creatContexts(
            targetContext, selfSize.width - 10, selfSize.height - 12),
        onDismiss: onDismiss,
      );
      return const SizedBox();
    },
  );
}

class PopMenu extends StatelessWidget {
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;
  final BuildContext? targetContext;
  final Alignment? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final Widget Function(bool probe) builder;
  final dynamic Function()? onDismiss;
  final dynamic Function()? onTap;
  final Widget child;
  final Offset Function(
          Offset targetOffset, Size targetSize, int indexW, int indexH)?
      targetBuilder;
  final bool clickMaskDismiss;
  final bool keepSingle;
  final bool usePenetrate;

  const PopMenu({
    super.key,
    required this.child,
    required this.builder,
    this.onTap,
    this.targetContext,
    this.onDismiss,
    this.minWidth = 0.0,
    this.maxWidth = 360,
    this.minHeight = 0.0,
    this.maxHeight = 450,
    this.alignment,
    this.padding,
    this.margin,
    this.decoration,
    this.targetBuilder,
    this.keepSingle = true,
    this.clickMaskDismiss = true,
    this.usePenetrate = false,
  });
  static List<List<Alignment>> alignments = [
    [Alignment.bottomLeft, Alignment.topLeft, Alignment.centerRight],
    [Alignment.bottomRight, Alignment.topRight, Alignment.centerLeft],
    [Alignment.bottomCenter, Alignment.topCenter, Alignment.center]
  ];

  factory PopMenu.item({
    required Widget child,
    List<Widget>? item,
    int? itemCount,
    Widget? Function(BuildContext context, int index)? itemBuilder,
    dynamic Function()? onDismiss,
    BuildContext? targetContext,
    double minWidth = 0.0,
    double maxWidth = 360,
    double minHeight = 0.0,
    double maxHeight = 450,
    Alignment? alignment,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
    dynamic Function()? onTap,
    Widget? head,
    bool? clickMaskDismiss,
    bool? keepSingle,
    bool? usePenetrate,
    Offset Function(
            Offset targetOffset, Size targetSize, int indexW, int indexH)?
        targetBuilder,
    Widget? separatorWidget,
  }) {
    assert(item != null || (itemCount != null && itemBuilder != null));
    return PopMenu(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
        targetContext: targetContext,
        alignment: alignment,
        padding: padding,
        margin: margin,
        decoration: decoration,
        targetBuilder: targetBuilder,
        clickMaskDismiss: clickMaskDismiss ?? true,
        keepSingle: keepSingle ?? true,
        usePenetrate: usePenetrate ?? false,
        builder: (probe) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                head ?? const SizedBox(),
                probe
                    ? Row(mainAxisSize: MainAxisSize.min, children: [
                        Column(children: [
                          for (int i = 0; i < (itemCount ?? item!.length); i++)
                            itemBuilder?.call(Get.context!, i) ?? item![i],
                        ]),
                      ])
                    : Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              separatorWidget ?? const SizedBox(),
                          itemCount: itemCount ?? item!.length,
                          itemBuilder:
                              itemBuilder ?? (context, index) => item![index],
                        ),
                      ),
              ],
            ),
        onTap: onTap,
        onDismiss: onDismiss,
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onTap: () async {
        onTap?.call();
        return await showPopMenu(
          targetContext: targetContext ?? context,
          builder: builder,
          minWidth: minWidth,
          maxWidth: maxWidth,
          minHeight: minHeight,
          maxHeight: maxHeight,
          alignment: alignment,
          padding: padding,
          margin: margin,
          decoration: decoration,
          clickMaskDismiss: clickMaskDismiss,
          keepSingle: keepSingle,
          usePenetrate: usePenetrate,
          targetBuilder: targetBuilder,
          onDismiss: onDismiss,
        );
      },
    );
  }
}
