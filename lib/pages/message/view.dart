import 'package:flutter/material.dart';

import '../base_page/base_view.dart';
import 'controller.dart';

class MessageView extends BaseView<MessageController> {
  const MessageView({super.key});

  @override
  Widget viewBuild(BuildContext context) {
    // TODO: implement viewBuild
    return const Center(
      child: Text("Message"),
    );
  }
}
