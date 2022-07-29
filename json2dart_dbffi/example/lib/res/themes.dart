import 'package:book_reader/res/colours.dart';
import 'package:book_reader/res/text_styles.dart';
import 'package:flutter/material.dart';

class Themes {
  static ThemeData theme(Color themeColor) {
    ThemeData _theme = ThemeData.light();
    return _theme.copyWith(
      primaryColor: themeColor,
      primaryColorLight: themeColor,
      //默认的主题色
      primaryColorDark: themeColor,
      inputDecorationTheme: InputDecorationTheme(
        focusColor: themeColor,
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: themeColor)),
      ),
      primaryTextTheme: const TextTheme(
        headline1: TextStyle(color: Colors.black, inherit: true),
        headline2: TextStyle(color: Colors.black, inherit: true),
        headline3: TextStyle(color: Colors.black, inherit: true),
        headline4: TextStyle(color: Colors.black, inherit: true),
        headline5: TextStyle(color: Colors.black, inherit: true),
        headline6: TextStyle(color: Colors.black, inherit: true),
        subtitle1: TextStyle(color: Colors.black, inherit: true),
        subtitle2: TextStyle(color: Colors.black, inherit: true),
        bodyText1: TextStyle(color: Colors.black, inherit: true),
        bodyText2: TextStyle(color: Colors.black, inherit: true),
        caption: TextStyle(color: Colors.black, inherit: true),
        button: TextStyle(color: Colors.black, inherit: true),
        overline: TextStyle(color: Colors.black, inherit: true),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            //primary: Colours.app_main,
            // textStyle: TextStyle(color: Colours.app_main),
            ),
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Colours.ff323232,
        labelStyle: TextStyles.ff323232Bold15,
        unselectedLabelStyle: TextStyles.a3323232Bold15,
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: Colours.bookIndicatorColor,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: themeColor,
        cursorColor: themeColor,
        selectionHandleColor: themeColor,
      ),
      platform: TargetPlatform.iOS,
      indicatorColor: themeColor,
      iconTheme: const IconThemeData(color: Colours.ff323232),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(themeColor),
        ),
      ),
      toggleableActiveColor: themeColor,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }
}
