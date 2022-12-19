import 'package:flutter/material.dart';
import 'package:json2dart_dbffi/database/model/table_info.dart';
import 'package:json2dart_dbffi/json2dart_dbffi.dart';

import 'db_row_item.dart';

/// @date 23/11/22
/// describe:数据库的列表
class DbListView extends StatelessWidget {
  final TableInfo tableInfo;
  final double rowWidth;

  const DbListView({required this.tableInfo, required this.rowWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
      future: _queryList(),
      builder: (_, data) {
        return ListView.separated(
          physics: ClampingScrollPhysics(),
          itemBuilder: (_, index) {
            return DbRowItem(
              index,
              data.data![index],
              data.data,
              tableInfo: tableInfo,
              rowWidth: rowWidth,
            );
          },
          separatorBuilder: (_, index) =>
              const Divider(color: Colors.white, thickness: 1, height: 1),
          itemCount: data.data?.length ?? 0,
        );
      },
    );
  }

  Future<List<Map<String, Object?>>> _queryList() {
    return BaseDbManager.instance.db.query(tableInfo.name!);
  }
}
