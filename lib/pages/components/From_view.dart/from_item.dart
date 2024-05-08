import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_view/pages/components/custom_tool_tip.dart';
import 'package:project_view/utils/adaptive.dart';

import '../../../utils/utils.dart';

class FromItem extends StatelessWidget {
  final String label;
  final Widget child;
  final bool isRight;
  const FromItem({
    super.key,
    required this.label,
    required this.child,
    this.isRight = true,
  });

  @override
  Widget build(BuildContext context) {
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
        Flexible(
          child: Align(
            alignment: Adaptive.isSmall(context) && isRight
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: child,
          ),
        ),
      ],
    );
  }
}
