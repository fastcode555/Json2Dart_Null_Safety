import 'package:flutter/material.dart';
import 'package:gesound/res/index.dart';

class ThemeUtil {
  static ThemeData lightTheme(Color _themeColor) {
    ThemeData _theme = ThemeData.light();
    return _theme.copyWith(
      primaryColor: _themeColor,
      primaryColorLight: _themeColor,
      //默认的主题色
      primaryColorDark: _themeColor,
      inputDecorationTheme: InputDecorationTheme(
        focusColor: _themeColor,
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeColor)),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            //primary: Colours.app_main,
            // textStyle: TextStyle(color: Colours.app_main),
            ),
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.white,
        labelStyle: TextStyles.whiteW50014,
        unselectedLabelStyle: TextStyles.whiteW50014,
        unselectedLabelColor: Colors.white,
        indicator: ResDecor.decor20,
      ),
      //iconTheme: IconThemeData(color: Colours.main_text_color),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: _themeColor,
        cursorColor: _themeColor,
        selectionHandleColor: _themeColor,
      ),
      // splashColor: _themeColor.withOpacity(0.3),
      // highlightColor: _themeColor.withOpacity(0.1),
      // hoverColor: _themeColor.withOpacity(0.1),
      platform: TargetPlatform.iOS,
      indicatorColor: _themeColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(_themeColor),
        ),
      ),
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }

  static ThemeData darkTheme(Color _themeColor) {
    ThemeData _theme = ThemeData.dark();
    return _theme.copyWith(
      primaryColor: _themeColor,
      //默认的主题色
      primaryColorDark: _themeColor,
      platform: TargetPlatform.android,
      inputDecorationTheme: InputDecorationTheme(
        focusColor: _themeColor,
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeColor)),
      ),

      // bottomAppBarColor: Colours.color_303030,
      // backgroundColor: Colours.color_11151C,
      // accentColor: Colors.white,
      // iconTheme: IconThemeData(color: Colors.white),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: _themeColor,
        cursorColor: _themeColor,
        selectionHandleColor: _themeColor,
      ),
      /*tabBarTheme: const TabBarTheme(
        labelColor: Colours.ff323232,
        labelStyle: TextStyles.ff323232Bold20,
        unselectedLabelStyle: TextStyles.a3323232Bold20,
        unselectedLabelColor: Colours.a3323232,
      ),*/
      indicatorColor: _themeColor,
      // splashColor: _themeColor.withOpacity(0.3),
      // highlightColor: _themeColor.withOpacity(0.1),
      // hoverColor: _themeColor.withOpacity(0.1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(_themeColor),
        ),
      ),
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }
}
