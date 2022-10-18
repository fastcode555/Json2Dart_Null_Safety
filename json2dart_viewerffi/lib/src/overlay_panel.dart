import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:json2dart_dbffi/json2dart_dbffi.dart';

/// @date 2020/12/17
/// describe:悬浮面板
class OverlayPane extends StatefulWidget {
  @override
  _OverlayPaneState createState() => _OverlayPaneState();
}

class _OverlayPaneState extends State<OverlayPane> {
  bool _isFullScreen = false;

  double get _statusHeight => _isFullScreen ? MediaQuery.of(context).padding.top : 0;

  @override
  Widget build(BuildContext context) {
    double height = window.physicalSize.height / MediaQuery.of(context).devicePixelRatio;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.black.withOpacity(0.7),
            height: height / (_isFullScreen ? 1 : 2) - _statusHeight,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() => _isFullScreen = !_isFullScreen);
                      },
                    ),
                  ],
                ),
                Expanded(child: _buildListView()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView() {
    return FutureBuilder<List<String>>(
      future: BaseDbManager.instance.queryTables(),
      builder: (_, data) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (_, index) {
            String tableName = data.data![index];
            return Container(
              height: 30,
              alignment: Alignment.centerLeft,
              child: Text(tableName, style: TextStyle(color: Colors.white)),
            );
          },
          itemCount: data.data?.length ?? 0,
        );
      },
    );
  }
}
