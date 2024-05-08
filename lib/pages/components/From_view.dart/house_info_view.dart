import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/components/config/color_config.dart';
import 'package:project_view/pages/components/select_imgs.dart';
import 'package:project_view/pages/components/select_popmenu.dart';
import 'package:project_view/utils/adaptive.dart';
import 'package:project_view/utils/area.dart';

import '../area_filter.dart';
import 'base_from_view.dart';

class HouseInfoView extends BaseFromView {
  const HouseInfoView({super.key});

  Widget _creatItem(
    BuildContext context, {
    required String label,
    required Widget child,
  }) =>
      Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              label,
              textAlign:
                  Adaptive.isSmall(context) ? TextAlign.start : TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 20),
          Flexible(child: child),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return creatFrom(context);
  }

  @override
  List<Widget> creatItems(BuildContext context, GlobalKey<FormState> formKey) {
    ProvinceAreaNode? province;
    StreamController streamController = StreamController();
    return [
      _creatItem(
        context,
        label: '省份',
        child: ProvinceFilter(
          area: controller.area!,
          onSelected: (node) {
            streamController.add(province = null);
            streamController.add(province = node);
          },
        ),
      ),
      // StreamBuilder(
      //   stream: streamController.stream,
      //   initialData: province,
      //   builder: (context, snapshot) =>

      _creatItem(
        context,
        label: "市/县区/镇",
        child: province == null
            ? Text(
                '请先选择省份',
                style: TextStyle(color: labelColor(context.isDarkMode)),
              )
            : AreaFilter(key: UniqueKey(), province: province!),
      ),
      // ),
      _creatItem(
        context,
        label: "交易方式",
        child: SelectPopMenu(
          item: const [
            SelectData(label: "出租", value: "rent"),
            SelectData(label: "出售", value: "sell"),
          ],
          width: 64,
          onSelect: (value) =>
              controller.setEditInfo('houseTardeType', value.value),
        ),
      ),
      _creatItem(
        context,
        label: "详细地址",
        child: creatTextField(
          context,
          "addr",
          hintText: "详细地址",
          validator: (text) => (text?.length ?? 0) < 5 ? '详细地址不能少于3个字符' : null,
        ),
      ),
      _creatItem(
        context,
        label: "房屋描述",
        child: creatTextField(
          context,
          "describe",
          hintText: "房屋描述",
          maxLines: 4,
        ),
      ),
      _creatItem(context, label: '房屋图像', child: const SelectImg())
    ];
  }
}

Future<dynamic> toHouseInfo([bool isPage = true]) async => toFrom(
      const HouseInfoView(),
      '发布房源',
      isPage,
      Adaptive.getWidth() * .5,
    );
