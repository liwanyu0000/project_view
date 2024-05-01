import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';
import '../config/config.dart';
import 'edit_item_model.dart';

Widget creatSuffixIcon() => Icon(
      Icons.chevron_right_outlined,
      color: labelColor(Get.isDarkMode),
      size: iconSizeConfig.primaryIconSize,
    );

Widget hintWidget(BuildContext context, String? hintText,
        [TextAlign? textAlign]) =>
    Text(
      hintText ?? '',
      textAlign: textAlign,
      style: TextStyle(
        fontSize: textSizeConfig.primaryTextSize,
        color: labelColor(context.isDarkMode),
      ),
    );

abstract class CustomForm extends StatelessWidget {
  final GlobalKey<FormState>? formKey;
  final List<EditItemModel> items;
  final EdgeInsetsGeometry? itempadding;

  /// 整体的只读状态
  final bool readOnly;
  const CustomForm(
      {super.key,
      this.formKey,
      required this.items,
      this.readOnly = true,
      this.itempadding});

  String getState(EditItemModel e) => e.readOnly ?? readOnly ? 'READ' : 'EDIT';

  Widget creatLabel(
    BuildContext context,
    EditItemModel e, {
    TextAlign? textAlign,
    String? state,
  }) =>
      e.label == null
          ? const SizedBox()
          : Padding(
              padding: e.labelPadding?.call(getState(e)) ?? EdgeInsets.zero,
              child: Text(
                e.label!,
                textAlign: textAlign,
                style: TextStyle(
                  fontSize: textSizeConfig.primaryTextSize,
                  // fontWeight: FontWeight.w600,
                  color: labelColor(context.isDarkMode),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );

  factory CustomForm.builder({
    Key? key,
    GlobalKey<FormState>? formKey,
    required List<EditItemModel> items,
    Widget? Function(bool isSmall)? separator,
    bool readOnly = true,
    double? gap,
    double? leftGap,
    double? rightGap,
    double? startGap,
    double? endGap,

    /// false 弹窗状态 true 页面状态
    bool? showState,
  }) {
    bool isSmall = showState ?? Adaptive.isSmall();
    List<EditItemModel> itemsTmp = items;
    Widget separatorWidget = separator?.call(isSmall) ??
        (isSmall ? const SizedBox() : const SizedBox(height: 10));
    itemsTmp = items
        .expand((e) =>
            e.isNone ? [e] : [e, EditItemModel.separator(separatorWidget)])
        .toList();
    if (itemsTmp.last.isNone) itemsTmp.removeLast();
    return isSmall
        ? _PhoneCustomForm(
            key: key,
            formKey: formKey,
            items: itemsTmp,
            readOnly: readOnly,
            leftGap: leftGap,
            rightGap: rightGap,
            startGap: startGap,
            endGap: endGap,
          )
        : _WindowCustomForm(
            key: key,
            formKey: formKey,
            items: itemsTmp,
            readOnly: readOnly,
            gap: gap,
          );
  }
}

class _PhoneCustomForm extends CustomForm {
  final double? leftGap;
  final double? rightGap;
  final double? startGap;
  final double? endGap;
  const _PhoneCustomForm({
    super.key,
    super.formKey,
    required super.items,
    super.readOnly = true,
    this.leftGap,
    this.rightGap,
    this.startGap,
    this.endGap,
  });

  @override
  String getState(EditItemModel e) =>
      e.readOnly ?? readOnly ? 'RMIDDLE' : 'EMIDDLE';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(startGap ?? 10),
          1: const IntrinsicColumnWidth(),
          2: FixedColumnWidth(leftGap ?? 5),
          3: const FlexColumnWidth(1),
          4: FixedColumnWidth(rightGap ?? 0),
          5: const IntrinsicColumnWidth(),
          6: FixedColumnWidth(endGap ?? 10),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: items.map(
          (e) {
            Widget child = e.builder(context, getState(e));
            void Function()? onTap =
                e.readOnly ?? readOnly ? e.readOnTap : e.editOnTap;
            return TableRow(
              key: e.key,
              children: [
                TableRowInkWell(onTap: onTap, child: const SizedBox()),
                TableCell(
                  verticalAlignment: e.cellVerticalAlignment,
                  child: TableRowInkWell(
                      onTap: onTap,
                      child: creatLabel(context, e, state: getState(e))),
                ),
                TableRowInkWell(onTap: onTap, child: const SizedBox()),
                TableRowInkWell(
                  onTap: onTap,
                  child: e.flexible
                      ? child
                      : Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            child,
                          ],
                        ),
                ),
                TableRowInkWell(onTap: onTap, child: const SizedBox()),
                TableCell(
                  verticalAlignment: e.cellVerticalAlignment,
                  child: TableRowInkWell(
                    onTap: onTap,
                    child: e.readOnly ?? readOnly
                        ? const SizedBox()
                        : Padding(
                            padding: e.labelPadding?.call(getState(e)) ??
                                EdgeInsets.zero,
                            child: e.suffixIcon ?? const SizedBox(),
                          ),
                  ),
                ),
                TableRowInkWell(onTap: onTap, child: const SizedBox()),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}

class _WindowCustomForm extends CustomForm {
  final double? gap;
  const _WindowCustomForm({
    super.key,
    super.formKey,
    required super.items,
    super.readOnly = true,
    this.gap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Table(
          columnWidths: {
            0: const IntrinsicColumnWidth(),
            1: FixedColumnWidth(gap ?? 10),
            2: const FlexColumnWidth(1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: items.map(
            (e) {
              Widget child = e.builder(
                  context, (e.readOnly ?? readOnly) ? 'READ' : 'EDIT');
              return TableRow(
                key: e.key,
                children: [
                  TableCell(
                    verticalAlignment: e.cellVerticalAlignment,
                    child: creatLabel(context, e, textAlign: TextAlign.end),
                  ),
                  const TableCell(child: SizedBox()),
                  TableCell(
                    child: e.flexible
                        ? child
                        : Row(
                            children: [
                              child,
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
