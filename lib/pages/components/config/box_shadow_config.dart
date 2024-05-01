import 'package:flutter/material.dart';

List<BoxShadow> boxShadowConfig({
  Color color = Colors.black,
  int a = 6,
  int num = 4,
  Offset offset = const Offset(0, 2),
  double blurRadius = 2,
  double spreadRadius = 0.0,
}) =>
    List.generate(
      num,
      (index) => BoxShadow(
        color: color.withAlpha(a * (index + 1)), // 阴影的颜色
        offset: offset, // 阴影与容器的距离
        blurRadius: blurRadius + index, // 高斯的标准偏差与盒子的形状卷积。
        spreadRadius: spreadRadius,
      ),
    );

List<BoxShadow> contentBlockBoxShadow(bool isDarkMode) => isDarkMode
    ? [
        const BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.04),
          offset: Offset(0, 4),
          blurRadius: 4,
          spreadRadius: -1,
        ),
        const BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.08),
          offset: Offset(0, 1),
          blurRadius: 1,
          spreadRadius: 0,
        ),
      ]
    : const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.09),
          offset: Offset(0, 1),
          blurRadius: 4,
          spreadRadius: -1,
        )
      ];
