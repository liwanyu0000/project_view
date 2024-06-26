import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/model/house/house.dart';
import 'package:project_view/pages/components/from_view/show_house_info_view.dart';
import '../../../model/trade/trade.dart';
import '../../../utils/utils.dart';
import '../config/size_config.dart';
import '../custom_circle_avatar.dart';
import 'base_from_view.dart';

class TradeView extends BaseFromView {
  const TradeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
          itemBuilder: (context, index) {
            final e = controller.tradeList[index];
            return GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        CustomCircleAvatar(
                          text: e.buyer.nickName,
                          avatarImageUrl: e.buyer.avatar,
                          radius: iconSizeConfig.middleAvatarIconSize,
                          fontSize: iconSizeConfig.middleAvatarIconSize,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(e.tradeType == HouseModel.rentHouse
                                  ? '租'
                                  : '买'),
                              Text("发起于：${stringify(e.createdAt)}"),
                              Text(e.status.tr),
                              Text("结束于： ${stringify(e.finishAt) ?? ''}"),
                            ],
                          ),
                        ),
                        CustomCircleAvatar(
                          text: e.seller.nickName,
                          avatarImageUrl: e.seller.avatar,
                          radius: iconSizeConfig.middleAvatarIconSize,
                          fontSize: iconSizeConfig.middleAvatarIconSize,
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        ElevatedButton(
                          onPressed: () async {
                            HouseModel model =
                                await controller.houseRepo.getHouse(e.houseId);
                            toShowHouse(model, Adaptive.isSmall());
                          },
                          child: const Text('房屋详情'),
                        ),
                        const SizedBox(width: 20),
                        if (e.status == TradeModel.tradeStatusStart &&
                            e.seller.id == controller.me?.id) ...[
                          ElevatedButton(
                            onPressed: () {
                              controller.tradeRepo.updateTrade(
                                  e.id,
                                  e.setState(TradeModel.tradeStatusFinish),
                                  true);
                            },
                            child: const Text('完成'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              controller.tradeRepo.updateTrade(
                                  e.id, e.setState(TradeModel.tradeStatusPass));
                            },
                            child: const Text('拒绝'),
                          ),
                        ],
                        if (e.status == TradeModel.tradeStatusStart &&
                            e.buyer.id == controller.me?.id)
                          ElevatedButton(
                            onPressed: () {
                              controller.tradeRepo.updateTrade(e.id,
                                  e.setState(TradeModel.tradeStatusCancel));
                            },
                            child: const Text('取消'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemCount: controller.tradeList.length),
    );
  }

  @override
  List<Widget> creatItems(BuildContext context, GlobalKey<FormState> formKey) {
    return controller.tradeList
        .map((e) => Row(
              children: [
                const SizedBox(width: 20),
                CustomCircleAvatar(
                  text: e.buyer.nickName,
                  avatarImageUrl: e.buyer.avatar,
                  radius: iconSizeConfig.middleAvatarIconSize,
                  fontSize: iconSizeConfig.middleAvatarIconSize,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(e.tradeType == HouseModel.rentHouse ? '租' : '买'),
                      Text(stringify(e.createdAt) ?? ''),
                      Text(e.status.tr),
                      Text(stringify(e.finishAt) ?? ''),
                      if (e.status == TradeModel.tradeStatusStart &&
                          e.seller.id == controller.me?.id)
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                //TODO: 通过交易
                              },
                              child: const Text('完成'),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                //TODO 拒绝交易
                              },
                              child: const Text('拒绝'),
                            ),
                          ],
                        ),
                      if (e.status == TradeModel.tradeStatusStart &&
                          e.buyer.id == controller.me?.id)
                        ElevatedButton(
                          onPressed: () {
                            //TODO: 取消交易
                          },
                          child: const Text('取消'),
                        ),
                    ],
                  ),
                ),
                CustomCircleAvatar(
                  text: e.seller.nickName,
                  avatarImageUrl: e.seller.avatar,
                  radius: iconSizeConfig.middleAvatarIconSize,
                  fontSize: iconSizeConfig.middleAvatarIconSize,
                ),
                const SizedBox(width: 20),
              ],
            ))
        .toList();
  }
}

Future<dynamic> toTradeView([bool isPage = true]) async =>
    toFrom(const TradeView(), '交易管理', isPage, Adaptive.getWidth() * .6);
