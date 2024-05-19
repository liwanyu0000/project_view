import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:project_view/model/user/user.dart';
import 'package:project_view/model/user/user_extra_info.dart';
import 'package:project_view/pages/components/base_dialog.dart';
import 'package:project_view/pages/components/custom_circle_avatar.dart';
import 'package:project_view/pages/components/custom_tool_tip.dart';
import 'package:project_view/pages/components/from_view/from_item.dart';
import 'package:project_view/pages/components/select_popmenu.dart';
import '../../../utils/utils.dart';
import '../area_filter.dart';
import '../config/config.dart';
import '../customize_widget.dart';
import 'base_from_view.dart';

class UsersManageView extends BaseFromView {
  const UsersManageView({
    super.key,
  });

  void search() {
    controller.userRepo
        .search(
      addrCode: editInfoController.addrCode.code,
      userPermission: editInfoController.permission.firstValue,
      q: editInfoController.search.text,
    )
        .then((value) {
      editInfoController.users = value;
    });
  }

  Widget _creatSexIcon(String sex) {
    switch (sex) {
      case UserExtraInfoModel.sexMan:
        return Icon(Icons.male,
            color: Colors.blue, size: iconSizeConfig.primaryIconSize * 1.5);
      case UserExtraInfoModel.sexWoman:
        return Icon(Icons.female,
            color: Colors.red, size: iconSizeConfig.primaryIconSize * 1.5);
      default:
        return Icon(Icons.question_mark,
            color: Colors.grey, size: iconSizeConfig.primaryIconSize * 1.5);
    }
  }

  List<Widget> _creatFilterItem(BuildContext context) => [
        FromItem(
          label: '省份',
          child: ProvinceFilter(
            area: controller.area!,
            controller: editInfoController.province,
          ),
        ),
        const SizedBox(height: 10),
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
                      return AreaFilter(
                        key: UniqueKey(),
                        childWidth: constraints.maxWidth * .3,
                        province: editInfoController.province.province!,
                        controller: editInfoController.addrCode,
                      );
                    },
                  ),
          ),
        ),
        const SizedBox(height: 10),
        FromItem(
          label: '用户权限',
          child: SelectPopMenu(
            width: 100,
            controller: editInfoController.permission,
          ),
        ),
        const SizedBox(height: 10),
        FromItem(
          label: '搜索',
          child: creatTextField(
            context,
            controller: editInfoController.search,
            hintText: '请输入用户昵称/手机/邮箱/详细地址等信息',
          ),
        ),
      ];

  Widget _creatInfoItem(String text, [double? width]) => CustomToolTip(
        text: text,
        child: Container(
          width: width ?? 64,
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );

  @override
  List<Widget> creatItems(BuildContext context, GlobalKey<FormState> formKey) {
    return [
      SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => CustomizeWidget(
                icon: editInfoController.isExpanded
                    ? Icons.filter_alt
                    : Icons.filter_alt_outlined,
                label: editInfoController.isExpanded ? '收起筛选条件' : '展开筛选条件',
                onTap: () => editInfoController.isExpanded =
                    !editInfoController.isExpanded,
                config: CustomizeWidgetConfig(
                  iconSize: iconSizeConfig.bigAvatarIconSize,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
            CustomizeWidget(
              icon: Icons.clear,
              label: '清除筛选条件',
              onTap: () {
                editInfoController.clearUsersFilter;
                search();
              },
              config: CustomizeWidgetConfig(
                iconSize: iconSizeConfig.bigAvatarIconSize,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ],
        ),
      ),
      Obx(
        () {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
            height: editInfoController.isExpanded
                ? min(Adaptive.getHeight(context) * .3, 242)
                : 0,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(10),
              color: context.isDarkMode
                  ? const Color(0xff20212e)
                  : const Color(0xfff3f5f7),
              child: ListView(
                shrinkWrap: true,
                children: _creatFilterItem(context),
              ),
            ),
          );
        },
      ),
      Obx(
        () => editInfoController.isExpanded
            ? Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: creatButon(context,
                      label: '搜索', width: 64, onTap: search),
                ),
              )
            : const SizedBox(),
      ),
      const SizedBox(height: 10),
      Obx(
        () => Expanded(
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                UserModel user = editInfoController.users[index];
                ScrollController scrollController = ScrollController();
                return SizedBox(
                  height: 32,
                  child: Row(
                    children: [
                      CustomCircleAvatar(
                        text: user.nickName,
                        avatarImageUrl: user.avatar,
                        radius: iconSizeConfig.middleAvatarIconSize,
                        fontSize: iconSizeConfig.middleAvatarIconSize,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Scrollbar(
                          controller: scrollController,
                          child: ListView(
                            controller: scrollController,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              _creatInfoItem(user.userName),
                              const SizedBox(width: 5),
                              _creatInfoItem(user.nickName),
                              _creatSexIcon(user.extraInfo.sex),
                              const SizedBox(width: 5),
                              _creatInfoItem(user.phones ?? '', 76),
                              const SizedBox(width: 5),
                              _creatInfoItem(user.emails ?? '', 76),
                              const SizedBox(width: 5),
                              _creatInfoItem(user.addr ?? ''),
                              const SizedBox(width: 5),
                              _creatInfoItem(user.addrCode ?? '', 76),
                              const SizedBox(width: 5),
                              _creatInfoItem(
                                  stringify(user.createTime) ?? '', 144),
                              const SizedBox(width: 5),
                              _creatInfoItem(
                                  stringify(user.updateTime) ?? '', 144),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      creatButon(context, label: "修改权限", onTap: () {
                        SelectController selectController =
                            SelectController(const [
                          SelectData(
                              label: '管理员', data: UserModel.permissionAdmin),
                          SelectData(
                              label: '可登录', data: UserModel.permissionLogin),
                          SelectData(
                              label: '可发布', data: UserModel.permissionPublish),
                        ]);
                        showSmartDialog(
                          dialogTag: 'editPermission',
                          height: 164,
                          keepSingle: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SelectPopMenu(
                                controller: selectController,
                                initValue: user.permissionList,
                                canMultiple: true,
                                width: 240,
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: creatButon(
                                  context,
                                  label: '确定',
                                  width: 64,
                                  onTap: () {
                                    String permission =
                                        selectController.selectValue.join('');
                                    controller.userRepo
                                        .changePermission(user.id, permission);
                                    editInfoController.users[index] =
                                        user.copyWith(permission: permission);
                                    SmartDialog.dismiss(tag: 'editPermission');
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: editInfoController.users.length),
        ),
      ),
    ];
  }

  @override
  Widget creatFrom(BuildContext context) {
    List<Widget> item = creatItems(context, GlobalKey<FormState>());
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: item);
  }

  @override
  Widget build(BuildContext context) {
    search();
    return creatFrom(context);
  }
}

Future<dynamic> toUsersManageView([bool isPage = true]) async =>
    toFrom(const UsersManageView(), '用户管理', isPage, Adaptive.getWidth() * .6);
