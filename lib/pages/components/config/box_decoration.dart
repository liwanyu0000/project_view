import 'package:flutter/material.dart';

import 'color_config.dart';

BoxDecoration contentBlockdecoratedBox(bool isDarkMode) {
  return BoxDecoration(
    color: contentBlockColor(isDarkMode),
    border: Border.all(
      color: contentBlockBorderColor(isDarkMode),
    ),
    borderRadius: BorderRadius.circular(6.0),
    boxShadow: isDarkMode
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
          ],
  );
}
