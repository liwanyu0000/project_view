import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

import 'edit_item_model.dart';

// 单选框按钮
class EditRadioGroupItem extends EditItemModel {
  final List<String> items;
  final Axis? direction;
  final Function? onItemTap;
  final String groupValue;

  const EditRadioGroupItem(
      {super.key,
      super.label,
      super.cellVerticalAlignment,
      super.labelPadding,
      super.contentPadding,
      super.readOnly,
      super.readOnTap,
      required this.items,
      this.direction,
      required this.onItemTap,
      required this.groupValue});

  Widget radioModel(BuildContext context,
          {required String value,
          String? groupValue,
          void Function(String?)? onChanged}) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio(
            value: value,
            groupValue: value,
            onChanged: onChanged,
          ),
          Text(value.tr)
        ],
      );

  @override
  Widget builder(BuildContext context, String state) {
    ValueNotifier groupValueNot = ValueNotifier(groupValue);

    return ValueListenableBuilder(
      valueListenable: groupValueNot,
      builder: (context, value, child) {
        var wrap = Wrap(
          spacing: 5,
          runSpacing: 5,
          alignment: state == 'EMIDDLE' || state == 'EMIDDLE'
              ? WrapAlignment.end
              : WrapAlignment.start,
          children: state == 'READ' || state == 'RMIDDLE'
              ? [radioModel(context, value: groupValueNot.value)]
              : items
                  .map((e) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            value: e,
                            groupValue: groupValueNot.value,
                            onChanged: (value) {
                              groupValueNot.value = value;
                              if (value != null) {
                                if (onItemTap != null) {
                                  onItemTap!(value);
                                }
                              }
                            },
                          ),
                          Text(e.tr)
                        ],
                      ))
                  .toList(),
        );
        return Padding(
          padding: contentPadding?.call(state) ??
              const EdgeInsets.only(top: 5, bottom: 5),
          child: wrap,
        );
      },
    );
    // if (state == 'READ') {
    //   return _creatContent(context, [], state);
    // } else if (state == 'RMIDDLE') {
    //   return _creatContent(context, [], state, WrapAlignment.end);
    // } else if (state == 'EMIDDLE') {
    //   return _creatContent(
    //       context, _creatChildren(context), state, WrapAlignment.end);
    // } else {
    //   return _creatContent(
    //       context,
    //       [
    //         ..._creatChildren(context),
    //       ],
    //       state);
    // }
  }
}
