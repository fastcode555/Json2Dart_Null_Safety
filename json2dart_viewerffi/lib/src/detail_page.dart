import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json2dart_dbffi/database/model/column_info.dart';
import 'package:json2dart_dbffi/database/model/table_info.dart';
import 'package:json2dart_dbffi/json2dart_dbffi.dart';
import 'package:json2dart_viewerffi/src/widgets/custom_scaffold.dart';

/// @date 18/10/22
/// describe: 显示数表的具体数据，暂未增加查询的功能

class DetailPage extends StatefulWidget {
  static const String routeName = "/src/detail_page";
  final String tableName;

  const DetailPage({super.key, required this.tableName});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TableInfo? _tableInfo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      lable: widget.tableName,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder<TableInfo?>(
          future: _queryTableInfo(),
          builder: (_, data) {
            if (_tableInfo == null) return const SizedBox();
            return Container(
              width: _tableInfo!.columns!.length * 150,
              child: Column(
                children: [
                  const Divider(color: Colors.white, thickness: 1, height: 1),
                  _buildTableHeader(),
                  const Divider(color: Colors.white, thickness: 1, height: 1),
                  Expanded(child: _buildListView()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  ///生成表头
  Widget _buildTableHeader() {
    if (_tableInfo == null || _tableInfo?.columns == null) {
      return const SizedBox();
    }
    List<ColumnInfo> columnInfos = _tableInfo!.columns!;
    List<Widget> children = [];
    for (int i = 0; i < columnInfos.length; i++) {
      ColumnInfo info = columnInfos[i];
      children.add(
        Container(
          height: 35,
          width: 150,
          decoration: BoxDecoration(
            border: Border(
              right: i != columnInfos.length - 1 ? BorderSide(color: Colors.white) : BorderSide.none,
            ),
          ),
          alignment: Alignment.center,
          child: AutoSizeText(
            '${info.name}(${info.type})',
            maxLines: 1,
            style: TextStyle(color: Colors.white, fontSize: 14),
            minFontSize: 10,
          ),
        ),
      );
    }
    return Row(children: children);
  }

  ///查询表信息
  Future<TableInfo?> _queryTableInfo() async {
    if (_tableInfo != null) return _tableInfo;
    _tableInfo = (await BaseDbManager.instance.queryTableInfo(widget.tableName));
    return _tableInfo;
  }

  Widget _buildListView() {
    return FutureBuilder<List<Map<String, Object?>>>(
      future: _queryList(),
      builder: (_, data) {
        return ListView.separated(
          itemBuilder: (_, index) => _buildRow(index, data.data![index]),
          separatorBuilder: (_, index) => const Divider(color: Colors.white, thickness: 1, height: 1),
          itemCount: data.data?.length ?? 0,
        );
      },
    );
  }

  Future<List<Map<String, Object?>>> _queryList() {
    return BaseDbManager.instance.db.query(widget.tableName);
  }

  Widget _buildRow(int index, Map<String, Object?> map) {
    List<Widget> children = [];
    List<ColumnInfo> columnInfos = _tableInfo!.columns!;
    for (int i = 0; i < columnInfos.length; i++) {
      ColumnInfo info = columnInfos[i];
      String filedValue = '${map[info.name]}';
      children.add(
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: filedValue));
          },
          child: Container(
            height: 35,
            width: 150,
            decoration: BoxDecoration(
              border: Border(
                right: i != columnInfos.length - 1 ? BorderSide(color: Colors.white) : BorderSide.none,
              ),
            ),
            alignment: Alignment.center,
            child: AutoSizeText(
              filedValue,
              maxLines: 1,
              style: TextStyle(color: Colors.white, fontSize: 14, overflow: TextOverflow.ellipsis),
              minFontSize: 10,
            ),
          ),
        ),
      );
    }
    return Row(children: children);
  }
}
