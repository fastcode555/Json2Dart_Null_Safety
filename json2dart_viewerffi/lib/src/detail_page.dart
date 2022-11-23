import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:json2dart_dbffi/database/model/table_info.dart';
import 'package:json2dart_dbffi/json2dart_dbffi.dart';
import 'package:json2dart_viewerffi/src/widgets/custom_scaffold.dart';
import 'package:json2dart_viewerffi/src/widgets/db_list_view.dart';
import 'package:json2dart_viewerffi/src/widgets/db_table_header.dart';

/// @date 18/10/22
/// describe: 显示数表的具体数据，暂未增加查询的功能

const double _minWidth = 150;

class DetailPage extends StatefulWidget {
  static const String routeName = "/src/detail_page";
  final String tableName;

  const DetailPage({super.key, required this.tableName});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TableInfo? _tableInfo;
  double _width = _minWidth;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      lable: widget.tableName,
      body: LayoutBuilder(
        builder: (_, constraint) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder<TableInfo?>(
              future: _queryTableInfo(),
              builder: (_, data) {
                if (_tableInfo == null) return const SizedBox();
                double containerWidth = _calculateSize(_tableInfo!.columns!.length, constraint.maxWidth);
                return Container(
                  width: containerWidth,
                  child: Column(
                    children: [
                      const Divider(color: Colors.white, thickness: 1, height: 1),
                      DbTableHeader(rowWidth: _width, tableInfo: _tableInfo),
                      const Divider(color: Colors.white, thickness: 1, height: 1),
                      Expanded(child: DbListView(tableInfo: _tableInfo!, rowWidth: _width)),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  ///计算布局的宽度
  double _calculateSize(int columnCount, double maxWidth) {
    double containerWidth = columnCount * _minWidth;
    bool needAssignWidth = maxWidth > containerWidth;
    containerWidth = needAssignWidth ? maxWidth : containerWidth;
    _width = needAssignWidth ? maxWidth / columnCount : _width;
    return containerWidth;
  }

  ///查询表信息
  Future<TableInfo?> _queryTableInfo() async {
    if (_tableInfo != null) return _tableInfo;
    _tableInfo = (await BaseDbManager.instance.queryTableInfo(widget.tableName));
    return _tableInfo;
  }
}
