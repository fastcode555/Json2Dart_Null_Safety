import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:json2dart_viewer/src/table_structure_page.dart';

import 'table_detail_page.dart';
import 'table_page.dart';

/// @date 2020/12/17
/// describe:悬浮面板
class OverlayPane extends StatefulWidget {
  @override
  _OverlayPaneState createState() => _OverlayPaneState();
}

class _OverlayPaneState extends State<OverlayPane> {
  bool _isFullScreen = false;

  double get _statusHeight =>
      _isFullScreen ? MediaQuery.of(context).padding.top : 0;

  @override
  Widget build(BuildContext context) {
    double height =
        window.physicalSize.height / MediaQuery.of(context).devicePixelRatio;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.black.withOpacity(0.7),
            height: height / (_isFullScreen ? 1 : 2) - _statusHeight,
            width: double.infinity,
            child: Stack(
              children: [
                _buildNavigator(),
                Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        _isFullScreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() => _isFullScreen = !_isFullScreen);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigator() {
    return Navigator(
      initialRoute: TablePage.routeName,
      onGenerateRoute: (RouteSettings settins) {
        late WidgetBuilder builder;
        switch (settins.name) {
          case TablePage.routeName:
            builder = (context) => TablePage();
            break;
          case TableDetailPage.routeName:
            builder = (context) =>
                TableDetailPage(tableName: settins.arguments as String);
            break;
          case TableStructurePage.routeName:
            builder = (context) =>
                TableStructurePage(tableName: settins.arguments as String);
            break;
        }
        return MaterialPageRoute(builder: builder);
      },
    );
  }
}
