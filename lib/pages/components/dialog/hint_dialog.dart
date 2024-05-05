import 'package:flutter/material.dart';

import '../base_dialog.dart';

void showHintDialog(
  void Function() operate, {
  String? label,
  List<Widget>? actions,
  double? width,
  double? height,
}) =>
    showSmartDialog(
      width: width ?? 320,
      height: height ?? 200,
      contentPadding:
          const EdgeInsets.only(left: 24, top: 24, bottom: 24, right: 24),
      child: Text(label ?? "您确定要删除吗？"),
    );

Future<bool> quitPageDialog(
  bool isEdit, {
  double? width,
  double? height,
  String? label,
}) async {
  bool quit = true;
  if (isEdit) {
    quit = false;
    await showSmartDialog(
      width: width ?? 320,
      height: height ?? 150,
      contentPadding:
          const EdgeInsets.only(left: 24, top: 24, bottom: 24, right: 24),
      child: Text(label ?? "当前有未保存的内容，是否放弃编辑？"),
    );
  }
  return quit;
}
