import 'package:flutter/material.dart';

import 'main_frame.dart';

/// 平板，网页
class NormalMainFrame extends MainFrame {
  const NormalMainFrame({
    super.key,
    required super.body,
    super.actions,
    super.title,
    super.leading,
    super.ridgetWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Theme.of(context).appBarTheme.toolbarHeight,
        title: Row(
          children: [
            SizedBox(
              height: Theme.of(context).appBarTheme.toolbarHeight,
              child: title,
            ),
          ],
        ),
        leading: leading,
        actions: actions,
      ),
      body: Row(
        children: [
          Expanded(child: body),
          SizedBox(width: ridgetWidth),
        ],
      ),
    );
  }
}
