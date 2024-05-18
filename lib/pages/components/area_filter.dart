import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/components/base_popmenu.dart';
import 'package:project_view/pages/components/config/config.dart';
import 'package:project_view/pages/components/customize_widget.dart';
import 'package:project_view/utils/adaptive.dart';
import 'package:project_view/utils/area.dart';

Widget _creatFilter(BuildContext context,
        {String? label, bool canSelect = false, double childWidth = 100}) =>
    CustomizeWidget(
      label: label ?? '请选择',
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
          .map(
            (e) => CustomizeWidget.menuItem(
              label: e.name,
              tooltip: e.name,
              onTap: () => onTap?.call(e),
              endWidget: (_) => SizedBox(
                width: iconSizeConfig.secondaryIconSize,
                child: isSelected?.call(e) ?? false
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
              ),
            ),
          )
          .toList(),
      child: _creatFilter(
        context,
        label: node?.name,
        canSelect: canSelect,
        childWidth: childWidth ?? 100,
      ),
    );

class ProvinceFilterController {
  RootAreaNode? area;
  ProvinceFilterController([this.area]);
  final Rx<ProvinceAreaNode?> _province = Rx<ProvinceAreaNode?>(null);

  ProvinceFilterController setArea(RootAreaNode area) {
    this.area = area;
    return this;
  }

  ProvinceAreaNode? get province => _province.value;
  set province(ProvinceAreaNode? value) => _province.value = value;
  String get code => province?.code ?? '';
  String? get name => province?.name;

  void setFromCode(String? code) {
    String provinceCode = AreaNode.getProvinceCode(code ?? '');
    if (provinceCode.isNotEmpty) {
      province = area?.findFromCode(provinceCode) as ProvinceAreaNode?;
    }
  }

  void dispose() {
    _province.close();
  }

  void reset() {
    _province.value = null;
  }
}

class ProvinceFilter extends StatefulWidget {
  final RootAreaNode area;
  final void Function(ProvinceAreaNode node)? onSelected;
  final ProvinceFilterController? controller;
  final String? initProvice;
  final double? childWidth;
  const ProvinceFilter({
    super.key,
    required this.area,
    this.onSelected,
    this.controller,
    this.initProvice,
    this.childWidth,
  });

  @override
  State<ProvinceFilter> createState() => _ProvinceFilterState();
}

class _ProvinceFilterState extends State<ProvinceFilter> {
  ProvinceFilterController? _controller;
  ProvinceFilterController get controller =>
      _controller ??= (widget.controller?.setArea(widget.area) ??
          ProvinceFilterController(widget.area));

  @override
  void initState() {
    super.initState();
    controller.setFromCode(widget.initProvice);
  }

  @override
  Widget build(BuildContext context) {
    double childWidth =
        widget.childWidth ?? min(Adaptive.getWidth(context) * .2, 160);
    double height = Adaptive.getHeight(context) * .36;
    return Obx(
      () => _creatPopMenu(
        context,
        maxHeight: height,
        item: widget.area.children,
        onTap: (e) {
          controller.province = e as ProvinceAreaNode;
          widget.onSelected?.call(e);
        },
        isSelected: (e) => controller.name == e.province,
        canSelect: true,
        node: controller.province,
        childWidth: childWidth,
      ),
    );
  }
}

class AreaFilterController {
  ProvinceAreaNode? province;
  AreaFilterController([this.province]);
  final Rx<CityAreaNode?> _city = Rx<CityAreaNode?>(null);
  final Rx<CountyAreaNode?> _county = Rx<CountyAreaNode?>(null);
  final Rx<StreetAreaNode?> _street = Rx<StreetAreaNode?>(null);

  bool get isOneCity => province?.children.length == 1;

  AreaFilterController setProvince(ProvinceAreaNode province) {
    this.province = province;
    reset();
    if (isOneCity) city = province.children.first;
    return this;
  }

  void setFromCode(String? code) {
    if (code == null || code.isEmpty) return;
    String cityCode = AreaNode.getCityCode(code);
    String countyCode = AreaNode.getCountyCode(code);
    String streetCode = AreaNode.getStreetCode(code);
    if (cityCode.isNotEmpty) {
      city = province?.findFromCode(cityCode) as CityAreaNode?;
    }
    if (countyCode.isNotEmpty) {
      county = city?.findFromCode(countyCode) as CountyAreaNode?;
    }
    if (streetCode.isNotEmpty) {
      street = county?.findFromCode(streetCode) as StreetAreaNode?;
    }
  }

  CityAreaNode? get city => _city.value;
  set city(CityAreaNode? value) {
    _city.value = value;
    _county.value = null;
    _street.value = null;
  }

  CountyAreaNode? get county => _county.value;
  set county(CountyAreaNode? value) {
    _county.value = value;
    _street.value = null;
  }

  StreetAreaNode? get street => _street.value;
  set street(StreetAreaNode? value) => _street.value = value;

  void reset() {
    _city.value = null;
    _county.value = null;
    _street.value = null;
  }

  void dispose() {
    _city.close();
    _county.close();
    _street.close();
  }

  String get code {
    String? code;
    if (city != null) code = city!.code;
    if (county != null) code = county!.code;
    if (street != null) code = street!.code;
    return code ?? '';
  }
}

class AreaFilter extends StatefulWidget {
  final ProvinceAreaNode province;
  final void Function(AreaNode node)? onSelected;
  final String? initNode;
  final double? childWidth;
  final AreaFilterController? controller;
  const AreaFilter({
    super.key,
    required this.province,
    this.onSelected,
    this.initNode,
    this.childWidth,
    this.controller,
  });

  @override
  State<AreaFilter> createState() => _AreaFilterState();
}

class _AreaFilterState extends State<AreaFilter> {
  AreaFilterController? _controller;
  AreaFilterController get controller =>
      _controller ??= (widget.controller?.setProvince(widget.province) ??
          AreaFilterController(widget.province));
  CityAreaNode? get _city => controller.city;
  CountyAreaNode? get _county => controller.county;
  StreetAreaNode? get _street => controller.street;

  @override
  void initState() {
    super.initState();
    controller.setFromCode(widget.initNode);
  }

  @override
  Widget build(BuildContext context) {
    double childWidth =
        widget.childWidth ?? min(Adaptive.getWidth(context) * .2, 160);
    double height = Adaptive.getHeight(context) * .36;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => _creatPopMenu(
            context,
            maxHeight: height,
            item: widget.province.children,
            onTap: (e) {
              controller.city = e as CityAreaNode;
              widget.onSelected?.call(e);
            },
            isSelected: (e) => _city?.name == e.city,
            canSelect: !controller.isOneCity,
            node: _city,
            childWidth: childWidth * .8,
          ),
        ),
        const SizedBox(width: 10),
        Obx(() => _creatPopMenu(
              context,
              maxHeight: height,
              item: _city?.children ?? [],
              onTap: (e) {
                controller.county = e as CountyAreaNode;
                widget.onSelected?.call(e);
              },
              isSelected: (e) => _county?.name == e.county,
              canSelect: _city != null,
              node: _county,
              childWidth: childWidth,
            )),
        const SizedBox(width: 10),
        Obx(
          () => _creatPopMenu(
            context,
            maxHeight: height,
            item: _county?.children ?? [],
            onTap: (e) {
              controller.street = e as StreetAreaNode;
              widget.onSelected?.call(e);
            },
            isSelected: (e) => _street?.name == e.street,
            canSelect: _county != null,
            node: _street,
            childWidth: childWidth * 1.2,
          ),
        )
      ],
    );
  }
}
