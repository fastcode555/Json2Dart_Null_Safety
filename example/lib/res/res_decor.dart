import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:flutter/material.dart';
import 'package:gesound/res/index.dart';

class ResDecor {
  static const BoxDecoration decor20 = BoxDecoration(
    gradient: RadialGradient(
      center: Alignment(-0.427, 0.032),
      radius: 0.326,
      colors: [Colours.ff219e9d, Colours.ff1e8887],
      stops: [0.0, 1.0],
      transform: GradientXDTransform(1.0, 0.0, 0.0, 1.593, 0.0, -0.297, Alignment(-0.427, 0.032)),
    ),
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
  );
  static const BoxDecoration radioDecor = BoxDecoration(
    shape: BoxShape.circle,
    border: Border.fromBorderSide(BorderSide(width: 1.0, color: Colours.mainColor)),
  );
  static const BoxDecoration outlinDecor = BoxDecoration(
    color: Colours.ff103434,
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    border: Border.fromBorderSide(BorderSide(width: 1.0, color: Colours.ff36dede)),
  );
  static const BoxDecoration stokeBtnDecor = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    border: Border.fromBorderSide(BorderSide(width: 1.0, color: Colours.ff27dbd9)),
  );

  static const BoxDecoration backgroundDecor = BoxDecoration(
    gradient: LinearGradient(
      colors: [Colours.bottomBarColor, Colours.black],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
  static const BoxDecoration decor17 = BoxDecoration(
    color: Colours.ff1e5d5d,
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
  );
}
