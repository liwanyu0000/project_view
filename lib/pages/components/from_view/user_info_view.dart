import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/pages/components/select_popmenu.dart';

import '../../../utils/area.dart';
import '../../../utils/utils.dart';
import '../area_filter.dart';
import '../config/config.dart';
import 'base_from_view.dart';
import '../from_view/from_item.dart';

class _UserInfoView extends BaseFromView {
  const _UserInfoView();
  @override
  List<Widget> creatItems(BuildContext context, GlobalKey<FormState> formKey) =>
      [
        FromItem(
          label: '昵称',
          child: creatTextField(context,
              controller: editInfoController.nickName,
              hintText: '昵称',
              validator: (value) => value!.isEmpty ? '昵称不能为空' : null),
        ),
        FromItem(
          label: '性别',
          child: SelectPopMenu(
            width: 64,
            controller: editInfoController.sex,
          ),
        ),
        FromItem(
          label: '手机号',
          child: creatTextField(context,
              controller: editInfoController.phones, hintText: '手机号'),
        ),
        FromItem(
          label: '邮箱',
          child: creatTextField(context,
              controller: editInfoController.emails, hintText: '邮箱'),
        ),
        FromItem(
          label: '省份',
          child: ProvinceFilter(
            area: controller.area!,
            controller: editInfoController.province,
            initProvice: editInfoController.initAddrCode,
          ),
        ),
        Obx(
          () => FromItem(
            label: "市/县区/镇",
            child: editInfoController.province.province == null
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
                        key: UniqueKey(),
                        childWidth: constraints.maxWidth * .3,
                        province: editInfoController.province.province!,
                        controller: editInfoController.addrCode,
                        initNode: initCode,
                      );
                    },
                  ),
          ),
        ),
        FromItem(
          label: '详细地址',
          child: creatTextField(context,
              controller: editInfoController.addr, hintText: '详细地址'),
        ),
        FromItem(
          label: '生日',
          child: creatTextField(context,
              controller: editInfoController.birthday, hintText: '生日'),
        ),
        FromItem(
          label: '个性签名',
          child: creatTextField(context,
              controller: editInfoController.signature, hintText: '个性签名'),
        ),
        FromItem(
          label: '兴趣爱好',
          child: creatTextField(context,
              controller: editInfoController.favorite, hintText: '兴趣爱好'),
        ),
        FromItem(
          label: '',
          child: Align(
            alignment: Alignment.centerRight,
            child: creatButon(
              context,
              label: "修改信息",
              width: 64,
              onTap: () => ok(() async {
                if (!(formKey.currentState?.validate() ?? true)) {
                  throw '请检查输入';
                }
                await controller.changeInfo();
                editInfoController.clearUserInfo();
                return true;
              }),
            ),
          ),
        )
      ];

  @override
  Widget build(BuildContext context) {
    return creatFrom(context);
  }
}

Future<dynamic> toUserInfo([bool isPage = true]) async => toFrom(
      const _UserInfoView(),
      '修改用户信息',
      isPage,
      Adaptive.getWidth() * .5,
    );
