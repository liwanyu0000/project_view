import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_view/model/house/house.dart';
import 'package:project_view/pages/components/from_view/from_Item.dart';
import 'package:project_view/pages/components/select_imgs.dart';
import 'package:project_view/pages/components/select_popmenu.dart';
import 'package:project_view/utils/adaptive.dart';
import 'package:project_view/utils/area.dart';

import '../area_filter.dart';
import '../config/config.dart';
import 'base_from_view.dart';

class _HouseInfoView extends BaseFromView {
  final bool isCreat;
  final int? id;
  final Function()? onDone;
  const _HouseInfoView([this.isCreat = true, this.id, this.onDone]);

  @override
  List<Widget> creatItems(BuildContext context, GlobalKey<FormState> formKey) {
    return [
      FromItem(
        label: '省份',
        child: ProvinceFilter(
          area: controller.area!,
          controller: editInfoController.houseTerritory,
          initProvice: editInfoController.initProvinceCode,
        ),
      ),
      Obx(
        () => FromItem(
          label: "市/县区/镇",
          child: editInfoController.houseTerritory.province == null
              ? Text(
                  '请先选择省份',
                  style: TextStyle(color: labelColor(context.isDarkMode)),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    String? initCode;
                    String? code = editInfoController.initAddrCode;
                    if (editInfoController.houseTerritory.province?.code ==
                        AreaNode.getProvinceCode(code)) {
                      initCode = code;
                    }
                    return AreaFilter(
                      childWidth: constraints.maxWidth * .3,
                      key: UniqueKey(),
                      province: editInfoController.houseTerritory.province!,
                      controller: editInfoController.houseAddrCode,
                      initNode: initCode,
                    );
                  },
                ),
        ),
      ),
      FromItem(
        label: "详细地址",
        child: creatTextField(
          context,
          controller: editInfoController.houseAddr,
          hintText: "详细地址",
          validator: (text) => (text?.length ?? 0) < 3 ? '详细地址不能少于3个字符' : null,
        ),
      ),
      FromItem(
        label: "交易方式",
        child: SelectPopMenu(
          width: 64,
          controller: editInfoController.houseTardType,
        ),
      ),
      FromItem(
          label: "价格",
          actions: [
            const SizedBox(width: 10),
            Obx(
              () => Text(
                editInfoController.houseTardType.firstValue ==
                        HouseModel.rentHouse
                    ? '元/月'
                    : '元/平方米',
                style: TextStyle(
                  color: labelColor(context.isDarkMode),
                ),
              ),
            ),
          ],
          width: 128,
          child: creatTextField(
            context,
            controller: editInfoController.housePrice,
            hintText: "价格",
            keyboardType: TextInputType.number,
            validator: (text) => (text?.length ?? 0) < 1 ? '价格不能为空' : null,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp('[0-9]+[.]?[0-9]*'),
              ),
            ],
          )),
      Obx(
        () {
          if (editInfoController.houseTardType.firstValue ==
              HouseModel.sellHouse) {
            return Column(
              children: [
                FromItem(
                  label: "支付方式",
                  child: SelectPopMenu(
                    key: UniqueKey(),
                    canMultiple: true,
                    controller: editInfoController.buyPayType,
                  ),
                ),
                const SizedBox(height: 20),
                FromItem(
                  label: "面积",
                  actions: [
                    const SizedBox(width: 10),
                    Text(
                      '平方米',
                      style: TextStyle(
                        color: labelColor(context.isDarkMode),
                      ),
                    ),
                  ],
                  width: 128,
                  child: creatTextField(
                    context,
                    controller: editInfoController.houseArea,
                    hintText: '面积',
                    keyboardType: TextInputType.number,
                    validator: (text) =>
                        (text?.length ?? 0) < 1 ? '面积不能为空' : null,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp('[0-9]+[.]?[0-9]*'))
                    ],
                  ),
                ),
              ],
            );
          }
          if (editInfoController.houseTardType.firstValue ==
              HouseModel.rentHouse) {
            return Column(
              children: [
                FromItem(
                  label: "支付方式",
                  child: SelectPopMenu(
                    key: UniqueKey(),
                    canMultiple: true,
                    controller: editInfoController.rentPayType,
                  ),
                ),
                const SizedBox(height: 20),
                FromItem(
                  label: "租房类型",
                  child: SelectPopMenu(
                    width: 64,
                    controller: editInfoController.rentType,
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('请选择交易方式'));
        },
      ),
      FromItem(
        label: "房屋描述",
        child: creatTextField(
          context,
          controller: editInfoController.decoration,
          hintText: "房屋描述",
          maxLines: 4,
          validator: (text) => (text?.length ?? 0) < 3 ? '房屋描述不能少于3个字符' : null,
        ),
      ),
      FromItem(
        label: '房屋图像',
        isRight: false,
        child: SelectImg(controller: editInfoController.houseFile),
      ),
      FromItem(
        label: '',
        child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isCreat)
                  creatButon(
                    context,
                    label: "清空",
                    width: 64,
                    onTap: () => editInfoController.clearHouseInfo(),
                  ),
                const SizedBox(width: 20),
                creatButon(
                  context,
                  label: isCreat ? "发布" : "修改",
                  width: 64,
                  onTap: () => ok(() async {
                    if (editInfoController.houseTerritory.province == null) {
                      throw '请选择省份';
                    }
                    if (editInfoController.houseAddrCode.county == null) {
                      throw '至少选择至县区';
                    }
                    if (editInfoController.houseTardType.firstValue.isEmpty) {
                      throw '请选择交易方式';
                    }
                    if (!(formKey.currentState?.validate() ?? true)) {
                      throw '请检查输入';
                    }
                    if (editInfoController.houseFile.isAction) {
                      throw '请等待图片上传完成';
                    }
                    if (editInfoController.houseFile.imageUrl.length < 3) {
                      throw '至少上传3张图片';
                    }
                    bool res;
                    if (isCreat) {
                      res = await controller.addHouse();
                    } else {
                      if (id != null) {
                        res = await controller.editHouse(id!);
                      } else {
                        res = false;
                      }
                    }
                    onDone?.call();
                    // editInfoController.clearHouseInfo();
                    return res;
                  }),
                ),
              ],
            )),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return creatFrom(context);
  }
}

Future<dynamic> toHouseInfo(
        [bool isPage = true,
        bool isCreat = true,
        int? id,
        Function()? onDone]) async =>
    toFrom(
      _HouseInfoView(isCreat, id, onDone),
      isCreat ? '发布房源' : '修改房源',
      isPage,
      Adaptive.getWidth() * .6,
    );
