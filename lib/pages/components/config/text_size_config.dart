class TextSizeConfig {
  /// 主要文字
  final double primaryTextSize;

  /// 次要文字
  final double secondaryTextSize;

  /// 标签文字
  final double labelTextSize;

  /// 大标题文字
  final double bigTitleTextSize;

  /// 内容文字
  final double contentTextSize;

  /// 辅助文字
  final double assistTextSize;

  const TextSizeConfig({
    required this.primaryTextSize,
    required this.secondaryTextSize,
    required this.labelTextSize,
    required this.bigTitleTextSize,
    required this.contentTextSize,
    required this.assistTextSize,
  });
}

/// 小文字配置
const TextSizeConfig _smallTextConfig = TextSizeConfig(
  primaryTextSize: 13,
  secondaryTextSize: 12,
  labelTextSize: 11,
  bigTitleTextSize: 22,
  contentTextSize: 15,
  assistTextSize: 9,
);

const TextSizeConfig _smallPTextConfig = TextSizeConfig(
  primaryTextSize: 13 + 2,
  secondaryTextSize: 12 + 2,
  labelTextSize: 11 + 2,
  bigTitleTextSize: 22 + 2,
  contentTextSize: 15 + 2,
  assistTextSize: 9 + 2,
);

void setText(bool isSmell) =>
    textSizeConfig = isSmell ? _smallPTextConfig : _smallTextConfig;

/// 当前使用的文字配置
TextSizeConfig textSizeConfig = _smallTextConfig;
