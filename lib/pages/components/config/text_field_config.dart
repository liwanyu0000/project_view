import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../customize_widget.dart';
import 'config.dart';

Widget defaultClearTextWidget(
        BuildContext context, dynamic Function()? clearText) =>
    CustomizeWidget(
      onTap: clearText,
      config: CustomizeWidgetConfig(
        width: iconSizeConfig.primaryIconSize + 6,
        margin: const EdgeInsets.all(4),
        primaryColor: borderColor(context.isDarkMode),
        iconSize: iconSizeConfig.primaryIconSize,
      ),
      icon: Icons.clear,
    );

Widget defaultSearchIcon(BuildContext context) => Icon(
      Icons.search,
      color: labelColor(context.isDarkMode),
      size: iconSizeConfig.primaryIconSize,
    );

InputDecoration? decorationConfig(
  BuildContext context, {
  Widget? icon,
  Color? iconColor,
  Widget? label,
  String? labelText,
  TextStyle? labelStyle,
  TextStyle? floatingLabelStyle,
  String? helperText,
  TextStyle? helperStyle,
  int? helperMaxLines,
  String? hintText,
  TextStyle? hintStyle,
  TextDirection? hintTextDirection,
  int? hintMaxLines,
  Widget? error,
  String? errorText,
  TextStyle? errorStyle,
  int? errorMaxLines,
  FloatingLabelBehavior? floatingLabelBehavior,
  FloatingLabelAlignment? floatingLabelAlignment,
  bool isCollapsed = false,
  bool? isDense,
  EdgeInsetsGeometry? contentPadding,
  Widget? prefixIcon,
  BoxConstraints? prefixIconConstraints,
  Widget? prefix,
  String? prefixText,
  TextStyle? prefixStyle,
  Color? prefixIconColor,
  Widget? suffixIcon,
  Widget? suffix,
  String? suffixText,
  TextStyle? suffixStyle,
  Color? suffixIconColor,
  BoxConstraints? suffixIconConstraints,
  Widget? counter,
  String? counterText,
  TextStyle? counterStyle,
  bool? filled,
  Color? fillColor,
  Color? focusColor,
  Color? hoverColor,
  bool enabled = true,
  String? semanticCounterText,
  bool? alignLabelWithHint,
  BoxConstraints? constraints,
  InputBorder? disabledBorder,
}) =>
    InputDecoration(
      icon: icon,
      iconColor: iconColor,
      label: label,
      labelText: labelText,
      labelStyle: labelStyle,
      floatingLabelStyle: floatingLabelStyle,
      helperText: helperText,
      helperStyle: helperStyle,
      helperMaxLines: helperMaxLines,
      hintText: hintText,
      hintStyle: hintStyle ??
          TextStyle(
            fontSize: textSizeConfig.secondaryTextSize,
            color: labelColor(context.isDarkMode),
            fontWeight: FontWeight.w300,
          ),
      hintTextDirection: hintTextDirection,
      hintMaxLines: hintMaxLines,
      error: error,
      errorText: errorText,
      errorStyle: errorStyle,
      errorMaxLines: errorMaxLines,
      floatingLabelBehavior: floatingLabelBehavior,
      floatingLabelAlignment: floatingLabelAlignment,
      isCollapsed: isCollapsed,
      isDense: isDense,
      contentPadding:
          contentPadding ?? const EdgeInsets.symmetric(horizontal: 10),
      prefixIcon: prefixIcon,
      prefixIconConstraints: prefixIconConstraints,
      prefix: prefix,
      prefixText: prefixText,
      prefixStyle: prefixStyle,
      prefixIconColor: prefixIconColor,
      suffixIcon: suffixIcon,
      suffix: suffix,
      suffixText: suffixText,
      suffixStyle: suffixStyle,
      suffixIconColor: suffixIconColor,
      suffixIconConstraints: suffixIconConstraints,
      counter: counter,
      counterText: counterText,
      counterStyle: counterStyle,
      filled: filled,
      fillColor: fillColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      enabled: enabled,
      semanticCounterText: semanticCounterText,
      alignLabelWithHint: alignLabelWithHint,
      constraints: constraints,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: borderColor(context.isDarkMode).withOpacity(0),
          width: 1,
        ),
        gapPadding: 0,
      ),
      disabledBorder: disabledBorder ??
          OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor(context.isDarkMode).withOpacity(0),
              width: 1,
            ),
            gapPadding: 0,
          ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: borderColor(context.isDarkMode),
          width: 1,
        ),
        gapPadding: 0,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
        gapPadding: 0,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 1,
        ),
        gapPadding: 0,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 1,
        ),
        gapPadding: 0,
      ),
    );

InputDecoration? noBorderConfig(
  BuildContext context, {
  Widget? icon,
  Color? iconColor,
  Widget? label,
  String? labelText,
  TextStyle? labelStyle,
  TextStyle? floatingLabelStyle,
  String? helperText,
  TextStyle? helperStyle,
  int? helperMaxLines,
  String? hintText,
  TextStyle? hintStyle,
  TextDirection? hintTextDirection,
  int? hintMaxLines,
  Widget? error,
  String? errorText,
  TextStyle? errorStyle,
  int? errorMaxLines,
  FloatingLabelBehavior? floatingLabelBehavior,
  FloatingLabelAlignment? floatingLabelAlignment,
  bool isCollapsed = false,
  bool? isDense,
  EdgeInsetsGeometry? contentPadding,
  Widget? prefixIcon,
  BoxConstraints? prefixIconConstraints,
  Widget? prefix,
  String? prefixText,
  TextStyle? prefixStyle,
  Color? prefixIconColor,
  Widget? suffixIcon,
  Widget? suffix,
  String? suffixText,
  TextStyle? suffixStyle,
  Color? suffixIconColor,
  BoxConstraints? suffixIconConstraints,
  Widget? counter,
  String? counterText,
  TextStyle? counterStyle,
  bool? filled,
  Color? fillColor,
  Color? focusColor,
  Color? hoverColor,
  bool enabled = true,
  String? semanticCounterText,
  bool? alignLabelWithHint,
  BoxConstraints? constraints,
}) =>
    InputDecoration(
      icon: icon,
      iconColor: iconColor,
      label: label,
      labelText: labelText,
      labelStyle: labelStyle,
      floatingLabelStyle: floatingLabelStyle,
      helperText: helperText,
      helperStyle: helperStyle,
      helperMaxLines: helperMaxLines,
      hintText: hintText,
      hintStyle: hintStyle ??
          TextStyle(
            fontSize: textSizeConfig.secondaryTextSize,
            color: labelColor(context.isDarkMode),
            fontWeight: FontWeight.w300,
          ),
      hintTextDirection: hintTextDirection,
      hintMaxLines: hintMaxLines,
      error: error,
      errorText: errorText,
      errorStyle: errorStyle,
      errorMaxLines: errorMaxLines,
      floatingLabelBehavior: floatingLabelBehavior,
      floatingLabelAlignment: floatingLabelAlignment,
      isCollapsed: isCollapsed,
      isDense: isDense,
      contentPadding: contentPadding ?? const EdgeInsets.all(0),
      prefixIcon: prefixIcon,
      prefixIconConstraints: prefixIconConstraints,
      prefix: prefix,
      prefixText: prefixText,
      prefixStyle: prefixStyle,
      prefixIconColor: prefixIconColor,
      suffixIcon: suffixIcon,
      suffix: suffix,
      suffixText: suffixText,
      suffixStyle: suffixStyle,
      suffixIconColor: suffixIconColor,
      suffixIconConstraints: suffixIconConstraints,
      counter: counter,
      counterText: counterText,
      counterStyle: counterStyle,
      filled: filled,
      fillColor: fillColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      enabled: enabled,
      semanticCounterText: semanticCounterText,
      alignLabelWithHint: alignLabelWithHint,
      constraints: constraints,
      errorBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      border: InputBorder.none,
    );