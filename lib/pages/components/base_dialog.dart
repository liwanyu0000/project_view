import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../utils/adaptive.dart';
import 'config/config.dart';
import 'customize_widget.dart';
import 'operate_botton.dart';

class BaseDialog extends StatelessWidget {
  const BaseDialog({
    this.title,
    super.key,
    this.operate,
    this.cancel,
    this.child,
    this.titleWidget,
    this.titleStyle,
    this.titlePadding,
    this.contentPadding,
    this.dialogMargin,
    this.dialogPadding,
    this.boxShadow,
    this.decoration,
    this.topRightButton,
    this.width,
    this.height,
    this.actions,
    this.action,
    this.flexible = false,
    this.dialogTag,
  });

  final dynamic Function()? operate;
  final Future Function()? cancel;
  final String? title;
  final Widget? titleWidget;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? dialogMargin;
  final EdgeInsetsGeometry? dialogPadding;
  final List<BoxShadow>? boxShadow;
  final Decoration? decoration;
  final Widget? topRightButton;
  final double? width;
  final double? height;
  final List<Widget>? actions;
  final Widget? action;
  final Widget? child;
  final bool flexible;
  final String? dialogTag;
  // ! 注意：当flexible为false时，height属性为最大高度
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxWidth: width ??
              (Adaptive.isSmall(context)
                  ? Adaptive.getWidth(context) - 40
                  : Adaptive.getWidth(context) * .5),
          maxHeight: height ?? Adaptive.getHeight(context) * .6),
      decoration: decoration ??
          BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: boxShadow ?? boxShadowConfig(),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
      margin: dialogMargin,
      padding: dialogPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: titlePadding ??
                const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                titleWidget ??
                    Text(
                      (title ?? '').tr,
                      style: titleStyle ??
                          TextStyle(
                            fontSize: textSizeConfig.primaryTextSize,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                const Expanded(child: SizedBox()),
                topRightButton ??
                    CustomizeWidget(
                      onTap: () async {
                        if (cancel == null) {
                          await SmartDialog.dismiss(tag: dialogTag);
                        } else {
                          await cancel!();
                        }
                      },
                      icon: Icons.close,
                      config: CustomizeWidgetConfig(
                        hoverColor: Theme.of(context).colorScheme.error,
                        hoverBackgroundColor:
                            Theme.of(context).colorScheme.background,
                      ),
                    )
              ],
            ),
          ),
          Divider(
            height: 1,
            color: borderColor(context.isDarkMode),
          ),
          Flexible(
            fit: flexible ? FlexFit.tight : FlexFit.loose,
            child: Container(
              width: double.infinity,
              padding: contentPadding ?? const EdgeInsets.all(20),
              child: child,
            ),
          ),
          action ??
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions ??
                      [
                        creatCancelButton(() async {
                          if (cancel == null) {
                            await SmartDialog.dismiss(tag: dialogTag);
                          } else {
                            await cancel!();
                          }
                        }),
                        const SizedBox(width: 10),
                        creatOkButton(() {
                          operate?.call();
                          SmartDialog.dismiss(tag: dialogTag);
                        }),
                      ],
                ),
              ),
          (actions?.isEmpty ?? false)
              ? const SizedBox()
              : const SizedBox(height: 20)
        ],
      ),
    );
  }
}

dynamic showSmartDialog({
  String? title,
  Widget? titleWidget,
  dynamic Function()? operate,
  Future Function()? cancel,
  Widget? child,
  TextStyle? titleStyle,
  EdgeInsetsGeometry? titlePadding,
  EdgeInsetsGeometry? contentPadding,
  EdgeInsetsGeometry? dialogMargin,
  EdgeInsetsGeometry? dialogPadding,
  final List<BoxShadow>? boxShadow,
  Decoration? decoration,
  Alignment? alignment,
  Widget? topRightButton,
  Color? maskColor,
  double? width,
  double? height,
  List<Widget>? actions,
  Widget? action,
  bool flexible = false,
  bool clickMaskDismiss = true,
  bool keepSingle = true,
  bool usePenetrate = false,
  String? dialogTag,
  void Function()? onDismiss,
  void Function()? onMask,
  Rect? ignoreArea,
}) async {
  await SmartDialog.show(
    tag: dialogTag,
    keepSingle: keepSingle,
    maskColor: maskColor,
    usePenetrate: usePenetrate,
    alignment: alignment ?? Alignment.center,
    clickMaskDismiss: clickMaskDismiss,
    onDismiss: onDismiss,
    onMask: onMask,
    ignoreArea: ignoreArea,
    builder: (context) => BaseDialog(
      title: title,
      titleWidget: titleWidget,
      operate: operate,
      cancel: cancel,
      titleStyle: titleStyle,
      titlePadding: titlePadding,
      contentPadding: contentPadding,
      dialogMargin: dialogMargin,
      dialogPadding: dialogPadding,
      boxShadow: boxShadow,
      decoration: decoration,
      topRightButton: topRightButton,
      width: width,
      height: height,
      actions: actions,
      action: action,
      flexible: flexible,
      dialogTag: dialogTag,
      child: child,
    ),
  );
}

dynamic showSmartItemDialog({
  String? title,
  Widget? titleWidget,
  dynamic Function()? operate,
  Future Function()? cancel,
  List<Widget>? item,
  int? itemCount,
  Widget? Function(BuildContext, int)? itemBuilder,
  TextStyle? titleStyle,
  EdgeInsetsGeometry? titlePadding,
  EdgeInsetsGeometry? contentPadding,
  EdgeInsetsGeometry? dialogMargin,
  EdgeInsetsGeometry? dialogPadding,
  Alignment? alignment,
  List<BoxShadow>? boxShadow,
  Widget? topRightButton,
  Color? maskColor,
  double? width,
  double? height,
  List<Widget>? actions,
  Widget? action,
  bool flexible = false,
  bool clickMaskDismiss = true,
  bool keepSingle = true,
  bool usePenetrate = false,
  String? dialogTag,
  void Function()? onDismiss,
  void Function()? onMask,
  Widget? separatorWidget,
}) async {
  assert(item != null || (itemCount != null && itemBuilder != null));
  await SmartDialog.show(
    tag: dialogTag,
    keepSingle: keepSingle,
    maskColor: maskColor,
    usePenetrate: usePenetrate,
    alignment: alignment ?? Alignment.center,
    clickMaskDismiss: clickMaskDismiss,
    onDismiss: onDismiss,
    onMask: onMask,
    builder: (context) => BaseDialog(
      title: title,
      titleWidget: titleWidget,
      operate: operate,
      cancel: cancel,
      titleStyle: titleStyle,
      titlePadding: titlePadding,
      contentPadding: contentPadding,
      dialogMargin: dialogMargin,
      dialogPadding: dialogPadding,
      boxShadow: boxShadow,
      topRightButton: topRightButton,
      width: width,
      height: height,
      actions: actions,
      action: action,
      flexible: flexible,
      dialogTag: dialogTag,
      child: ListView.separated(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        separatorBuilder: (context, index) =>
            separatorWidget ?? const SizedBox(),
        itemCount: itemCount ?? item!.length,
        itemBuilder: itemBuilder ?? (context, index) => item![index],
      ),
    ),
  );
}
