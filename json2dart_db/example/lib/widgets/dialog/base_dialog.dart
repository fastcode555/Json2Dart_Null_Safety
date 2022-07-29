import 'package:flutter/material.dart';
import 'package:gesound/res/index.dart';
import 'package:gesound/res/res_decor.dart';

/// @date 31/5/22
/// describe:
class BaseDialog extends StatelessWidget {
  final double? height;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const BaseDialog({
    Key? key,
    this.height,
    this.margin,
    this.padding,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: double.infinity,
            margin: margin ?? const EdgeInsets.symmetric(horizontal: 40),
            decoration: ResDecor.outlinDecor,
            height: height,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 37, vertical: 20),
            child: child,
          ),
        )
      ],
    );
  }
}
