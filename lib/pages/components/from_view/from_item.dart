import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_view/pages/components/custom_tool_tip.dart';
import 'package:project_view/utils/adaptive.dart';

import '../../../utils/utils.dart';

class FromItem extends StatelessWidget {
  final String label;
  final Widget child;
  final List<Widget> actions;
  final bool isRight;
  final double? width;
  const FromItem({
    super.key,
    required this.label,
    required this.child,
    this.width,
    this.actions = const [],
    this.isRight = true,
  });

  @override
  Widget build(BuildContext context) {
    bool onRight = Adaptive.isSmall(context) && isRight;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: min(Adaptive.getWidth(context) * .24, 80),
          child: CustomToolTip(
            text: label,
            child: Text(
              label,
              textAlign:
                  Adaptive.isSmall(context) ? TextAlign.start : TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(width: Adaptive.isSmall(context) ? 10 : 20),
        if (width != null && onRight) const Expanded(child: SizedBox()),
        width == null
            ? Flexible(
                child: Align(
                  alignment:
                      onRight ? Alignment.centerRight : Alignment.centerLeft,
                  child: child,
                ),
              )
            : SizedBox(width: width, child: child),
        ...actions,
        if (width != null && !onRight) const Expanded(child: SizedBox()),
      ],
    );
  }
}
