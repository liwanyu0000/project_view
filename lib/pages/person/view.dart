import 'package:flutter/material.dart';
import 'package:project_view/utils/adaptive.dart';

import '../base_page/base_view.dart';
import 'controller.dart';

class PersonView extends BaseView<PersonController> {
  const PersonView({super.key});

  @override
  Widget viewBuild(BuildContext context) {
    return Adaptive.isSmall(context)
        ? const Center(
            child: Text("Person"),
          )
        : Align(
            alignment: Alignment.topCenter,
            child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    Image.network(controller.me?.avatar ?? ""),
                    const Text("Person"),
                  ],
                )),
          );
  }
}
