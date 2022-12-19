import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json2dart_db/database/model/column_info.dart';
import 'package:json2dart_db/database/model/table_info.dart';

/// @date 23/11/22
/// describe: 数据库组件的每一条数据
class DbRowItem extends StatelessWidget {
  final int index;
  final Map<String, Object?> map;
  final List<Map<String, Object?>>? data;
  final TableInfo tableInfo;
  final double rowWidth;

  const DbRowItem(
    this.index,
    this.map,
    this.data, {
    required this.tableInfo,
    required this.rowWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    List<ColumnInfo> columnInfos = tableInfo.columns!;
    bool isLastItem = data!.length - 1 == index;
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
            width: rowWidth,
            decoration: BoxDecoration(
              border: Border(
                right: i != columnInfos.length - 1
                    ? BorderSide(color: Colors.white)
                    : BorderSide.none,
              ),
            ),
            alignment: Alignment.center,
            child: AutoSizeText(
              filedValue,
              maxLines: 1,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis),
              minFontSize: 10,
            ),
          ),
        ),
      );
    }
    if (isLastItem) {
      return Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white))),
        child: Row(children: children),
      );
    }
    return Row(children: children);
  }
}
