import 'package:flutter/material.dart';
import 'package:json2dart_db/json2dart_db.dart';

import 'table_detail_page.dart';
import 'widgets/custom_scaffold.dart';

/// @date 18/10/22
/// describe:

class TablePage extends StatefulWidget {
  static const String routeName = "/";

  const TablePage({super.key});

  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      lable:
          "${BaseDbManager.instance.getDbName()}:(Version:${BaseDbManager.instance.getDbVersion()})",
      automaticallyImplyLeading: false,
      body: FutureBuilder<List<String>>(
        future: BaseDbManager.instance.queryTables(),
        builder: (_, data) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (_, index) {
              String tableName = data.data![index];
              return InkWell(
                onTap: () async {
                  //after delete table need to requery the table
                  Navigator.of(context)
                      .pushNamed(TableDetailPage.routeName,
                          arguments: tableName)
                      .then((value) {
                    if (value != null && value is String) {
                      setState(() {});
                    }
                  });
                },
                child: Container(
                  height: 30,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: Text('${index + 1}.',
                            style: const TextStyle(color: Colors.white)),
                      ),
                      FutureBuilder<int>(
                        future: BaseDbManager.instance.queryCount(tableName),
                        builder: (_, data) {
                          return Text(
                            '$tableName(${data.data ?? 0})',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ],
                  ),
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
