import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/model/user/user_extra_info.dart';
import 'package:project_view/pages/components/from_view/change_pwd_view.dart';
import 'package:project_view/pages/components/from_view/user_info_view.dart';
import 'package:project_view/pages/components/config/config.dart';
import 'package:project_view/pages/components/custom_circle_avatar.dart';
import 'package:project_view/pages/components/mouse_enter_exit.dart';
import 'package:project_view/pages/components/snackbar.dart';
import 'package:project_view/utils/utils.dart';

import '../../utils/area.dart';
import '../base_page/base_view.dart';
import '../components/custom_loading.dart';
import 'controller.dart';

class PersonView extends BaseView<PersonController> {
  const PersonView({super.key});

  Widget _creatIteem({
    required String title,
    String? subtitle,
    IconData? leading,
    IconData? trailing,
    Function()? onTap,
  }) =>
      ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        leading: leading != null ? Icon(leading) : null,
        trailing: trailing != null ? Icon(trailing) : null,
        onTap: onTap,
      );
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

  Widget _creatAvatar() => MouseEnterExit(
        builder: (isHover) => Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Obx(
              () => CustomCircleAvatar(
                text: controller.me?.nickName ?? "",
                radius: iconSizeConfig.hugAvatarIconSize,
                avatarImageUrl: controller.me?.avatar,
                fontSize: iconSizeConfig.hugAvatarIconSize,
              ),
            ),
            if (isHover || Adaptive.isMobile)
              Container(
                clipBehavior: Clip.antiAlias,
                width: iconSizeConfig.hugAvatarIconSize * 2,
                height: iconSizeConfig.hugAvatarIconSize * 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft:
                        Radius.circular(iconSizeConfig.hugAvatarIconSize),
                    bottomRight:
                        Radius.circular(iconSizeConfig.hugAvatarIconSize),
                  ),
                ),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () => hookExceptionWithSnackbar(
                          () async => await controller.changeAvatar()),
                      child: Obx(
                        () => Container(
                          width: iconSizeConfig.hugAvatarIconSize * 2,
                          height: iconSizeConfig.hugAvatarIconSize * .6,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5)),
                          child: controller.isUploading
                              ? const CustomLoading(
                                  text: '', color: Colors.white)
                              : Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: iconSizeConfig.hugAvatarIconSize * .3,
                                ),
                        ),
                      ),
                    )),
              ),
          ],
        ),
      );

  @override
  Widget viewBuild(BuildContext context) {
    return Align(
      alignment:
          Adaptive.isSmall(context) ? Alignment.topCenter : Alignment.center,
      child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding:
              Adaptive.isSmall(context) ? const EdgeInsets.only(top: 50) : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // head
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _creatAvatar(),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                controller.me?.nickName ?? "",
                                style: const TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (controller.me?.sex != null)
                                _creatSexIcon(controller.me!.sex),
                            ],
                          ),
                          if (controller.me?.emails != null)
                            Text(
                              controller.me?.emails ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          if (controller.me?.phones != null)
                            Text(
                              controller.me?.phones ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          if (controller.me?.addrCode != null)
                            () {
                              AreaNode? node = controller.homeController.area!
                                  .findFromCode(controller.me!.addrCode!);
                              return Text(
                                "${node?.province ?? ''} ${node?.city ?? ''} ${node?.county ?? ''} ${node?.street ?? ''} ${controller.me!.addr ?? ''}",
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              );
                            }(),
                          if (controller.me?.birthday != null ||
                              controller.me?.signature != null)
                            Text(
                              "${controller.me?.birthday ?? ''} ${controller.me?.signature ?? ''}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // body
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _creatIteem(
                      title: '我的发布',
                      leading: Icons.article,
                      onTap: () {},
                    ),
                    _creatIteem(
                      title: '交易记录',
                      leading: Icons.history,
                      onTap: () {},
                    ),
                    _creatIteem(
                      title: '修改个人信息',
                      leading: Icons.edit,
                      onTap: () {
                        controller.homeController.editInfoController
                            .setUserInfo(controller.me);
                        return toUserInfo(Adaptive.isSmall(context));
                      },
                    ),
                    _creatIteem(
                      title: '修改密码',
                      leading: Icons.password,
                      onTap: () => toChangPwd(Adaptive.isSmall(context)),
                    ),
                    _creatIteem(
                      title: '退出登录',
                      leading: Icons.logout,
                      onTap: () => controller.homeController.logout(),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
