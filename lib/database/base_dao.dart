import 'dart:ffi';

import 'package:json2dart_safe/json2dart.dart';
import 'package:sqflite/sqflite.dart';

/// @date 27/4/22
/// describe:
///@author:Barry

abstract class BaseDao<T extends BaseDbModel> {
  String __tableName = '';
  String _primaryKey = '';

  BaseDao(String tableName, String primaryKey) {
    __tableName = tableName;
    _primaryKey = primaryKey;
  }

  Database get _db => BaseDbManager.instance.db;

  String get table => __tableName;

  ///insert into the string
  Future<int> insert(T? t, [String? tableName]) {
    if (t == null) return Future.value(-1);
    return _db.insertSafe(tableName ?? table, t);
  }

  ///insert all the bean
  Future<int> insertAll(List<T?> t, [String? tableName]) {
    for (T? c in t) {
      if (c == null) continue;
      _db.insertSafe(tableName ?? table, c);
    }
    return Future.value(0);
  }

  ///insert the bean map into the table
  Future<int> insertMap(Map<String, dynamic> t, [String? tableName]) {
    return _db.insertMap(tableName ?? table, t);
  }

  ///update the database string
  Future<int> update(T? t, [String? tableName]) {
    if (t == null) return Future.value(-1);
    return _db.updateSafe(tableName ?? table, t);
  }

  ///execute the sql
  Future<void> execute(String sql, [List<Object?>? arguments]) {
    return _db.execute(sql, arguments);
  }

  ///删除数据库中的数据
  Future<void> delete(T? t, [String? tableName]) {
    if (t == null) return Future.value(Void);
    Map<String, dynamic> map = t.primaryKeyAndValue();
    return _db.delete(
      tableName ?? table,
      where: "${map.keys.first} = ?",
      whereArgs: [map.values.first],
    );
  }

  Future<List<T>?> query(
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
    List<Map<String, Object?>> _lists = await _db.query(tableName ?? table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);
    if (_lists.isEmpty) return null;
    List<T> _datas = [];
    for (Map<String, Object?> map in _lists) {
      _datas.add(fromJson(map));
    }
    return _datas;
  }

  ///查询其中的所有数据
  Future<List<T>?> queryAll([String? tableName]) async {
    List<Map<String, Object?>> _lists = await _db.query(tableName ?? table);
    if (_lists.isEmpty) return null;
    List<T> _datas = [];
    for (Map<String, Object?> map in _lists) {
      _datas.add(fromJson(map));
    }
    return _datas;
  }

  ///according the argument query the data
  Future<T?> queryOne(Object arg, [String? tableName]) async {
    List<T>? _items = await query(tableName: tableName, where: "$_primaryKey = ?", whereArgs: [arg]);
    return _items?.first;
  }

  ///get the all datas count
  Future<int> queryCount([String? tableName]) async {
    List<Map<String, dynamic>> _maps = await _db.query(tableName ?? table, columns: [_primaryKey]);
    return _maps.length;
  }

  Future<List<T>?> rawQuery(String sql, [List<Object?>? arguments]) async {
    List<Map<String, Object?>> _lists = await _db.rawQuery(sql, arguments);
    if (_lists.isEmpty) return null;
    List<T> _datas = [];
    for (Map<String, Object?> map in _lists) {
      _datas.add(fromJson(map));
    }
    return _datas;
  }

  ///delete the table all the datas
  Future<void> clear([String? tableName]) async {
    try {
      await _db.execute("delete from ${tableName ?? table}");
      //reset the auto increase id
      await _db.execute("update sqlite_sequence SET seq = 0 where name ='${tableName ?? table}';");
    } catch (e) {
      print(e);
    }
  }

  ///get a random item
  Future<T?> random([String? tableName]) async {
    List<T>? items = await query(tableName: tableName, orderBy: "RANDOM()", limit: 1);
    return items?.first;
  }

  ///get a random list
  Future<List<T>?> randoms(int count, [String? tableName]) async {
    List<T>? items = await query(tableName: tableName, orderBy: "RANDOM()", limit: count);
    return items;
  }

  ///delete the table
  Future<void> drop([String? tableName]) async {
    return _db.execute("DROP TABLE ${tableName ?? table}");
  }

  T fromJson(Map json);
}
