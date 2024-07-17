import 'package:flutter/material.dart';
import 'package:json2dart_db/database/model/table_info.dart';
import 'package:json2dart_db/json2dart_db.dart';
import 'package:json2dart_viewer/src/sql_hightlight.dart';

import 'widgets/custom_scaffold.dart';

/// @date 23/11/22
/// describe:
class TableStructurePage extends StatelessWidget {
  final String tableName;
  static const String routeName = "/src/TableStructurePage";

  const TableStructurePage({required this.tableName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      lable: tableName,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder<TableInfo?>(
          future: BaseDbManager.instance.queryTableInfo(tableName),
          builder: (_, data) {
            if (data.data == null) return const SizedBox();
            return SelectableText.rich(
              TextSpan(children: parseSql(data.data?.sql ?? "")),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
    );
  }
}
