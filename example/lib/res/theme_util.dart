import 'package:flutter/material.dart';
import 'package:gesound/res/index.dart';
import 'package:gesound/res/text_styles.dart';

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
          backgroundColor: MaterialStateProperty.all<Color>(_themeColor),
        ),
      ),
      toggleableActiveColor: _themeColor,
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
      primaryTextTheme: const TextTheme(
        headline1: TextStyle(color: Colors.white, inherit: true),
        headline2: TextStyle(color: Colors.white, inherit: true),
        headline3: TextStyle(color: Colors.white, inherit: true),
        headline4: TextStyle(color: Colors.white, inherit: true),
        headline5: TextStyle(color: Colors.white, inherit: true),
        headline6: TextStyle(color: Colors.white, inherit: true),
        subtitle1: TextStyle(color: Colors.white, inherit: true),
        subtitle2: TextStyle(color: Colors.white, inherit: true),
        bodyText1: TextStyle(color: Colors.white, inherit: true),
        bodyText2: TextStyle(color: Colors.white, inherit: true),
        caption: TextStyle(color: Colors.black, inherit: true),
        button: TextStyle(color: Colors.black, inherit: true),
        overline: TextStyle(color: Colors.black, inherit: true),
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
          backgroundColor: MaterialStateProperty.all<Color>(_themeColor),
        ),
      ),
      toggleableActiveColor: _themeColor,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }
}
