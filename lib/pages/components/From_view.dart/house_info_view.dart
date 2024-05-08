import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/components/From_view.dart/from_Item.dart';
import 'package:project_view/pages/components/select_imgs.dart';
import 'package:project_view/pages/components/select_popmenu.dart';
import 'package:project_view/utils/adaptive.dart';
import 'package:project_view/utils/area.dart';

import '../area_filter.dart';
import '../config/config.dart';
import 'base_from_view.dart';

class HouseInfoView extends BaseFromView {
  const HouseInfoView({super.key});

  @override
  List<Widget> creatItems(BuildContext context, GlobalKey<FormState> formKey) {
    // ProvinceAreaNode? province;
    // StreamController streamController = StreamController();
    return [
      StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              FromItem(
                label: '省份',
                child: ProvinceFilter(
                  area: controller.area!,
                  initProvice: controller.getEditInfo('houseTerritory'),
                  onSelected: (node) {
                    controller.setEditInfo('houseTerritory', node.code);
                    controller.setEditInfo('provinceNode', node);
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(height: 20),
              FromItem(
                label: "市/县区/镇",
                child: controller.getEditInfo('houseTerritory') == null
                    ? Text(
                        '请先选择省份',
                        style: TextStyle(color: labelColor(context.isDarkMode)),
                      )
                    : AreaFilter(
                        key: UniqueKey(),
                        province: controller.getEditInfo('provinceNode')!,
                        onSelected: (node) {
                          controller.setEditInfo('addrCode', node.code);
                        },
                        initNode: controller.getEditInfo('addrCode'),
                      ),
              ),
            ],
          );
        },
      ),
      FromItem(
        label: "交易方式",
        child: SelectPopMenu(
          item: const [
            SelectData(label: "出租", value: "rent"),
            SelectData(label: "出售", value: "sell"),
          ],
          width: 64,
          onSelect: (value) =>
              controller.setEditInfo('houseTardeType', value.value),
          initValue: controller.getEditInfo('houseTardeType'),
        ),
      ),
      FromItem(
        label: "详细地址",
        child: creatTextField(
          context,
          "addr",
          hintText: "详细地址",
          validator: (text) => (text?.length ?? 0) < 3 ? '详细地址不能少于3个字符' : null,
        ),
      ),
      FromItem(
        label: "房屋描述",
        child: creatTextField(
          context,
          "describe",
          hintText: "房屋描述",
          maxLines: 4,
        ),
      ),
      FromItem(
        label: '房屋图像',
        isRight: false,
        child: SelectImg(controller: controller.selectImgController),
      ),
      FromItem(
        label: '',
        child: Align(
          alignment: Alignment.centerRight,
          child: creatButon(
            context,
            label: "发布",
            width: 64,
            onTap: () => ok(() async {
              if (controller.getEditInfo('houseTerritory') == null) {
                throw '请选择省份';
              }
              if (controller.getEditInfo('addrCode') == null ||
                  AreaNode.getCountyCode(controller.getEditInfo('addrCode'))
                      .isEmpty) {
                throw '至少选择至县区';
              }
              if (controller.getEditInfo('houseTardeType') == null) {
                throw '请选择交易方式';
              }
              if (!(formKey.currentState?.validate() ?? true)) {
                throw '请检查输入';
              }
              if (controller.selectImgController.isAction) {
                throw '请等待图片上传完成';
              }
              controller.setEditInfo(
                  'houseFile', controller.selectImgController.imageUrl);
              bool res = await controller.addHouse();
              controller.selectImgController.clean();
              return res;
            }),
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return creatFrom(context);
  }
}

Future<dynamic> toHouseInfo([bool isPage = true]) async => toFrom(
      const HouseInfoView(),
      '发布房源',
      isPage,
      Adaptive.getWidth() * .5,
    );
