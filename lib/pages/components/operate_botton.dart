import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'config/config.dart';
import 'customize_widget.dart';
import 'snackbar.dart';

Widget creatOkButton(dynamic Function()? operate,
        {String? label,
        Function? exceptionHandle,
        Offset snackbarOffset = const Offset(0, 0)}) =>
    Builder(
      builder: (context) => CustomizeWidget(
        label: label ?? "OK".tr,
        onTap: () => hookExceptionWithSnackbar(operate ?? () {},
            exceptionHandle: exceptionHandle, offset: snackbarOffset),
        config: CustomizeWidgetConfig(
          width: 52,
          height: 24,
          backgroundColor: borderColor(context.isDarkMode).withOpacity(.5),
          hoverBackgroundColor: borderColor(context.isDarkMode).withOpacity(.7),
          primaryColor: context.isDarkMode
              ? const Color.fromARGB(255, 126, 134, 243)
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    );

Widget creatCancelButton(dynamic Function()? operate, {String? label}) =>
    Builder(builder: (context) {
      return CustomizeWidget(
        label: label ?? "Cancel".tr,
        onTap: operate,
        width: 52,
        height: 24,
        primaryColor: labelColor(context.isDarkMode),
      );
    });
