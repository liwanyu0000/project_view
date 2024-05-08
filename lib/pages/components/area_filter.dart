import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/components/base_popmenu.dart';
import 'package:project_view/pages/components/config/color_config.dart';
import 'package:project_view/pages/components/customize_widget.dart';
import 'package:project_view/utils/adaptive.dart';
import 'package:project_view/utils/area.dart';

Widget _creatFilter(BuildContext context,
        {String? label, bool canSelect = false, double childWidth = 100}) =>
    CustomizeWidget(
      label: label ?? '-----',
      onTap: canSelect ? null : () {},
      tooltip: label,
      config: CustomizeWidgetConfig(
        textMaxLenth: childWidth - 24,
        width: childWidth,
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
        childWidth: childWidth ?? 100,
      ),
    );

class ProvinceFilter extends StatefulWidget {
  final RootAreaNode area;
  final void Function(ProvinceAreaNode node)? onSelected;
  final String? initProvice;
  const ProvinceFilter({
    super.key,
    required this.area,
    this.onSelected,
    this.initProvice,
  });

  @override
  State<ProvinceFilter> createState() => _ProvinceFilterState();
}

class _ProvinceFilterState extends State<ProvinceFilter> {
  ProvinceAreaNode? _province;

  @override
  void initState() {
    super.initState();
    if (widget.initProvice != null) {
      String provinceCode = AreaNode.getProvinceCode(widget.initProvice);
      if (provinceCode.isNotEmpty) {
        _province = widget.area.findFromCode(provinceCode) as ProvinceAreaNode;
      }
    }
  }

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
  final String? initNode;
  const AreaFilter(
      {super.key, required this.province, this.onSelected, this.initNode});

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
    if (widget.initNode != null) {
      String cityCode = AreaNode.getCityCode(widget.initNode);
      String countyCode = AreaNode.getCountyCode(widget.initNode);
      String streetCode = AreaNode.getStreetCode(widget.initNode);
      if (cityCode.isNotEmpty) {
        _city = widget.province.findFromCode(cityCode) as CityAreaNode?;
      }
      if (countyCode.isNotEmpty) {
        _county = _city?.findFromCode(countyCode) as CountyAreaNode?;
      }
      if (streetCode.isNotEmpty) {
        _street = _county?.findFromCode(streetCode) as StreetAreaNode?;
      }
    }
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
            ? _creatFilter(
                context,
                label: _city?.name,
                canSelect: false,
                childWidth: childWidth * .8,
              )
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
