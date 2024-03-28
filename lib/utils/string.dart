extension CusString on String {
  List<String> rDSplit([Pattern pattern = '/']) =>
      split(pattern).where((e) => e.isNotEmpty).toList();

  String check({
    Pattern pattern = '/',
    String replace = '/',
    bool havePrefix = true,
  }) =>
      rDSplit(pattern).prefixJoin(str: replace, havePrefix: havePrefix);

  int rDLength([Pattern pattern = '/']) => rDSplit(pattern).length;

  String rDLast([Pattern pattern = '/']) => rDSplit(pattern).last;

  String rDFirst([Pattern pattern = '/']) => rDSplit(pattern).first;
}

extension CusList on List<String> {
  String prefixJoin({String str = '/', bool havePrefix = true}) =>
      '${havePrefix ? str : ''}${join(str)}';
}
