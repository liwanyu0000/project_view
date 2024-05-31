import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/model/house/house.dart';
import 'package:project_view/pages/components/config/config.dart';
import 'package:project_view/pages/components/custom_circle_avatar.dart';
import 'package:project_view/pages/components/custom_tool_tip.dart';
import 'package:project_view/utils/area.dart';
import 'package:project_view/utils/utils.dart';

class HouseCard extends StatelessWidget {
  final HouseModel model;
  final AreaNode? areaNode;
  final bool isOwner;
  final bool isAdmin;
  final bool isLogin;
  final Function(String key)? operate;
  const HouseCard({
    super.key,
    required this.model,
    required this.isOwner,
    required this.isAdmin,
    required this.isLogin,
    required this.areaNode,
    this.operate,
  });

  AreaNode? get ownerArea =>
      areaNode?.findFromCode(model.houseOwner.addrCode ?? '');
  AreaNode? get houseArea => areaNode?.findFromCode(model.houseAddrCode);

  Widget _creatText(
    BuildContext context,
    String? text, {
    EdgeInsetsGeometry? padding,
    double? fontSize,
    Color? color,
    int? maxLines,
    TextAlign? textAlign,
  }) =>
      CustomToolTip(
        text: text,
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text ?? '',
            style: TextStyle(
              fontSize: fontSize ?? textSizeConfig.primaryTextSize,
              color: color ?? logTextEmphasisColor(context.isDarkMode),
            ),
            maxLines: maxLines ?? 1,
            overflow: TextOverflow.ellipsis,
            textAlign: textAlign ?? TextAlign.center,
          ),
        ),
      );
  Widget _actionItem(String key, String label, [void Function()? onPressed]) =>
      Expanded(
        child: ElevatedButton(
          onPressed: onPressed ?? () => operate?.call(key),
          child: Text(label),
        ),
      );

  List<Widget> _defautAction() => [
        _actionItem(HouseModel.houseOperateEdit, '编辑'),
        const SizedBox(width: 10),
        _actionItem(HouseModel.houseOperateDelete, '删除', () {
          Get.defaultDialog(
            title: '删除确认',
            middleText: '确定取消发布该房源吗？',
            textConfirm: '确定',
            textCancel: '取消',
            onConfirm: () {
              operate?.call(HouseModel.houseOperateDelete);
              Get.back();
            },
          );
        }),
      ];
  List<Widget> _creatAction() {
    List<Widget> items = [_actionItem(HouseModel.houseOperateDetail, '详情')];
    if (!isLogin) return items;
    List<Widget> extern = [];
    switch (model.houseState) {
      case HouseModel.houseStatusAudit:
        extern = isOwner
            ? _defautAction()
            : (isLogin
                ? [_actionItem(HouseModel.houseOperateReview, '审核')]
                : []);
        break;
      case HouseModel.houseStatusPublish:
        extern = isOwner
            ? _defautAction()
            : [
                _actionItem(HouseModel.houseOperateContact, model.showTardetext)
              ];
        break;
      case HouseModel.houseStatusComplete:
        extern =
            isOwner ? [_actionItem(HouseModel.houseOperateRecord, '交易记录')] : [];
        break;
      case HouseModel.houseStatusOff:
      case HouseModel.houseStatusNotPass:
        extern =
            isOwner ? [_actionItem(HouseModel.houseOperateNewEdit, '编辑')] : [];
        break;
      default:
        extern = [];
    }
    if (extern.isEmpty) return items;
    return [...items, const SizedBox(width: 10), ...extern];
  }

  @override
  Widget build(BuildContext context) {
    double headRadius = Adaptive.isSmall(context)
        ? iconSizeConfig.hugAvatarIconSize / 2
        : iconSizeConfig.hugAvatarIconSize;
    final Widget status = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: model.status.color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        model.status.label,
        style: const TextStyle(color: Colors.white),
      ),
    );
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 4),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (Adaptive.isSmall(context))
            Row(
              children: [
                Expanded(
                  child: _creatText(context, model.houseInfo.decoration),
                ),
                status
              ],
            ),
          Flexible(
              child: Row(children: [
            SizedBox(
              width: headRadius * 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomCircleAvatar(
                    text: model.houseOwner.nickName,
                    avatarImageUrl: model.houseOwner.avatar,
                    radius: headRadius,
                    fontSize: headRadius,
                  ),
                  const SizedBox(height: 5),
                  _creatText(
                    context,
                    model.houseOwner.nickName,
                    fontSize: textSizeConfig.bigTitleTextSize,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 5),
                  _creatText(
                    context,
                    ownerArea?.province,
                    fontSize: textSizeConfig.secondaryTextSize,
                    color: labelColor(context.isDarkMode),
                    padding: EdgeInsets.zero,
                  ),
                  _creatText(
                    context,
                    ownerArea?.city,
                    fontSize: textSizeConfig.secondaryTextSize,
                    color: labelColor(context.isDarkMode),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int maxNum = constraints.maxWidth ~/ 300;
                  if (constraints.maxWidth % 300 > 150) maxNum++;
                  double imgWidget = constraints.maxWidth / maxNum;
                  List<Widget> imgList = [];
                  for (int i = 0;
                      i < min(maxNum, model.houseFileList.length);
                      i++) {
                    imgList.add(
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: imgWidget,
                        child: Image.network(
                          model.houseFileList[i],
                          fit: BoxFit.cover,
                          errorBuilder: (__, _, ___) => Icon(
                            Icons.error,
                            color: Colors.grey,
                            size: iconSizeConfig.hugAvatarIconSize,
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return Row(children: imgList);
                },
              ),
            ),
            if (!Adaptive.isSmall(context))
              Container(
                width: 256,
                color: Colors.grey[200],
                child: _creatText(
                  context,
                  model.housePriceStr,
                  fontSize: textSizeConfig.bigTitleTextSize + 6,
                  textAlign: TextAlign.end,
                  color: model.status.color,
                ),
              ),
          ])),
          const SizedBox(height: 10),
          Row(
            children: [
              if (!Adaptive.isSmall(context)) ...[
                SizedBox(
                  width: headRadius * 2,
                  child: Align(alignment: Alignment.center, child: status),
                ),
                Expanded(
                  flex: 3,
                  child: _creatText(
                    context,
                    model.houseInfo.decoration,
                    fontSize: textSizeConfig.contentTextSize,
                  ),
                ),
              ],
              if (Adaptive.isSmall(context))
                _creatText(
                  context,
                  model.housePriceStr,
                  fontSize: textSizeConfig.primaryTextSize,
                  textAlign: TextAlign.start,
                  color: model.status.color,
                ),
              ..._creatAction(),
            ],
          ),
        ],
      ),
    );
  }
}
