import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomLoading extends StatelessWidget {
  final String? text;
  final double? width;
  final double? height;
  final double? circularWidth;
  final double? circularHeight;
  final Color? color;
  final Color? backgroundColor;
  final double? strokeWidth;
  const CustomLoading(
      {this.text,
      this.width,
      this.height,
      this.circularWidth,
      this.circularHeight,
      this.color,
      this.backgroundColor,
      this.strokeWidth,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: circularWidth ?? 12,
            height: circularHeight ?? 12,
            child: CircularProgressIndicator(
              color: color,
              strokeWidth: strokeWidth ?? 2,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(child: Text(text ?? 'loading...'.tr))
        ],
      ),
    );
  }
}
