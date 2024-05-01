import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';
import '../base_dialog.dart';
import '../base_popmenu.dart';
import '../config/config.dart';
import '../customize_widget.dart';
import '../mouse_enter_exit.dart';
import '../rotate_icon.dart';
import 'custom_form.dart';
import 'edit_item_model.dart';

class LabelEdit extends StatelessWidget {
  final String text;
  final bool readOnly;
  final dynamic Function()? remove;
  const LabelEdit({
    super.key,
    required this.text,
    this.readOnly = true,
    this.remove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: borderColor(context.isDarkMode),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: textSizeConfig.primaryTextSize),
          ),
          ...readOnly
              ? []
              : [
                  const SizedBox(width: 5),
                  CustomizeWidget(
                    icon: Icons.close,
                    onTap: remove,
                    height: 18,
                  ),
                ],
        ],
      ),
    );
  }
}

/// 有边框的单选、多选 不自由
class EditMultipleItem extends EditItemModel {
  final Widget Function(bool) addBuilder;
  final dynamic multipleValue;
  final bool isSelectOnly;
  final double? popHeight;
  final double? popWidth;
  final String? hintText;
  final String? dialogTitle;

  const EditMultipleItem({
    super.key,
    super.label,
    super.cellVerticalAlignment,
    super.labelPadding,
    super.contentPadding,
    super.suffixIcon,
    super.readOnly,
    super.editOnTap,
    super.readOnTap,
    required this.addBuilder,
    this.multipleValue,
    this.popHeight,
    this.popWidth,
    this.hintText,
    this.dialogTitle,
    this.isSelectOnly = false,
  }) : assert(multipleValue is List<Widget> || multipleValue is String?);

  EdgeInsetsGeometry _contentPadding(String state) {
    return EdgeInsets.symmetric(vertical: isSelectOnly ? 8 : 5);
  }

  Widget _creatContent(
    BuildContext context,
    bool readOnly,
    String state, [
    WrapAlignment alignment = WrapAlignment.start,
    TextAlign textAlign = TextAlign.start,
  ]) =>
      Padding(
        padding: contentPadding?.call(state) ?? _contentPadding(state),
        child: isSelectOnly
            ? _creatSingle(context, readOnly, textAlign)
            : _creatMultiple(context, readOnly, alignment, textAlign),
      );

  Widget _creatSingle(BuildContext context, bool readOnly,
      [TextAlign textAlign = TextAlign.start]) {
    assert(multipleValue is String?);
    String text = multipleValue ?? '';
    return readOnly || text.isNotEmpty
        ? Text(text,
            textAlign: textAlign,
            style: TextStyle(fontSize: textSizeConfig.primaryTextSize))
        : hintWidget(context, hintText, textAlign);
  }

  Widget _creatMultiple(
    BuildContext context,
    bool readOnly, [
    WrapAlignment alignment = WrapAlignment.start,
    TextAlign textAlign = TextAlign.start,
  ]) {
    assert(multipleValue is List<Widget>);
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      alignment: alignment,
      children: readOnly || multipleValue.isNotEmpty
          ? multipleValue
          : [hintWidget(context, hintText, textAlign)],
    );
  }

  @override
  Widget get suffixIcon => super.suffixIcon ?? creatSuffixIcon();

  void _editOnTap() => showSmartDialog(
        title: dialogTitle ?? '选择',
        width: popWidth,
        height: popHeight == null ? null : popHeight! + 50,
        contentPadding: const EdgeInsets.all(0),
        child: addBuilder(true),
        actions: [],
      );

  @override
  void Function()? get editOnTap => super.editOnTap ?? _editOnTap;

  @override
  Widget builder(BuildContext context, String state) {
    if (state == 'READ') {
      return _creatContent(context, true, state);
    } else if (state == 'RMIDDLE') {
      return _creatContent(
          context, true, state, WrapAlignment.end, TextAlign.end);
    } else if (state == 'EMIDDLE') {
      return _creatContent(
          context, false, state, WrapAlignment.end, TextAlign.end);
    } else {
      StreamController streamController = StreamController();
      bool isExpand = false;
      return LayoutBuilder(
        builder: (context, constraints) => PopMenu(
          onDismiss: () => streamController.sink.add(isExpand = false),
          onTap: () => streamController.sink.add(isExpand = true),
          builder: addBuilder,
          maxWidth: popWidth ?? constraints.maxWidth,
          // maxHeight: popHeight ?? constraints.maxHeight,
          minHeight: popHeight ?? min(Adaptive.getHeight(context) * .45, 360),
          maxHeight: popHeight ?? min(Adaptive.getHeight(context) * .45, 380),
          child: MouseEnterExit(
            builder: (isHover) => Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: borderColor(context.isDarkMode),
                ),
                borderRadius: BorderRadius.circular(5),
                color: isHover
                    ? Theme.of(context).colorScheme.shadow.withOpacity(.05)
                    : null,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  Expanded(child: _creatContent(context, false, state)),
                  super.suffixIcon ??
                      StreamBuilder(
                        stream: streamController.stream,
                        initialData: isExpand,
                        builder: (context, snapshot) => RotateIcon(
                          color: labelColor(context.isDarkMode),
                          size: iconSizeConfig.bigAvatarIconSize,
                          isExpanded: isExpand,
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
