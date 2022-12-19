import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:json2dart_dbffi/database/model/column_info.dart';
import 'package:json2dart_dbffi/database/model/table_info.dart';

/// @date 23/11/22
/// describe: 数据库组件的表头
class DbTableHeader extends StatelessWidget {
  final double rowWidth;
  final TableInfo? tableInfo;

  const DbTableHeader({
    required this.rowWidth,
    this.tableInfo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tableInfo == null || tableInfo?.columns == null) {
      return const SizedBox();
    }
    List<ColumnInfo> columnInfos = tableInfo!.columns!;
    List<Widget> children = [];
    for (int i = 0; i < columnInfos.length; i++) {
      ColumnInfo info = columnInfos[i];
      String type =
          info.type == null || info.type!.isEmpty ? '' : "(${info.type})";
      children.add(
        Container(
          height: 35,
          width: rowWidth,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            border: Border(
                right: i != columnInfos.length - 1
                    ? BorderSide(color: Colors.white)
                    : BorderSide.none),
          ),
          alignment: Alignment.center,
          child: AutoSizeText(
            '${info.name}$type',
            maxLines: 1,
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            minFontSize: 10,
          ),
        ),
      );
    }
    return Row(children: children);
  }
}
