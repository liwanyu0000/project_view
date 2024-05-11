import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/model/user/user_extra_info.dart';
import 'package:project_view/pages/components/select_popmenu.dart';
import 'package:project_view/utils/area.dart';

import '../../../utils/utils.dart';
import '../area_filter.dart';
import '../config/config.dart';
import 'base_from_view.dart';
import 'from_Item.dart';

class _UserInfoView extends BaseFromView {
  const _UserInfoView();
  @override
  List<Widget> creatItems(BuildContext context, GlobalKey<FormState> formKey) =>
      [
        FromItem(
          label: '昵称',
          child: creatTextField(context, 'nickName',
              hintText: '昵称',
              validator: (value) => value!.isEmpty ? '昵称不能为空' : null),
        ),
        FromItem(
          label: '性别',
          child: SelectPopMenu(
            item: const [
              SelectData(label: '男', value: UserExtraInfoModel.sexMan),
              SelectData(label: '女', value: UserExtraInfoModel.sexWoman),
              SelectData(label: '保密', value: UserExtraInfoModel.sexUnknown),
            ],
            width: 64,
            onSelect: (value) {
              controller.setEditInfo('sex', value.value);
            },
            initValue:
                controller.getEditInfo('sex') ?? UserExtraInfoModel.sexUnknown,
          ),
        ),
        FromItem(
          label: '手机号',
          child: creatTextField(context, 'phones', hintText: '手机号'),
        ),
        FromItem(
          label: '邮箱',
          child: creatTextField(context, 'emails', hintText: '邮箱'),
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                FromItem(
                  label: '省份',
                  child: ProvinceFilter(
                    area: controller.area!,
                    initProvice: AreaNode.getProvinceCode(
                        controller.getEditInfo('addrCode')),
                    onSelected: (node) {
                      controller.setEditInfo('provinceNode', node);
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 20),
                FromItem(
                  label: "市/县区/镇",
                  child: controller.getEditInfo('addrCode') == null
                      ? Text(
                          '请先选择省份',
                          style:
                              TextStyle(color: labelColor(context.isDarkMode)),
                        )
                      : AreaFilter(
                          key: UniqueKey(),
                          province: controller.getEditInfo('provinceNode') ??
                              controller.area!.findFromCode(
                                      AreaNode.getProvinceCode(
                                          controller.getEditInfo('addrCode')))
                                  as ProvinceAreaNode,
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
          label: '详细地址',
          child: creatTextField(context, 'addr', hintText: '详细地址'),
        ),
        FromItem(
          label: '生日',
          child: creatTextField(context, 'birthday', hintText: '生日'),
        ),
        FromItem(
          label: '个性签名',
          child: creatTextField(context, 'signature', hintText: '个性签名'),
        ),
        FromItem(
          label: '兴趣爱好',
          child: creatTextField(context, 'favorite', hintText: '兴趣爱好'),
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
                controller.selectImgController.clean();
                return true;
              }),
            ),
          ),
        )
      ];

  @override
  Widget build(BuildContext context) {
    controller.setEditInfo('provinceNode', null);
    return creatFrom(context);
  }
}

Future<dynamic> toUserInfo([bool isPage = true]) async => toFrom(
      const _UserInfoView(),
      '修改用户信息',
      isPage,
      Adaptive.getWidth() * .5,
    );
