import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';
import 'config/config.dart';
import 'custom_form.dart';
import 'customize_widget.dart';
import 'dialog/hint_dialog.dart';

class InfoEditController {
  bool isEdit = false;
  bool readOnly = true;
  dynamic data;
  dynamic history;
  Map<String, TextEditingController> onlyEdit = {};
  Map<String, List<TextEditingController>> multipleEdit = {};
  Map<String, dynamic> onlyValue = {};
  Map<String, List<dynamic>> multipleValue = {};
  void Function(InfoEditController self, [Map<String, dynamic>? initData])?
      _setMethod;
  InfoEditController();

  /// 去除空项
  void checkMultipleEdit() {
    for (var e in multipleEdit.values) {
      e.removeWhere((element) {
        if (element.text.isEmpty) {
          element.dispose();
          return true;
        }
        return false;
      });
    }
  }

  /// 重置状态
  void resetState() {
    checkMultipleEdit();
    isEdit = false;
    readOnly = true;
  }

  /// 初始化
  void init() {
    resetState();
    for (var e in onlyEdit.values) {
      e.addListener(() => isEdit = true);
    }
    for (var e in multipleEdit.values) {
      for (var f in e) {
        f.addListener(() => isEdit = true);
      }
    }
  }

  /// 销毁
  void dispose() {
    for (var e in onlyEdit.values) {
      e.dispose();
    }
    for (var e in multipleEdit.values) {
      for (var f in e) {
        f.dispose();
      }
    }
  }

  /// 清空
  void clear() {
    isEdit = false;
    dispose();
    onlyEdit.clear();
    multipleEdit.clear();
    onlyValue.clear();
    multipleValue.clear();
  }

  /// 设置数据
  InfoEditController setModel(
      {void Function(InfoEditController self, [Map<String, dynamic>? initData])?
          fn,
      bool readOnly = true,
      dynamic model,
      Map<String, dynamic>? initData}) {
    if (fn != null) _setMethod = fn;
    history = model;
    clear();
    _setMethod?.call(this, initData);
    init();
    this.readOnly = readOnly;
    return this;
  }

  /// 设置只读状态
  InfoEditController setReadOnly(bool readOnly) {
    this.readOnly = readOnly;
    return this;
  }

  /// 重置数据
  void back() {
    setModel(model: history);
  }

  /// 添加数据（编辑框）
  void addMultipleEdit(String key, String value) {
    TextEditingController controller = TextEditingController(text: value);
    controller.addListener(() => isEdit = true);
    isEdit = true;
    (multipleEdit[key] ??= []).add(controller);
  }

  /// 删除数据（编辑框）
  void delMultipleEdit(String key, int index) {
    isEdit = true;
    multipleEdit[key]?.removeAt(index);
  }

  /// 添加数据（值）
  void addMultipleValue(String key, dynamic value) {
    isEdit = true;
    (multipleValue[key] ??= []).add(value);
  }

  /// 删除数据（值）
  void delMultipleValue(String key, dynamic value) {
    isEdit = true;
    (multipleValue[key] ??= []).remove(value);
  }

  // 更新数据（值）
  void setOnlyValue(String key, dynamic value) {
    isEdit = true;
    onlyValue[key] = value;
  }

  /// 创建多行编辑框
  List creatMultipleEditRow({
    required String key,
    required String label,
    required String buttonText,
    void Function(void Function() fn)? setState,
    dynamic Function(int index)? suffixOnTap,
    dynamic Function()? buttonOnTap,
  }) {
    List list = [];
    if (multipleEdit[key] == null || multipleEdit[key]!.isEmpty) {
      multipleEdit[key] = [TextEditingController(text: '')];
      multipleEdit[key]!.first.addListener(() {
        isEdit = true;
      });
      list.add(
        EditTextFieldItem(label: label, controller: multipleEdit[key]!.first),
      );
    } else {
      list.addAll(
        multipleEdit[key]!.asMap().entries.map((e) {
          return EditTextFieldItem(
            label: label,
            controller: e.value,
            textSuffixIcon: e.key == 0
                ? null
                : Builder(builder: (context) {
                    return CustomizeWidget(
                      icon: Icons.remove_circle_outline,
                      config: CustomizeWidgetConfig(
                        iconColor: errorMarkColor(context.isDarkMode),
                        width: 20,
                        iconSize: iconSizeConfig.primaryIconSize,
                      ),
                      onTap: () => suffixOnTap == null
                          ? setState?.call(() {
                              delMultipleEdit(key, e.key);
                              if (Adaptive.isSmall(context)) {
                                SmartDialog.dismiss();
                              }
                            })
                          : suffixOnTap(e.key),
                    );
                  }),
          );
        }),
      );
    }
    if (!readOnly) {
      list.add(
        EditButtonItem(
          label: '',
          buttonText: buttonText,
          onTap: buttonOnTap ??
              () => setState?.call(() => addMultipleEdit(key, '')),
        ),
      );
    }
    return list;
  }

  /// 编辑界面退出时询问
  Future<bool> canQuit({
    Future Function()? onQuit,
    double? width,
    double? height,
    String? label,
  }) async {
    bool quit = await quitPageDialog(isEdit,
        width: width, height: height, label: label);
    if (quit) {
      await onQuit?.call();
      isEdit = false;
    }
    return quit;
  }
}
