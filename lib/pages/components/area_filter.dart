import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/components/base_popmenu.dart';
import 'package:project_view/pages/components/config/color_config.dart';
import 'package:project_view/pages/components/customize_widget.dart';
import 'package:project_view/utils/adaptive.dart';
import 'package:project_view/utils/area.dart';

Widget _creatFilter(BuildContext context,
        {String? label, bool canSelect = false, double width = 100}) =>
    CustomizeWidget(
      label: label ?? '-----',
      onTap: canSelect ? null : () {},
      tooltip: label,
      config: CustomizeWidgetConfig(
        textMaxLenth: width - 24,
        width: width,
        haveBorder: true,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        backgroundColor: canSelect ? null : borderColor(context.isDarkMode),
        hoverBackgroundColor:
            canSelect ? null : borderColor(context.isDarkMode),
        cursor: canSelect ? null : SystemMouseCursors.forbidden,
      ),
    );

Widget _creatPopMenu(
  BuildContext context, {
  double? maxHeight,
  List<AreaNode> item = const [],
  dynamic Function(AreaNode e)? onTap,
  bool Function(AreaNode e)? isSelected,
  bool canSelect = false,
  AreaNode? node,
  double? childWidth,
}) =>
    PopMenu.item(
      maxHeight: maxHeight ?? 450,
      item: item
          .map((e) => CustomizeWidget.menuItem(
                label: e.name,
                onTap: () => onTap?.call(e),
                endWidget: (isHover) => isSelected?.call(e) ?? false
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                      )
                    : const SizedBox(),
              ))
          .toList(),
      child: _creatFilter(
        context,
        label: node?.name,
        canSelect: canSelect,
        width: childWidth ?? 100,
      ),
    );

class ProvinceFilter extends StatefulWidget {
  final RootAreaNode area;
  final void Function(ProvinceAreaNode node)? onSelected;
  const ProvinceFilter({super.key, required this.area, this.onSelected});

  @override
  State<ProvinceFilter> createState() => _ProvinceFilterState();
}

class _ProvinceFilterState extends State<ProvinceFilter> {
  ProvinceAreaNode? _province;
  @override
  Widget build(BuildContext context) {
    double childWidth = min(Adaptive.getWidth(context) * .2, 160);
    double height = Adaptive.getHeight(context) * .36;
    return _creatPopMenu(
      context,
      maxHeight: height,
      item: widget.area.children,
      onTap: (e) => setState(() {
        _province = e as ProvinceAreaNode;
        widget.onSelected?.call(e);
      }),
      isSelected: (e) => _province?.name == e.province,
      canSelect: true,
      node: _province,
      childWidth: childWidth,
    );
  }
}

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

  bool get isOneCity => widget.province.children.length == 1;

  @override
  void initState() {
    super.initState();
    if (isOneCity) _city = widget.province.children.first;
  }

  @override
  Widget build(BuildContext context) {
    double childWidth = min(Adaptive.getWidth(context) * .2, 160);
    double height = Adaptive.getHeight(context) * .36;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        isOneCity
            ? _creatFilter(context, label: _city?.name, canSelect: false)
            : _creatPopMenu(
                context,
                maxHeight: height,
                item: widget.province.children,
                onTap: (e) => setState(() {
                  _city = e as CityAreaNode;
                  _county = null;
                  _street = null;
                  widget.onSelected?.call(e);
                }),
                isSelected: (e) => _city?.name == e.city,
                canSelect: true,
                node: _city,
                childWidth: childWidth * .8,
              ),
        const SizedBox(width: 10),
        _creatPopMenu(
          context,
          maxHeight: height,
          item: _city?.children ?? [],
          onTap: (e) => setState(() {
            _county = e as CountyAreaNode;
            _street = null;
            widget.onSelected?.call(e);
          }),
          isSelected: (e) => _county?.name == e.county,
          canSelect: _city != null,
          node: _county,
          childWidth: childWidth,
        ),
        const SizedBox(width: 10),
        _creatPopMenu(
          context,
          maxHeight: height,
          item: _county?.children ?? [],
          onTap: (e) => setState(() {
            _street = e as StreetAreaNode;
            widget.onSelected?.call(e);
          }),
          isSelected: (e) => _street?.name == e.street,
          canSelect: _county != null,
          node: _street,
          childWidth: childWidth * 1.2,
        ),
      ],
    );
  }
}
