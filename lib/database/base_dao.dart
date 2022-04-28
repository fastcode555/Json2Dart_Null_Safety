import 'package:json2dart_safe/json2dart.dart';
import 'package:sqflite/sqflite.dart';

import 'database_ext.dart';

/// @date 27/4/22
/// describe:
///@author:Barry

abstract class BaseDao<T extends BaseDbModel> {
  String? __tableName;

  Database get _db => BaseDbManager.instance.db;

  String get _table {
    if (__tableName != null) {
      return __tableName!;
    }
    String daoName = this.runtimeType.toString();
    __tableName = daoName.replaceRange(daoName.length - 3, daoName.length, "");
    return __tableName!;
  }

  ///insert into the string
  Future<int> insert(T t, [String? tableName]) {
    return _db.insertSafe(tableName ?? _table, t);
  }

  ///update the database string
  Future<int> update(T t, [String? tableName]) {
    return _db.updateSafe(tableName ?? _table, t);
  }

  ///execute the sql
  Future<void> execute(String sql, [List<Object?>? arguments]) {
    return _db.execute(sql);
  }

  ///删除数据库中的数据
  Future<void> delete(T t, [String? tableName]) {
    Map<String, dynamic> map = t.primaryKeyAndValue();
    return _db.delete(
      tableName ?? _table,
      where: "${map.keys.first} = ?",
      whereArgs: map.values.first,
    );
  }

  Future<List<T>> query(T Function(Map json) toBean,
      {String? tableName,
      bool? distinct,
      List<String>? columns,
      String? where,
      List<Object?>? whereArgs,
      String? groupBy,
      String? having,
      String? orderBy,
      int? limit,
      int? offset}) async {
    List<Map<String, Object?>> _lists = await _db.query(tableName ?? _table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);
    List<T> _datas = [];
    for (Map<String, Object?> map in _lists) {
      _datas.add(toBean(map));
    }
    return _datas;
  }

  Future<List<T>> queryAll(T Function(Map json) toBean, [String? tableName]) async {
    List<Map<String, Object?>> _lists = await _db.query(tableName ?? _table);
    List<T> _datas = [];
    for (Map<String, Object?> map in _lists) {
      _datas.add(toBean(map));
    }
    return _datas;
  }

  //delete the table all the datas
  Future<void> clear([String? tableName]) async {
    try {
      await _db.execute("delete from ${tableName ?? _table}");
      //reset the auto increase id
      await _db.execute("update sqlite_sequence SET seq = 0 where name ='${tableName ?? _table}';");
    } catch (e) {
      print(e);
    }
  }
}
