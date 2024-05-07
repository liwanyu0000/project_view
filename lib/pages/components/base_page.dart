import 'package:flutter/material.dart';

// 移动端路由界面
class BasePage extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? padding;
  const BasePage(
      {super.key,
      required this.title,
      required this.child,
      this.actions,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}
