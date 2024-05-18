import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/model/communicate/communicate.dart';
import 'package:project_view/model/communicate/communicate_item.dart';
import 'package:project_view/pages/components/config/config.dart';
import 'package:project_view/pages/components/customize_widget.dart';

import '../../../utils/utils.dart';
import 'base_from_view.dart';

class CommunicateView extends BaseFromView {
  final int id;
  const CommunicateView({
    super.key,
    required this.id,
  });

  TextEditingController get message => editInfoController.message;

  Rx<CommunicateModel>? get _communicate => controller.getCommunicate(id);
  CommunicateModel? get communicate => _communicate?.value;

  void sendMessage() async {
    if (message.text.isEmpty) return;
    CommunicateItemModel item = CommunicateItemModel(
        from: controller.me!.id, text: message.text, time: DateTime.now());
    bool success = await controller.communicateRepo.addCommunicate(item, id);
    if (!success) return;
    _communicate?.update((val) => val?.add(item));
    message.clear();
  }

  @override
  List<Widget> creatItems(BuildContext context, GlobalKey<FormState> formKey) {
    if (communicate == null) return [];
    return [
      SizedBox(
        height: Adaptive.getHeight(context) * .5,
        child: Obx(
          () => ListView.builder(
            shrinkWrap: true,
            itemCount: communicate!.items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(communicate!.items[index].text),
              );
            },
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
  Widget build(BuildContext context) {
    return creatFrom(context);
  }
}

Future<dynamic> toCommunicateView(int id, [bool isPage = true]) async =>
    toFrom(CommunicateView(id: id), '聊天', isPage, Adaptive.getWidth() * .6);
