import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/components/base_popmenu.dart';
import 'package:project_view/pages/components/config/color_config.dart';
import 'package:project_view/pages/components/customize_widget.dart';
import 'package:project_view/utils/area.dart';

class AreaFilter extends StatefulWidget {
  final ProvinceAreaNode province;
  final void Function(AreaNode node)? onSelected;
  const AreaFilter({super.key, required this.province, this.onSelected});

  @override
  State<AreaFilter> createState() => _AreaFilterState();
}

class _AreaFilterState extends State<AreaFilter> {
  CityAreaNode? _city;
  CountyAreaNode? _county;
  StreetAreaNode? _street;

  Widget _creatFilter(BuildContext context,
          {String? label, bool canSelect = false}) =>
      CustomizeWidget(
        label: label ?? '-----',
        onTap: canSelect ? null : () {},
        tooltip: label,
        config: CustomizeWidgetConfig(
          haveBorder: true,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          backgroundColor: canSelect ? null : borderColor(context.isDarkMode),
          hoverBackgroundColor:
              canSelect ? null : borderColor(context.isDarkMode),
          cursor: canSelect ? null : SystemMouseCursors.forbidden,
        ),
      );

  bool get isOneCity => widget.province.children.length == 1;

  @override
  void initState() {
    super.initState();
    if (isOneCity) _city = widget.province.children.first;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        isOneCity
            ? _creatFilter(context, label: _city?.name, canSelect: false)
            : PopMenu.item(
                item: widget.province.children
                    .map((e) => CustomizeWidget.menuItem(
                          label: e.name,
                          onTap: () => setState(() {
                            _city = e;
                            _county = null;
                            _street = null;
                            widget.onSelected?.call(e);
                          }),
                        ))
                    .toList(),
                child:
                    _creatFilter(context, label: _city?.name, canSelect: true),
              ),
        const SizedBox(width: 10),
        PopMenu.item(
          item: _city?.children
                  .map((e) => CustomizeWidget.menuItem(
                        label: e.name,
                        onTap: () => setState(() {
                          _county = e;
                          _street = null;
                          widget.onSelected?.call(e);
                        }),
                      ))
                  .toList() ??
              [],
          child: _creatFilter(context,
              label: _county?.name, canSelect: _city != null),
        ),
        const SizedBox(width: 10),
        PopMenu.item(
          item: _county?.children
                  .map((e) => CustomizeWidget.menuItem(
                        label: e.name,
                        onTap: () => setState(() {
                          _street = e;
                          widget.onSelected?.call(e);
                        }),
                      ))
                  .toList() ??
              [],
          child: _creatFilter(context,
              label: _street?.name, canSelect: _county != null),
        ),
      ],
    );
  }
}
