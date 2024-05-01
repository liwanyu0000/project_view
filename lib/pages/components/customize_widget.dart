import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../utils/adaptive.dart';
import 'config/config.dart';
import 'custom_tool_tip.dart';
import 'mouse_enter_exit.dart';

/// 复选框配置信息
class CheckBoxConfig {
  final double? _size;
  final bool enable;
  final bool show;
  final Color? backgroundColor;
  final Color? selectBackgroundColor;
  final Color? unableBackgroundColor;
  final Color? borderColor;
  final Color? selectBorderColor;
  final Color? iconColor;
  final BorderRadiusGeometry? borderRadius;
  final IconData? iconData;
  const CheckBoxConfig({
    double? size,
    this.enable = true,
    this.show = false,
    this.backgroundColor,
    this.selectBackgroundColor,
    this.unableBackgroundColor,
    this.borderColor,
    this.selectBorderColor,
    this.iconColor,
    this.borderRadius,
    this.iconData,
  }) : _size = size;

  double get size => _size ?? iconSizeConfig.primaryIconSize;
}

/// 配置信息
class CustomizeWidgetConfig {
  final CheckBoxConfig checkBoxConfig; //复选框配置
  final double? height; //组件高
  final double? width; //组件宽
  final double? textMaxLenth; // 文字最大长度
  final Color? primaryColor; // 文字及图标颜色
  final Color? iconColor; //图标颜色
  final Color? backgroundColor; //背景颜色
  final Color? borderColor; //边框颜色
  final Color? hoverColor; //鼠标悬浮时文字及图标颜色
  final Color? hoverBackgroundColor; //鼠标悬浮时背景颜色
  final Color? hoverBorderColor; //鼠标悬浮时边框颜色
  final List<BoxShadow>? boxShadow; //阴影
  final List<BoxShadow>? hoverBoxShadow; //鼠标悬浮阴影
  final BorderRadiusGeometry? borderRadius; //边框圆角
  final double? iconSize; //图标尺寸
  final double? labelSize; //文字大小
  final double? iconsRotate; //图标旋转角度
  final double? gap; //间距
  final EdgeInsetsGeometry? padding; //内边距
  final EdgeInsetsGeometry? margin; //外边距
  final Duration? waitDuration; // tooltip等待时间
  final MouseCursor? cursor; // 鼠标悬浮样式
  final Duration? hoverExitDuration; // 鼠标悬浮延时
  final MainAxisAlignment? mainAxisAlignment; // 主轴对齐方式
  final MainAxisAlignment? endAxisAlignment; // 尾部主轴对齐方式
  final CrossAxisAlignment? crossAxisAlignment; // 交叉轴对齐方式
  final CrossAxisAlignment? endCrossAxisAlignment; // 尾部交叉轴对齐方式
  final bool? haveBorder; // 是否有边框
  final double? borderWidth; //边框宽度
  const CustomizeWidgetConfig({
    this.checkBoxConfig = const CheckBoxConfig(),
    this.height,
    this.width,
    this.textMaxLenth,
    this.primaryColor,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.hoverColor,
    this.hoverBackgroundColor,
    this.hoverBorderColor,
    this.boxShadow,
    this.hoverBoxShadow,
    this.borderRadius,
    this.iconSize,
    this.labelSize,
    this.iconsRotate,
    this.gap,
    this.padding,
    this.margin,
    this.waitDuration,
    this.hoverExitDuration,
    this.mainAxisAlignment,
    this.endAxisAlignment,
    this.crossAxisAlignment,
    this.endCrossAxisAlignment,
    this.haveBorder,
    this.borderWidth,
    this.cursor,
  });

  CustomizeWidgetConfig copyWith(CustomizeWidgetConfig? config) =>
      CustomizeWidgetConfig(
        checkBoxConfig: config?.checkBoxConfig ?? checkBoxConfig,
        height: config?.height ?? height,
        width: config?.width ?? width,
        textMaxLenth: config?.textMaxLenth ?? textMaxLenth,
        primaryColor: config?.primaryColor ?? primaryColor,
        iconColor: config?.iconColor ?? iconColor,
        backgroundColor: config?.backgroundColor ?? backgroundColor,
        borderColor: config?.borderColor ?? borderColor,
        hoverColor: config?.hoverColor ?? hoverColor,
        hoverBackgroundColor:
            config?.hoverBackgroundColor ?? hoverBackgroundColor,
        hoverBorderColor: config?.hoverBorderColor ?? hoverBorderColor,
        boxShadow: config?.boxShadow ?? boxShadow,
        hoverBoxShadow: config?.hoverBoxShadow ?? hoverBoxShadow,
        borderRadius: config?.borderRadius ?? borderRadius,
        iconSize: config?.iconSize ?? iconSize,
        labelSize: config?.labelSize ?? labelSize,
        iconsRotate: config?.iconsRotate ?? iconsRotate,
        gap: config?.gap ?? gap,
        padding: config?.padding ?? padding,
        margin: config?.margin ?? margin,
        waitDuration: config?.waitDuration ?? waitDuration,
        hoverExitDuration: config?.hoverExitDuration ?? hoverExitDuration,
        mainAxisAlignment: config?.mainAxisAlignment ?? mainAxisAlignment,
        endAxisAlignment: config?.endAxisAlignment ?? endAxisAlignment,
        haveBorder: config?.haveBorder ?? haveBorder,
        borderWidth: config?.borderWidth ?? borderWidth,
        cursor: config?.cursor ?? cursor,
      );
}

const CustomizeWidgetConfig menuItemDefaultConfig = CustomizeWidgetConfig(
  height: 40,
  padding: EdgeInsets.only(right: 15, left: 10),
  mainAxisAlignment: MainAxisAlignment.start,
  gap: 5,
);
CustomizeWidgetConfig labelDefaultConfig = CustomizeWidgetConfig(
  height: 22,
  padding: const EdgeInsets.only(left: 5, right: 5),
  margin: const EdgeInsets.only(right: 8),
  iconSize: iconSizeConfig.secondaryIconSize,
  labelSize: textSizeConfig.labelTextSize,
  // gap: 4,
  haveBorder: true,
);

class CustomizeWidget extends StatefulWidget {
  final String? label; // 文字
  final String? tooltip; // 提示文字
  final IconData? icon; // 图标
  final Widget Function(bool isHover)? prefixWidget; //前置组件
  final Widget Function(bool isHover)? endWidget; // 尾部图标
  final dynamic Function()? onTap; // 点击事件
  final dynamic Function(bool value)? onChanged; //复选框改变事件
  final bool status; //复选框状态
  final bool isCheckBox; //此参数为true时，整个组件为复选框(只有当onChanged存在时才有效)

  final double? _height; //组件高
  final double? _width; //组件宽
  final double? _gap; //间距
  final Color? _primaryColor; // 文字及图标颜色
  final EdgeInsetsGeometry? _padding; //内边距
  final EdgeInsetsGeometry? _margin; //外边距
  final bool? _haveBorder; // 是否有边框
  final double? _borderWidth;

  final CustomizeWidgetConfig? _config; //配置信息
  const CustomizeWidget({
    super.key,
    this.label,
    this.tooltip,
    this.icon,
    this.prefixWidget,
    this.endWidget,
    this.onTap,
    this.onChanged,
    this.status = false,
    this.isCheckBox = false,
    double? height,
    double? width,
    double? gap,
    Color? primaryColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    bool? haveBorder,
    double? borderWidth,
    CustomizeWidgetConfig? config,
  })  : assert(
            height == null || config == null,
            'Cannot provide both a height and a config\n'
            'To provide both, use "config: CustomizeWidgetConfig(height: height)".'),
        assert(
            width == null || config == null,
            'Cannot provide both a width and a config\n'
            'To provide both, use "config: CustomizeWidgetConfig(width: width)".'),
        assert(
            gap == null || config == null,
            'Cannot provide both a gap and a config\n'
            'To provide both, use "config: CustomizeWidgetConfig(gap: gap)".'),
        assert(
            primaryColor == null || config == null,
            'Cannot provide both a primaryColor and a config\n'
            'To provide both, use "config: CustomizeWidgetConfig(primaryColor: primaryColor)".'),
        assert(
            padding == null || config == null,
            'Cannot provide both a padding and a config\n'
            'To provide both, use "config: CustomizeWidgetConfig(padding: padding)".'),
        assert(
            margin == null || config == null,
            'Cannot provide both a margin and a config\n'
            'To provide both, use "config: CustomizeWidgetConfig(margin: margin)".'),
        assert(
            haveBorder == null || config == null,
            'Cannot provide both a haveBorder and a config\n'
            'To provide both, use "config: CustomizeWidgetConfig(haveBorder: haveBorder)".'),
        _height = height,
        _width = width,
        _gap = gap,
        _primaryColor = primaryColor,
        _padding = padding,
        _margin = margin,
        _haveBorder = haveBorder,
        _borderWidth = borderWidth,
        _config = config;

  CustomizeWidgetConfig get config => _config ?? const CustomizeWidgetConfig();

  double? get height => _height ?? config.height;
  double? get width => _width ?? config.width;
  double? get gap => _gap ?? config.gap;
  Color? get primaryColor => _primaryColor ?? config.primaryColor;
  EdgeInsetsGeometry? get padding => _padding ?? config.padding;
  EdgeInsetsGeometry? get margin => _margin ?? config.margin;
  bool get haveBorder => _haveBorder ?? config.haveBorder ?? false;
  double get borderWidth => _borderWidth ?? config.borderWidth ?? 1;

  CheckBoxConfig get checkBoxConfig => config.checkBoxConfig;
  double? get textMaxLenth => config.textMaxLenth;
  Color? get iconColor => config.iconColor;
  Color? get backgroundColor => config.backgroundColor;
  Color? get borderColor => config.borderColor;
  Color? get hoverColor => config.hoverColor;
  Color? get hoverBackgroundColor => config.hoverBackgroundColor;
  Color? get hoverBorderColor => config.hoverBorderColor;
  List<BoxShadow>? get boxShadow => config.boxShadow;
  List<BoxShadow>? get hoverBoxShadow => config.hoverBoxShadow;
  BorderRadiusGeometry? get borderRadius => config.borderRadius;
  double? get iconSize => config.iconSize;
  double? get labelSize => config.labelSize;
  double? get iconsRotate => config.iconsRotate;
  Duration? get waitDuration => config.waitDuration;
  MouseCursor get cursor => config.cursor ?? SystemMouseCursors.click;
  Duration? get hoverExitDuration => config.hoverExitDuration;
  MainAxisAlignment get mainAxisAlignment =>
      config.mainAxisAlignment ?? MainAxisAlignment.center;
  MainAxisAlignment get endAxisAlignment =>
      config.endAxisAlignment ?? MainAxisAlignment.spaceBetween;
  CrossAxisAlignment get crossAxisAlignment =>
      config.crossAxisAlignment ?? CrossAxisAlignment.center;
  CrossAxisAlignment get endCrossAxisAlignment =>
      config.endCrossAxisAlignment ?? CrossAxisAlignment.center;

  factory CustomizeWidget.menuItem({
    Key? key,
    String? label,
    String? tooltip,
    IconData? icon,
    Widget Function(bool isHover)? prefixWidget,
    Widget Function(bool isHover)? endWidget,
    dynamic Function()? onTap,
    dynamic Function(bool value)? onChanged,
    bool status = false,
    bool isCheckBox = false,
    CustomizeWidgetConfig? config,
    bool isClose = true,
  }) =>
      CustomizeWidget(
        key: key,
        label: label,
        tooltip: tooltip,
        icon: icon,
        prefixWidget: prefixWidget,
        endWidget: endWidget,
        onTap: isClose
            ? () {
                SmartDialog.dismiss();
                onTap?.call();
              }
            : onTap,
        onChanged: onChanged,
        status: status,
        isCheckBox: isCheckBox,
        config: menuItemDefaultConfig.copyWith(config),
      );

  CustomizeWidget setConfig(CustomizeWidgetConfig? config) => CustomizeWidget(
        key: key,
        label: label,
        tooltip: tooltip,
        icon: icon,
        prefixWidget: prefixWidget,
        endWidget: endWidget,
        onTap: onTap,
        onChanged: onChanged,
        status: status,
        isCheckBox: isCheckBox,
        config: config ?? this.config,
      );

  factory CustomizeWidget.label({
    Key? key,
    String? label,
    String? tooltip,
    IconData? icon,
    Widget Function(bool isHover)? prefixWidget,
    Widget Function(bool isHover)? endWidget,
    dynamic Function()? onTap,
    dynamic Function(bool value)? onChanged,
    bool status = false,
    bool isCheckBox = false,
    CustomizeWidgetConfig? config,
  }) =>
      CustomizeWidget(
        key: key,
        label: label,
        tooltip: tooltip,
        icon: icon,
        prefixWidget: prefixWidget,
        endWidget: endWidget,
        onTap: onTap,
        onChanged: onChanged,
        status: status,
        isCheckBox: isCheckBox,
        config: labelDefaultConfig.copyWith(config),
      );

  @override
  State<CustomizeWidget> createState() => _CustomizeWidgetState();
}

class _CustomizeWidgetState extends State<CustomizeWidget> {
  CheckBoxConfig get _checkBoxConfig => widget.checkBoxConfig;
  late bool _status;

  @override
  void initState() {
    super.initState();
    _status = widget.status;
  }

  Widget _creatChexkBox(bool isHover) => GestureDetector(
        onTap: widget.isCheckBox || !_checkBoxConfig.enable
            ? null
            : () {
                widget.onChanged!(_status);
                setState(() => _status = !_status);
              },
        child: Container(
          alignment: Alignment.center,
          width: _checkBoxConfig.size,
          height: _checkBoxConfig.size,
          decoration: BoxDecoration(
              color: _checkBoxConfig.enable
                  ? _status
                      ? _checkBoxConfig.selectBackgroundColor ??
                          Theme.of(context).colorScheme.primary
                      : _checkBoxConfig.backgroundColor ??
                          Theme.of(context).colorScheme.background
                  : _checkBoxConfig.unableBackgroundColor ??
                      borderColor(context.isDarkMode),
              border: Border.all(
                color: _status || !_checkBoxConfig.enable
                    ? _checkBoxConfig.selectBorderColor ??
                        Theme.of(context).primaryColor.withOpacity(0)
                    : _checkBoxConfig.borderColor ??
                        (_checkBoxConfig.show || Adaptive.isMobile || isHover
                            ? borderColor(context.isDarkMode)
                            : Theme.of(context).colorScheme.background),
              ),
              borderRadius:
                  _checkBoxConfig.borderRadius ?? BorderRadius.circular(3)),
          child: _status
              ? Icon(Icons.check,
                  size: _checkBoxConfig.size - 2,
                  color: _checkBoxConfig.iconColor ??
                      Theme.of(context).colorScheme.onPrimary)
              : const SizedBox(),
        ),
      );

  Widget _creatIcon(bool isHover) => Transform.rotate(
        angle: widget.iconsRotate ?? 0,
        child: Icon(
          widget.icon,
          size: widget.iconSize ?? iconSizeConfig.secondaryIconSize,
          color: isHover
              ? widget.hoverColor ??
                  widget.iconColor ??
                  widget.primaryColor ??
                  labelColor(context.isDarkMode)
              : widget.iconColor ??
                  widget.primaryColor ??
                  labelColor(context.isDarkMode),
        ),
      );

  Widget _creatLabel(bool isHover) => Container(
        constraints:
            BoxConstraints(maxWidth: widget.textMaxLenth ?? double.infinity),
        child: Text(
          widget.label!,
          style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: isHover
                  ? widget.hoverColor ?? widget.primaryColor
                  : widget.primaryColor,
              fontSize: widget.labelSize ?? textSizeConfig.primaryTextSize),
        ),
      );

  Widget _creatContent(bool isHover) {
    List<Widget> children = [];
    // 复选框
    if (widget.onChanged != null) {
      children.add(_creatChexkBox(isHover));
    }
    // 前置组件
    if (widget.prefixWidget != null) {
      children.add(widget.prefixWidget!(isHover));
    }
    // 图标
    if (widget.icon != null) {
      children.add(_creatIcon(isHover));
    }
    // 文字
    if (widget.label != null) {
      children.add(_creatLabel(isHover));
    }

    if (children.length > 1) {
      for (int i = children.length - 1; i > 0; i--) {
        children.insert(i, SizedBox(width: widget.gap));
      }
    }

    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onChanged != null &&
              widget.isCheckBox &&
              _checkBoxConfig.enable
          ? () {
              widget.onChanged!(_status);
              setState(() => _status = !_status);
            }
          : widget.onTap,
      child: MouseEnterExit(
          cursor: widget.cursor,
          duration: widget.hoverExitDuration,
          builder: (isHover) => CustomToolTip(
                text: widget.tooltip,
                waitDuration:
                    widget.waitDuration ?? const Duration(milliseconds: 500),
                padding: const EdgeInsets.fromLTRB(3, 1, 3, 2),
                child: Container(
                  alignment: Alignment.center,
                  margin: widget.margin,
                  padding: widget.padding ??
                      const EdgeInsets.only(left: 2, right: 2),
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                      boxShadow:
                          isHover ? widget.hoverBoxShadow : widget.boxShadow,
                      border: widget.haveBorder
                          ? Border.all(
                              width: widget.borderWidth,
                              color: (isHover
                                      ? widget.hoverBorderColor ??
                                          widget.borderColor
                                      : widget.borderColor) ??
                                  borderColor(context.isDarkMode))
                          : null,
                      borderRadius:
                          widget.borderRadius ?? BorderRadius.circular(3),
                      color: isHover
                          ? widget.hoverBackgroundColor ??
                              widget.backgroundColor ??
                              Theme.of(context)
                                  .colorScheme
                                  .shadow
                                  .withOpacity(.05)
                          : widget.backgroundColor),
                  child: widget.endWidget == null
                      ? _creatContent(isHover)
                      : Row(
                          mainAxisAlignment: widget.endAxisAlignment,
                          crossAxisAlignment: widget.endCrossAxisAlignment,
                          children: [
                            _creatContent(isHover),
                            widget.endWidget!(isHover)
                          ],
                        ),
                ),
              )),
    );
  }
}
