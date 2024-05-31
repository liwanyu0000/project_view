import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/components/customize_widget.dart';
import 'package:project_view/utils/adaptive.dart';

import 'base_popmenu.dart';
import 'config/config.dart';

class SelectController {
  final List<SelectData> item;
  SelectController(this.item) {
    reset();
  }
  final RxList<SelectData> selectList = <SelectData>[].obs;
  void add(SelectData value) {
    selectList.add(value);
  }

  void reset() {
    selectList.clear();
    for (var e in item) {
      if (e.isDefault) selectList.add(e);
    }
  }

  void remove(SelectData value) {
    selectList.remove(value);
  }

  void clear() {
    selectList.clear();
    for (var e in item) {
      if (e.isDefault) selectList.add(e);
    }
  }

  void toggle(SelectData value) {
    if (selectList.contains(value)) {
      selectList.remove(value);
    } else {
      selectList.add(value);
    }
  }

  void setFromStr(String str) {
    selectList.clear();
    for (var e in item) {
      if (str.contains(e.value)) {
        selectList.add(e);
      }
    }
  }

  void select(SelectData value) {
    selectList.clear();
    selectList.add(value);
  }

  void selectAll(List<SelectData> value) {
    selectList.clear();
    selectList.addAll(value);
  }

  bool get isEmpty => selectList.isEmpty;

  bool contains(SelectData value) {
    return selectList.contains(value);
  }

  String get label => selectList.map((e) => e.label).join('、');

  List<dynamic> get selectData => selectList.map((e) => e.data).toList();
  List<String> get selectValue => selectList.map((e) => e.value).toList();

  String get firstValue => selectList.isEmpty ? '' : selectList.first.value;

  dynamic get firstData => selectList.isEmpty ? null : selectList.first.data;

  void dispose() {
    selectList.clear();
    selectList.close();
  }
}

class SelectData {
  final String label;
  final dynamic data;
  final String Function(dynamic value)? labelBuilder;
  final bool isDefault;

  String get value =>
      labelBuilder != null ? labelBuilder!(data) : data as String;

  const SelectData({
    required this.label,
    required this.data,
    this.labelBuilder,
    this.isDefault = false,
  });
}

/// 注意： item 不能和 controller 同时使用
class SelectPopMenu extends StatefulWidget {
  final List<SelectData>? item;
  final double? width;
  final double? height;
  final bool canMultiple;
  final void Function(SelectData value)? onSelect;
  final void Function(List<SelectData> value)? onMultipleSelect;
  final List<String> initValue;
  final BuildContext? targetContext;
  final bool canSelect;
  final SelectController? controller;
  const SelectPopMenu({
    super.key,
    this.item,
    this.canMultiple = false,
    this.onSelect,
    this.onMultipleSelect,
    this.width,
    this.height,
    this.initValue = const [],
    this.targetContext,
    this.canSelect = true,
    this.controller,
  }) : assert(item != null || controller != null);

  @override
  State<SelectPopMenu> createState() => _SelectPopMenuState();
}

class _SelectPopMenuState extends State<SelectPopMenu> {
  SelectController? _controller;
  SelectController get controller =>
      _controller ??= (widget.controller ?? SelectController(widget.item!));

  List<SelectData> get item => controller.item;

  @override
  void initState() {
    super.initState();
    for (var e in item) {
      if (widget.initValue.contains(e.value)) {
        controller.add(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.width ?? Adaptive.getWidth(context) * .16;
    if (width < 48) width = 48;
    return PopMenu.item(
      targetContext: widget.targetContext,
      maxHeight: Adaptive.getHeight(context) * .36,
      itemCount: item.length,
      itemBuilder: (context, index) {
        SelectData e = item[index];
        return CustomizeWidget.menuItem(
          label: e.label,
          status: controller.contains(e),
          onChanged: widget.canMultiple
              ? (value) {
                  value ? controller.remove(e) : controller.add(e);
                  widget.onMultipleSelect?.call(controller.selectList);
                  return true;
                }
              : null,
          onTap: () {
            if (widget.canMultiple) {
              controller.toggle(e);
              widget.onMultipleSelect?.call(controller.selectList);
            } else {
              controller.select(e);
              widget.onSelect?.call(e);
            }
          },
          endWidget: widget.canMultiple
              ? null
              : (isHover) => SizedBox(
                    width: iconSizeConfig.secondaryIconSize,
                    child: controller.contains(e)
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).primaryColor,
                          )
                        : null,
                  ),
        );
      },
      child: Obx(
        () => CustomizeWidget(
          label: controller.isEmpty ? '请选择' : controller.label,
          tooltip: controller.label,
          config: CustomizeWidgetConfig(
            textMaxLenth: width - 24,
            width: width,
            height: widget.height,
            haveBorder: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            backgroundColor:
                widget.canSelect ? null : borderColor(context.isDarkMode),
            hoverBackgroundColor:
                widget.canSelect ? null : borderColor(context.isDarkMode),
            cursor: widget.canSelect ? null : SystemMouseCursors.forbidden,
          ),
          onTap: widget.canSelect ? null : () {},
        ),
      ),
    );
  }
}
