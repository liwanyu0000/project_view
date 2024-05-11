export 'adaptive.dart';
export 'router.dart';
export 'exceptions.dart';
export 'string.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../config/constants.dart';
import 'adaptive.dart';

/// 将对象格式化为字符串，类似于`JSON.stringify`, 如果是函数先执行函数得到结果
/// 如果是Map或者Iterable，使用JsonEncoder格式化，否则使用toString
/// 如果indent不为空，使用indent格式化, indent常用取值为null或'  '
String? stringify<T>(
  T? val, {
  String? indent,
  String Function(DateTime)? dateTimeFormatter,
}) {
  if (val == null) return null;

  final effectiveVal = val is Function ? val() : val;
  if (effectiveVal is Map || effectiveVal is Iterable) {
    final encoder = JsonEncoder.withIndent(
        indent, indent != null ? (dynamic obj) => obj.toString() : null);
    return encoder.convert(effectiveVal);
  } else if (effectiveVal is DateTime) {
    dateTimeFormatter ??=
        (DateTime time) => DateFormat('yyyy-MM-dd HH:mm:ss').format(time);
    return dateTimeFormatter(effectiveVal);
  } else {
    return effectiveVal.toString();
  }
}

/// 计算给定样式文本的宽高
Size calculateTextSize(String text, {TextStyle? style}) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

DateTime? toDateTime(String? s) => s == null ? null : DateTime.parse(s);
List<T> mapList<T>(List<dynamic>? list, T Function(dynamic) toElement) =>
    list == null ? [] : list.map(toElement).toList();

///获取缓存目录
Future<String?> getCacheDirectory() async {
  if (Adaptive.isWindows) {
    print((await getApplicationCacheDirectory()).parent.parent.path);
    return join((await getApplicationCacheDirectory()).parent.parent.path,
        kProductName);
  }
  if (Adaptive.isWeb) return null;
  return (await getApplicationCacheDirectory()).path;
}
