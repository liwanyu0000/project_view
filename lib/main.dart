import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

import 'config/constants.dart';
import 'config/themes.dart';
import 'pages/pages.dart';
import 'services/profile.dart';
import 'services/http.dart';
import 'services/logger.dart';
import 'services/translation.dart';
import 'utils/utils.dart';

Future<void> initServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  // put会产生日志，需要在put之前初始化logger，并Hook到Get.log
  final logger = LoggerService(
    prefix: kProductName,
    level: Level.trace,
    skipWidgetBuildTrace: true,
  );
  Get.log = (String message, {bool isError = false}) {
    logger.log(isError ? Level.error : Level.debug, message, tag: ['GETX']);
  };
  Get.put(logger);
  if (!Adaptive.isWeb) {
    await Get.putAsync(
      () async =>
          ProfileService(kProductName, await getCacheDirectory()).init(),
    );
  }
  Get.put(HttpService(logger, baseUrl: 'http://47.109.25.126/api'));
  SmartDialog.config.attach =
      SmartConfigAttach(attachAlignmentType: SmartAttachAlignmentType.inside);
  if (Adaptive.isDesktop) {
    // 初始化window_manager窗口
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      title: kProductName,
      size: defaultWindowSize,
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden, // 是否隐藏系统导航栏
      windowButtonVisibility: false,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      windowManager.setAsFrameless(); // 无边框
      windowManager.setHasShadow(true); // 是否有阴影
      windowManager.setMinimumSize(minWindowSize); // 最小尺寸
      await windowManager.show();
      await windowManager.focus();
    });
  }
}

void unCaughtException(Object err, StackTrace? stackTrace) {
  LoggerService.to.e(err, tag: ['UnCaughtException'], stackTrace: stackTrace);
  if (err is HttpServiceException) {
    if (err.response.statusCode == -3) {}
  }
}

void main() async {
  // FlutterError.onError =
  //     (details) => unCaughtException(details.exception, details.stack);

  // runZonedGuarded(
  //   () async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await CustomNotification.requestNotificationPermissions();
  await initServices();
  runApp(
    GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 300),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', ''),
        Locale('zh', ''),
        Locale('he', ''),
        Locale('es', ''),
        Locale('ru', ''),
        Locale('ko', ''),
        Locale('hi', ''),
      ],
      getPages: Pages.routes,
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
      translations: TranslationService(),
      builder: FlutterSmartDialog.init(), //FlutterSmartDialog框架初始化
    ),
  );
  // https://stackoverflow.com/questions/56608171/how-to-make-flutter-app-draw-behind-android-navigation-bar-and-make-navigation-b
  // 解决移动端顶部和底部沉浸体验问题
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  // },
  //   unCaughtException,
  // );
}
