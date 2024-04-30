import 'package:get/get.dart';

import 'home/binding.dart';
import 'home/view.dart';

class Pages {
  static const home = '/home';

  static Transition? get transition => Transition.fadeIn;
//cupertino;leftToRightWithFad
  static final routes = [
    GetPage(
      participatesInRootNavigator: true,
      preventDuplicates: true,
      name: '/home',
      bindings: [HomeBinding()],
      page: () => const HomeView(),
      // children: [],
      transition: Transition.noTransition,
    ),
  ];
}
