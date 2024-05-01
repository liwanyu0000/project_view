import 'package:flutter/material.dart';

import '../base_dialog.dart';
import '../base_popmenu.dart';
import 'custom_form.dart';
import 'edit_item_model.dart';

/// 无边框的单选、多选 很自由

class EditSelectItem extends EditItemModel {
  final int? itemCount;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final List<Widget>? items;
  final Widget selectWidget;
  final String? hintText;
  final Widget Function(bool) addBuilder;
  final double? popHeight;
  final double? popWidth;
  final String? dialogTitle;

  const EditSelectItem(
      {super.key,
      super.label,
      super.cellVerticalAlignment,
      super.labelPadding,
      super.contentPadding,
      super.readOnly,
      required this.selectWidget,
      required this.addBuilder,
      this.itemCount,
      this.itemBuilder,
      this.hintText,
      this.items,
      this.popWidth,
      this.popHeight,
      this.dialogTitle})
      : assert(items != null || (itemCount != null && itemBuilder != null));

  Widget _creatContent(
    BuildContext context,
    List<Widget> children,
    String state, [
    WrapAlignment alignment = WrapAlignment.start,
  ]) =>
      Padding(
        padding: contentPadding?.call(state) ??
            const EdgeInsets.only(top: 5, bottom: 5),
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          alignment: alignment,
          children: state == 'EMIDDLE' && children.isEmpty
              ? [hintWidget(context, hintText, TextAlign.end)]
              : children,
        ),
      );

  List<Widget> _creatChildren(BuildContext context) =>
      items ?? [for (int i = 0; i < itemCount!; i++) itemBuilder!(context, i)];

  void _editOnTap() => showSmartDialog(
        title: dialogTitle ?? '选择',
        flexible: true,
        width: popWidth,
        height: popHeight == null ? null : popHeight! + 50,
        contentPadding: const EdgeInsets.all(0),
        child: addBuilder(false),
        actions: [],
      );

  @override
  void Function()? get editOnTap => super.editOnTap ?? _editOnTap;

  @override
  Widget get suffixIcon =>
      (super.readOnly ?? false ? const SizedBox() : creatSuffixIcon());

  @override
  @override
  Widget builder(BuildContext context, String state) {
    if (state == 'READ') {
      return _creatContent(context, _creatChildren(context), state);
    } else if (state == 'RMIDDLE') {
      return _creatContent(
          context, _creatChildren(context), state, WrapAlignment.end);
    } else if (state == 'EMIDDLE') {
      return _creatContent(
          context, _creatChildren(context), state, WrapAlignment.end);
    } else {
      return _creatContent(
          context,
          [
            ..._creatChildren(context),
            PopMenu(builder: addBuilder, child: selectWidget),
          ],
          state);
    }
  }
}
