import 'package:book_reader/res/index.dart';
import 'package:flutter/material.dart';

class ResDecor {
  static const BoxDecoration decor3 = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment(-1.0, -0.709),
      end: Alignment(1.0, 0.663),
      colors: [Colours.e5fe1d61, Colours.e5ce0945],
      stops: [0.0, 1.0],
    ),
  );

  static const BoxDecoration decor18 = BoxDecoration(
    color: Colours.white,
    boxShadow: ResShadow.x26252833Offset02050,
  );
}
