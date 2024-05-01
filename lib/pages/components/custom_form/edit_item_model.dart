import 'package:flutter/material.dart';

class EditItemModel {
  final LocalKey? key;
  final String? label;
  final TableCellVerticalAlignment? cellVerticalAlignment;
  final EdgeInsets Function(String state)? labelPadding;
  final EdgeInsets Function(String state)? contentPadding;
  final Widget? suffixIcon;
  final bool? readOnly;
  final bool flexible;
  final void Function()? editOnTap;
  final void Function()? readOnTap;
  final bool isNone;

  /// 根据状态构建不同的组件
  //? EDIT     编辑
  //? READ     只读
  //? EMIDDLE  编辑（此状态为小屏幕时的显示状态）
  //? RMIDDLE  只读（此状态为小屏幕时的显示状态）
  final Widget Function(BuildContext context, String state)? _builder;

  const EditItemModel({
    this.key,
    this.label,
    this.cellVerticalAlignment,
    this.labelPadding,
    this.contentPadding,
    this.suffixIcon,
    this.readOnly,
    this.readOnTap,
    this.editOnTap,
    this.flexible = true,
    this.isNone = false,
    Widget Function(BuildContext context, String state)? builder,
  }) : _builder = builder;

  Widget builder(BuildContext context, String state) => Padding(
        padding: contentPadding?.call(state) ?? const EdgeInsets.all(0),
        child: _builder?.call(context, state) ?? const SizedBox(),
      );

  factory EditItemModel.none() => const EditItemModel(isNone: true);

  factory EditItemModel.gap([double? height]) => EditItemModel(
      builder: (_, __) => SizedBox(height: height ?? 0), isNone: true);

  factory EditItemModel.separator(Widget separator) =>
      EditItemModel(builder: (_, __) => separator, isNone: true);
}
