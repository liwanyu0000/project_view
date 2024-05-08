import 'package:flutter/material.dart';
import 'package:project_view/pages/components/customize_widget.dart';
import 'package:project_view/utils/adaptive.dart';

import 'base_popmenu.dart';

class SelectData {
  final String label;
  final dynamic value;

  const SelectData({
    required this.label,
    required this.value,
  });
}

class SelectPopMenu extends StatefulWidget {
  final List<SelectData> item;
  final double? width;
  final void Function(SelectData value)? onSelect;
  final dynamic initValue;
  const SelectPopMenu({
    super.key,
    required this.item,
    this.onSelect,
    this.width,
    this.initValue,
  });

  @override
  State<SelectPopMenu> createState() => _SelectPopMenuState();
}

class _SelectPopMenuState extends State<SelectPopMenu> {
  SelectData? _slelct;

  @override
  void initState() {
    super.initState();
    for (var e in widget.item) {
      if (e.value == widget.initValue) {
        _slelct = e;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.width ?? Adaptive.getWidth(context) * .16;
    if (width < 48) width = 48;
    return PopMenu.item(
      maxHeight: Adaptive.getHeight(context) * .36,
      item: widget.item
          .map((e) => CustomizeWidget.menuItem(
                label: e.label,
                onTap: () {
                  setState(() => _slelct = e);
                  widget.onSelect?.call(e);
                },
                endWidget: (isHover) => _slelct?.value == e.value
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                      )
                    : const SizedBox(),
              ))
          .toList(),
      child: CustomizeWidget(
        label: _slelct?.label ?? '-----',
        tooltip: _slelct?.label,
        config: CustomizeWidgetConfig(
          textMaxLenth: width - 24,
          width: width,
          haveBorder: true,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
      ),
    );
  }
}
