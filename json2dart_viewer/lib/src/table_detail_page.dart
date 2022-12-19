import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:json2dart_db/database/model/table_info.dart';
import 'package:json2dart_db/json2dart_db.dart';
import 'package:json2dart_viewer/src/widgets/custom_scaffold.dart';
import 'package:json2dart_viewer/src/widgets/db_list_view.dart';
import 'package:json2dart_viewer/src/widgets/db_table_header.dart';

import 'table_structure_page.dart';

/// @date 18/10/22
/// describe: 显示数表的具体数据，暂未增加查询的功能

const double _minWidth = 150;

class TableDetailPage extends StatefulWidget {
  static const String routeName = "/src/table_detail_page";
  final String tableName;

  const TableDetailPage({super.key, required this.tableName});

  @override
  _TableDetailPageState createState() => _TableDetailPageState();
}

class _TableDetailPageState extends State<TableDetailPage> {
  TableInfo? _tableInfo;
  double _width = _minWidth;
  ValueNotifier<int> _countNotifier = ValueNotifier(0);

  //final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _queryCount();
  }

  void _queryCount() {
    BaseDbManager.instance.queryCount(widget.tableName).then((value) {
      _countNotifier.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      lable: widget.tableName,
      title: _buildTitleWidget(),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed(TableStructurePage.routeName, arguments: widget.tableName),
          child: Text('Structure'),
        ),
        TextButton(onPressed: _handleClearDatas, child: Text('Clear Data')),
        TextButton(onPressed: _handleDropTable, child: Text('Drop')),
      ],
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
                      //InputPanelField(controller: _controller),
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

  ///删除某个表
  void _handleDropTable() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Tip'),
          content: const Text('Do you want to drop this table?'),
          actions: <Widget>[
            CupertinoDialogAction(onPressed: Navigator.of(context).pop, child: const Text('Cancel')),
            CupertinoDialogAction(
              child: const Text('Confirm'),
              onPressed: () {
                BaseDbManager.instance.drop(widget.tableName).then((value) {
                  Navigator.of(context).pop(widget.tableName);
                });
              },
            ),
          ],
        );
      },
    );
  }

  ///删除表的数据
  void _handleClearDatas() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Tip'),
          content: const Text('Could you please confirm whether to delete all the data of this table?'),
          actions: <Widget>[
            CupertinoDialogAction(onPressed: Navigator.of(context).pop, child: const Text('Cancel')),
            CupertinoDialogAction(
              child: const Text('Confirm'),
              onPressed: () {
                BaseDbManager.instance.clearTable(widget.tableName).then((value) {
                  setState(() {});
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitleWidget() {
    return ValueListenableBuilder<int>(
      valueListenable: _countNotifier,
      builder: (_, data, __) {
        return GestureDetector(
          onTap: () {
            _queryCount();
          },
          child: Text('${widget.tableName}($data)'),
        );
      },
    );
  }
}
