import 'dart:convert';

import 'package:json2dart_safe/json2dart.dart';

import 'column_info.dart';

///查询获取到的表信息
class TableInfo {
  //表名
  String? name;

  //表明
  String? tblName;

  int? rootPage;

  //变量类型
  String? type;

  //创建表的语句
  String? sql;

  //字段信息
  List<ColumnInfo>? columns;

  TableInfo({
    this.name,
    this.tblName,
    this.rootPage,
    this.type,
    this.sql,
    this.columns,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'tbl_name': tblName,
        'rootpage': rootPage,
        'type': type,
        'sql': sql,
      };

  TableInfo.fromJson(Map json) {
    name = json.asString('name');
    tblName = json.asString('tbl_name');
    rootPage = json.asInt('rootpage');
    type = json.asString('type');
    sql = json.asString('sql');
  }

  static TableInfo toBean(Map json) => TableInfo.fromJson(json);

  @override
  String toString() => jsonEncode(toJson());
}
