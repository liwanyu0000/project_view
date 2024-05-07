import 'package:flutter/material.dart';

import '../base_page/base_view.dart';
import 'controller.dart';

class FavoriteView extends BaseView<FavoriteController> {
  const FavoriteView({super.key});

  @override
  Widget viewBuild(BuildContext context) {
    // TODO: implement viewBuild
    return const Center(
      child: Text("Favorite"),
    );
  }
}
