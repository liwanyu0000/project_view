class IconSizeConfig {
  /// 主要图标
  final double primaryIconSize;

  /// 次要图标
  final double secondaryIconSize;

  /// 辅助图标
  final double assistIconSize;

  /// 巨大头像图标
  final double hugAvatarIconSize;

  /// 大头像图标
  final double bigAvatarIconSize;

  /// 中头像图标
  final double middleAvatarIconSize;

  /// 小头像图标
  final double smallAvatarIconSize;

  const IconSizeConfig({
    required this.primaryIconSize,
    required this.secondaryIconSize,
    required this.assistIconSize,
    required this.hugAvatarIconSize,
    required this.bigAvatarIconSize,
    required this.middleAvatarIconSize,
    required this.smallAvatarIconSize,
  });
}

/// 小文字配置
const IconSizeConfig _smallIconConfig = IconSizeConfig(
    primaryIconSize: 16,
    secondaryIconSize: 14,
    assistIconSize: 12,
    hugAvatarIconSize: 60,
    bigAvatarIconSize: 24,
    middleAvatarIconSize: 18,
    smallAvatarIconSize: 16);

/// 当前使用的文字配置
IconSizeConfig iconSizeConfig = _smallIconConfig;
