import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

extension StringExt on String? {
  String formatter(List<String> _formatters) {
    return sprintf(this!, _formatters);
  }

  //计算文本占用宽高
  double paintWidthWithTextStyle(TextStyle style) {
    final TextPainter textPainter =
        TextPainter(text: TextSpan(text: this, style: style), maxLines: 1, textDirection: TextDirection.ltr)
          ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }
}
