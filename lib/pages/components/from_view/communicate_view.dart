import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/model/communicate/communicate.dart';
import 'package:project_view/model/communicate/communicate_item.dart';
import 'package:project_view/model/user/user.dart';
import 'package:project_view/pages/components/config/config.dart';
import 'package:project_view/pages/components/custom_circle_avatar.dart';
import 'package:project_view/pages/components/customize_widget.dart';

import '../../../utils/utils.dart';
import 'base_from_view.dart';

class CommunicateView extends BaseFromView {
  final BaseUserModel model;
  const CommunicateView({
    super.key,
    required this.model,
  });

  int get id => model.id;

  TextEditingController get message => editInfoController.message;
  ScrollController get scrollController => editInfoController.scrollController;

  Rx<CommunicateModel>? get _communicate => controller.getCommunicate(id);
  CommunicateModel? get communicate => _communicate?.value;

  Widget _creatMessageItem(CommunicateItemModel item) {
    bool isMe = item.from == controller.me!.id;
    BaseUserModel model =
        isMe ? controller.me! : communicate!.getUserModel(controller.me!.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMe) ...[
            Text(item.text),
            const SizedBox(width: 10),
          ],
          CustomCircleAvatar(
            text: model.nickName,
            avatarImageUrl: model.avatar,
            radius: iconSizeConfig.middleAvatarIconSize,
          ),
          if (!isMe) ...[
            const SizedBox(width: 10),
            Text(item.text),
          ],
        ],
      ),
    );
  }

  void sendMessage() async {
    if (message.text.isEmpty) return;
    CommunicateItemModel item = CommunicateItemModel(
        from: controller.me!.id, text: message.text, time: DateTime.now());
    bool success = await controller.communicateRepo.addCommunicate(item, id);
    if (!success) return;
    _communicate?.update((val) => val?.add(item));
    editInfoController.scrollToLastItem();
    message.clear();
  }

  @override
  List<Widget> creatItems(BuildContext context, GlobalKey<FormState> formKey) {
    if (communicate == null) return [];
    scrollController.dispose();
    editInfoController.scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (!(scrollController.position.pixels == 0)) {
          controller.loadCommunicate(model);
        }
      }
    });
    return [
      Flexible(
        child: Obx(
          () => ListView.builder(
            controller: editInfoController.scrollController,
            shrinkWrap: true,
            reverse: true,
            itemCount: communicate!.items.length,
            itemBuilder: (context, index) =>
                _creatMessageItem(communicate!.items[index]),
          ),
        ),
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              decoration: decorationConfig(
                context,
                hintText: '输入消息',
              ),
              controller: message,
            ),
          ),
          CustomizeWidget(
            icon: Icons.send,
            onTap: sendMessage,
            config: CustomizeWidgetConfig(
              backgroundColor: Theme.of(context).colorScheme.primary,
              primaryColor: Theme.of(context).colorScheme.surface,
              iconSize: iconSizeConfig.bigAvatarIconSize,
              padding: const EdgeInsets.all(10),
              width: 64,
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget creatFrom(BuildContext context) {
    List<Widget> item = creatItems(context, GlobalKey<FormState>());
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: item);
  }

  @override
  Widget build(BuildContext context) {
    return creatFrom(context);
  }
}

Future<dynamic> toCommunicateView(BaseUserModel model,
        [bool isPage = true]) async =>
    toFrom(
        CommunicateView(model: model), '聊天', isPage, Adaptive.getWidth() * .6);
