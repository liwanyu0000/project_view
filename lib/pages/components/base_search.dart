import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';
import 'config/config.dart';
import 'custom_loading.dart';

class SearchWidget<T> extends StatefulWidget {
  final double? searchHeight;
  final bool Function(String value, T item)? search;
  final List<T> datas;
  final Widget Function(T item, int index) itemBuilder;
  final Duration? duration;
  final Widget? prefixWidget;
  final Widget? head;
  final Widget? tail;
  const SearchWidget({
    super.key,
    required this.itemBuilder,
    this.searchHeight,
    this.search,
    this.datas = const [],
    this.duration,
    this.prefixWidget,
    this.head,
    this.tail,
  });

  @override
  State<SearchWidget<T>> createState() => _SearchWidgetState<T>();
}

class _SearchWidgetState<T> extends State<SearchWidget<T>> {
  bool haveText = false;
  List<Widget> menuItem = [];
  TextEditingController textEditingController = TextEditingController();
  bool isLoad = true;
  @override
  void initState() {
    super.initState();
    textEditingController.addListener(
      () => setState(() => haveText = textEditingController.text.isNotEmpty),
    );
    Future.delayed(widget.duration ?? const Duration(milliseconds: 200), () {
      search('');
      isLoad = false;
    });
  }

  @override
  void didUpdateWidget(covariant SearchWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    search('');
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> search(String text) async {
    if (widget.search == null) return;
    final list = widget.datas.where((e) => widget.search!(text, e)).toList();
    menuItem = List.generate(
        list.length, (index) => widget.itemBuilder(list[index], index));
    if (mounted) setState(() {});
  }

  Widget _creatSearchTextField() => Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
        constraints: Adaptive.isSmall(context)
            ? const BoxConstraints()
            : const BoxConstraints(minWidth: 300),
        height: widget.searchHeight ?? 36,
        child: TextField(
          mouseCursor: MaterialStateMouseCursor.textable,
          decoration: decorationConfig(context,
              suffixIcon: haveText
                  ? defaultClearTextWidget(
                      context, () => textEditingController.clear())
                  : null,
              prefixIcon: defaultSearchIcon(context),
              hintText: "搜索"),
          controller: textEditingController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          maxLines: 1,
          onChanged: search,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      widget.head ?? const SizedBox.shrink(),
      _creatSearchTextField(),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: isLoad
                ? [
                    const SizedBox(height: 10),
                    Icon(Icons.search,
                        color: borderColor(context.isDarkMode),
                        size: iconSizeConfig.hugAvatarIconSize),
                    const SizedBox(height: 10),
                    const CustomLoading()
                  ]
                : menuItem.isEmpty
                    ? [
                        widget.prefixWidget ?? const SizedBox(),
                        const SizedBox(height: 10),
                        Icon(Icons.search,
                            color: borderColor(context.isDarkMode),
                            size: iconSizeConfig.hugAvatarIconSize),
                        const SizedBox(height: 10),
                        const Center(child: Text("抱歉! 未找到相关内容"))
                      ]
                    : [
                        widget.prefixWidget ?? const SizedBox(),
                        ...menuItem,
                      ],
          ),
        ),
      ),
      widget.tail ?? const SizedBox.shrink(),
    ]);
  }
}
