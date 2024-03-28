/*
 * @Description: 
 * @Version: 
 * @Author: liwanyu
 * @Date: 2024-03-28 16:41:41
 * @LastEditors: liwanyu
 * @LastEditTime: 2024-03-28 16:42:03
 */
import 'package:flutter/material.dart';

import '../utils/adaptive.dart';
import 'color_schemes.g.dart';

ThemeData _buildTheme(ColorScheme colorScheme) {
  final base = ThemeData.from(useMaterial3: true, colorScheme: colorScheme);
  final uiColor = base.brightness == Brightness.light
      ? base.indicatorColor.withOpacity(0.95)
      : base.indicatorColor.withOpacity(0.8);
  const iconSize = 24.0;

  return base.copyWith(
    appBarTheme: AppBarTheme(
      toolbarHeight: kToolbarHeight,
      elevation: 1,
      titleSpacing: Adaptive.isDesktop ? 0 : null,
      backgroundColor: base.primaryColor,
      titleTextStyle: TextStyle(color: uiColor, fontWeight: FontWeight.bold),
    ),
    drawerTheme: const DrawerThemeData(
      elevation: 1,
      width: 240,
    ),
    iconTheme: IconThemeData(color: uiColor, size: iconSize),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(uiColor),
        iconSize: MaterialStateProperty.all<double>(iconSize),
      ),
    ),
  );
}

final lightTheme = _buildTheme(lightColorScheme);
final darkTheme = _buildTheme(darkColorScheme);
