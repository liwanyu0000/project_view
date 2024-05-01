import 'package:flutter/material.dart';

import 'config.dart';

TextStyle primaryTextStyle(isDarkMode) => TextStyle(
  color: labelColor(isDarkMode),
  fontSize: textSizeConfig.primaryTextSize,
);

TextStyle secondaryTextStyle(isDarkMode) => TextStyle(
  color: labelColor(isDarkMode),
  fontSize: textSizeConfig.secondaryTextSize,
);