import 'package:book_reader/common/model/font_eg.dart';
import 'package:book_reader/res/colours.dart';
import 'package:book_reader/res/r.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json2dart_safe/json2dart.dart';

/// @date 26/4/22
/// describe:
///主题类型
class ThemeType {
  static const int light = 0; //亮色主题
  static const int oldPaper = 1; //旧报纸类型
  static const int dark = 2; //暗色主题
  static const int ink = 3; //水墨主题
  static const int green = 4; //绿色护眼主题
}

class PaddingType {
  static const double small = 6;
  static const double normal = 16;
  static const double large = 30;

  static String getPic(double type) {
    if (type == PaddingType.small) {
      return R.icNoIndentation;
    } else if (type == PaddingType.normal) {
      return R.icFramework;
    }
    return R.icLargeFrame;
  }
}

class LetterHeightType {
  static const double small = 1.2;
  static const double normal = 1.5;
  static const double large = 2.0;

  static String getType(double type) {
    if (type == LetterHeightType.small) {
      return R.icSqueezed;
    } else if (type == LetterHeightType.normal) {
      return R.icNormally;
    }
    return R.icFreely;
  }

  static double getHeight(double type) {
    if (LetterHeightType.small == type) {
      return 10.0;
    } else if (type == LetterHeightType.normal) {
      return 14.0;
    }
    return 18.0;
  }
}

class PageSwitchType {
  static const int swipe = 0;
  static const int leaf = 1;
  static const int scroll = 2;
  static const int tap = 3;
}

class ReaderTheme {
  Color? background;
  Color? fontColor;
  double fontSize = 16;
  int type = ThemeType.light;
  int pageSwitch = PageSwitchType.scroll;
  double paddingType = PaddingType.normal;
  double letterHeight = LetterHeightType.normal;
  FontEg? font = FontEg.normal();
  String? backgroundPic;

  ReaderTheme.fromJson(Map json) {
    fontSize = json.asDouble("fontSize", 16);
    type = json.asInt("type", ThemeType.light);
    fontColor = Color(json.asInt("fontColor", Colours.bookColor.value));
    background = Color(json.asInt("background", Colors.white.value));
    pageSwitch = json.asInt("type", PageSwitchType.scroll);
    paddingType = json.asDouble("paddingType", PaddingType.normal);
    letterHeight = json.asDouble("letterHeight", LetterHeightType.normal);
    font = json.asBean<FontEg>("font", (v) => FontEg.fromJson(v)) ?? FontEg.normal();
    backgroundPic = json.asString("backgroundPic");
  }

  Map<String, dynamic> toJson() => <String, dynamic>{}
    ..put("fontSize", fontSize)
    ..put("type", type)
    ..put("fontColor", fontColor?.value)
    ..put("background", background?.value)
    ..put("pageSwitch", pageSwitch)
    ..put("paddingType", paddingType)
    ..put("letterHeight", letterHeight)
    ..put("font", font?.toJson())
    ..put("backgroundPic", backgroundPic);

  ReaderTheme(this.type) {
    if (type == ThemeType.light) {
      background = Colours.white;
      fontColor = Colours.bookColor;
    } else if (type == ThemeType.dark) {
      background = Colours.darkColor;
      fontColor = Colours.white;
    } else if (type == ThemeType.oldPaper) {
      background = Colours.oldPaperColor;
      fontColor = Colours.oldPaperFontColor;
    } else if (type == ThemeType.ink) {
      background = Colours.inkColor;
      fontColor = Colours.black;
    } else if (type == ThemeType.green) {
      background = Colours.greenEye;
      fontColor = Colours.black;
    }
  }

  ReaderTheme.oldPaper({
    this.background = Colours.oldPaperColor,
    this.fontColor = Colours.oldPaperFontColor,
    this.type = ThemeType.oldPaper,
  });

  ReaderTheme.light({
    this.background = Colours.white,
    this.fontColor = Colours.bookColor,
    this.type = ThemeType.light,
  });

  ReaderTheme.dark({
    this.background = Colours.darkColor,
    this.fontColor = Colours.white,
    this.type = ThemeType.dark,
  });

  ReaderTheme.ink({
    this.background = Colours.inkColor,
    this.fontColor = Colours.black,
    this.type = ThemeType.ink,
  });

  ReaderTheme.green({
    this.background = Colours.greenEye,
    this.fontColor = Colours.black,
    this.type = ThemeType.ink,
  });

  static Color getBackGroundColor(int type) {
    if (type == ThemeType.light) {
      return Colours.white;
    } else if (type == ThemeType.dark) {
      return Colours.darkColor;
    } else if (type == ThemeType.oldPaper) {
      return Colours.oldPaperColor;
    } else if (type == ThemeType.ink) {
      return Colours.inkColor;
    } else if (type == ThemeType.green) {
      return Colours.greenEye;
    }
    return Colours.white;
  }
}
