import 'package:get/get.dart';
import 'package:project_view/pages/message/binding.dart';

import 'favorite/binding.dart';
import 'favorite/view.dart';
import 'front/binding.dart';
import 'front/view.dart';
import 'home/binding.dart';
import 'home/view.dart';
import 'message/view.dart';
import 'person/binding.dart';
import 'person/view.dart';

class Pages {
  static const String home = '/home';
  static const String front = '/home/front';
  static const String message = '/home/message';
  static const String favorite = '/home/favorite';
  static const String person = '/home/person';

  static const initialRoute = front;

  static Transition? get transition => Transition.fadeIn;

  static const List<String> routeNames = [front, message, '', favorite, person];

//cupertino;leftToRightWithFad
  static final routes = [
    GetPage(
      participatesInRootNavigator: true,
      preventDuplicates: true,
      name: home,
      binding: HomeBinding(),
      page: () => const HomeView(),
      children: [
        GetPage(
          name: '/front',
          binding: FrontBinding(),
          page: () => const FrontView(),
          transition: transition,
        ),
        GetPage(
          name: '/message',
          binding: MessageBinding(),
          page: () => const MessageView(),
          transition: transition,
        ),
        GetPage(
          name: '/favorite',
          binding: FavoriteBinding(),
          page: () => const FavoriteView(),
          transition: transition,
        ),
        GetPage(
          name: '/person',
          binding: PersonBinding(),
          page: () => const PersonView(),
          transition: transition,
        ),
      ],
      transition: Transition.noTransition,
    ),
  ];
}
