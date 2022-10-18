import 'package:flutter/material.dart';
import 'package:json2dart_dbffi/json2dart_dbffi.dart';

import 'detail_page.dart';
import 'widgets/custom_scaffold.dart';

/// @date 18/10/22
/// describe:
class TablePage extends StatelessWidget {
  static const String routeName = "/";

  const TablePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      lable: "Tables",
      automaticallyImplyLeading: false,
      body: FutureBuilder<List<String>>(
        future: BaseDbManager.instance.queryTables(),
        builder: (_, data) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (_, index) {
              String tableName = data.data![index];
              return InkWell(
                onTap: () async {
                  Navigator.of(context).pushNamed(DetailPage.routeName, arguments: tableName);
                },
                child: Container(
                  height: 30,
                  alignment: Alignment.centerLeft,
                  child: Text(tableName, style: TextStyle(color: Colors.white)),
                ),
              );
            },
            itemCount: data.data?.length ?? 0,
          );
        },
      ),
    );
  }
}
