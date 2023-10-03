import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import 'abstract_base_dao.dart';
import 'base_db_manager.dart';
import 'base_db_model.dart';

/// @date 27/4/22
/// describe:
///@author:Barry
abstract class BaseDao<T extends BaseDbModel> extends ABBaseDao<T> with _SafeInsertFeature {
  String __tableName = '';
  String _primaryKey = '';

  BaseDao(String tableName, String primaryKey) {
    __tableName = tableName;
    _primaryKey = primaryKey;
    BaseDbManager manager = BaseDbManager.instance;
    if (manager.oldVersion != -1 && manager.newVersion != -1) {
      onUpgrade(manager.oldVersion, manager.newVersion);
    }
  }

  ///增加表更新的方法，这里只是回调到每个dao类中，一个dao类一个表，针对当前表进行更新
  FutureOr<void> onUpgrade(int oldVersion, int newVersion) {}

  @override
  Database get db => BaseDbManager.instance.db;

  String get table => __tableName;

  @override
  Future<int> insert(T? t, [String? tableName]) => _insertSafe(tableName ?? table, t);

  @override
  Future<int> insertAll(
    List<T?> t, {
    String? tableName,
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm = ConflictAlgorithm.replace,
  }) async {
    final _batch = db.batch();
    for (T? c in t) {
      if (c == null) continue;
      Map<String, dynamic> values = c.toJson();
      _convertSafeMap(values);
      _batch.insert(
        tableName ?? table,
        values,
        nullColumnHack: nullColumnHack,
        conflictAlgorithm: conflictAlgorithm,
      );
    }
    await _batch.commit(noResult: true);
    return Future.value(0);
  }

  @override
  Future<int> insertMap(Map<String, dynamic> t, [String? tableName]) => _insertMap(tableName ?? table, t);

  @override
  Future<int> update(T? t, [String? tableName]) => _updateSafe(tableName ?? table, t);

  @override
  Future<int> updateAll(
    List<T>? t, {
    String? tableName,
    ConflictAlgorithm? conflictAlgorithm = ConflictAlgorithm.replace,
  }) async {
    if (t == null || t.isEmpty) return Future.value(-1);
    final _batch = db.batch();
    for (T? c in t) {
      if (c == null) continue;
      Map<String, dynamic> values = c.toJson();
      Map keyAndValues = c.primaryKeyAndValue();
      _convertSafeMap(values);
      _batch.update(
        tableName ?? table,
        values,
        conflictAlgorithm: conflictAlgorithm,
        where: "${keyAndValues.keys.first} = ?",
        whereArgs: [keyAndValues.values.first],
      );
    }
    await _batch.commit(noResult: true);
    return Future.value(0);
  }

  @override
  Future<void> execute(String sql, [List<Object?>? arguments]) => db.execute(sql, arguments);

  @override
  Future<int> delete(T? t, [String? tableName]) {
    if (t == null) return Future.value(-1);
    Map<String, dynamic> map = t.primaryKeyAndValue();
    return db.delete(
      tableName ?? table,
      where: "${map.keys.first} = ?",
      whereArgs: [map.values.first],
    );
  }

  @override
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
    List<Map<String, Object?>> _lists = await db.query(tableName ?? table,
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

  @override
  Future<List<T>?> queryAll([String? tableName]) async {
    List<Map<String, Object?>> _lists = await db.query(tableName ?? table);
    if (_lists.isEmpty) return null;
    List<T> _datas = [];
    for (Map<String, Object?> map in _lists) {
      _datas.add(fromJson(map));
    }
    return _datas;
  }

  @override
  Future<T?> queryOne(Object arg, [String? tableName]) async {
    List<T>? _items = await query(tableName: tableName, where: "$_primaryKey = ?", whereArgs: [arg]);
    return _items?.first;
  }

  @override
  Future<int> queryCount([String? tableName]) async {
    List<Map<String, dynamic>> _maps = await db.query(tableName ?? table, columns: [_primaryKey]);
    return _maps.length;
  }

  @override
  Future<List<T>?> rawQuery(String sql, [List<Object?>? arguments]) async {
    List<Map<String, Object?>> _lists = await db.rawQuery(sql, arguments);
    if (_lists.isEmpty) return null;
    List<T> _datas = [];
    for (Map<String, Object?> map in _lists) {
      _datas.add(fromJson(map));
    }
    return _datas;
  }

  @override
  Future<void> clear([String? tableName]) async {
    try {
      await db.execute("delete from ${tableName ?? table}");
      //reset the auto increase id
      await db.execute("update sqlite_sequence SET seq = 0 where name ='${tableName ?? table}';");
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<T?> random([String? tableName]) async {
    List<T>? items = await query(tableName: tableName, orderBy: "RANDOM()", limit: 1);
    return items?.first;
  }

  @override
  Future<List<T>?> randoms(int count, [String? tableName]) async {
    List<T>? items = await query(tableName: tableName, orderBy: "RANDOM()", limit: count);
    return items;
  }

  @override
  Future<void> drop([String? tableName]) async {
    return db.execute("DROP TABLE ${tableName ?? table}");
  }

  ///add the new column for table,
  ///the filed just like 'name Text'
  @override
  void addColumn(String field) {
    execute('ALTER TABLE $table ADD COLUMN $field');
  }

  @override
  String composeIds(List<Object?>? datas) {
    if (datas == null || datas.isEmpty) return "";
    StringBuffer buffer = StringBuffer();
    if (datas is List<String>) {
      for (var id in datas) {
        if (id == null) continue;
        buffer.write('\'$id\'');
        buffer.write(',');
      }
      String ids = buffer.toString();
      ids = ids.substring(0, ids.length - 1);
      return ids;
    } else if (datas is List<num>) {
      return datas.join(",");
    }
    return "";
  }

  @override
  Future<int> deleteMulti(List<Object?>? datas, [String? tableName]) async {
    if (datas is List<T>) {
      final _batch = db.batch();
      for (T? c in datas) {
        if (c == null) continue;
        Map map = c.primaryKeyAndValue();
        _batch.delete(tableName ?? table, where: "${map.keys.first} = ?", whereArgs: [map.values.first]);
      }
      await _batch.commit(noResult: true);
    } else {
      String ids = composeIds(datas);
      String sql = "delete from $table where $_primaryKey in ($ids)";
      try {
        return await db.rawDelete(sql);
      } catch (e) {
        print(e);
      }
    }
    return -1;
  }

  @override
  Future<List<T>> queryMultiIds(List<Object?>? datas, [String? tableName]) async {
    String ids = composeIds(datas);
    if (ids.trim().isEmpty) return [];
    String sql = "select * from $table where $_primaryKey in($ids)";
    List<T>? results = await rawQuery(sql);
    return results ?? [];
  }
}

mixin _SafeInsertFeature {
  Database get db;

  ///将模型插入到数据库中
  Future<int> _insertSafe(
    String tableName,
    BaseDbModel? t, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm = ConflictAlgorithm.replace,
  }) {
    if (t == null) return Future.value(-1);
    Map<String, dynamic> values = t.toJson();
    _convertSafeMap(values);
    return db.insert(
      tableName,
      values,
      nullColumnHack: nullColumnHack,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  ///将模型插入到数据库中
  Future<int> _insertMap(
    String tableName,
    Map<String, dynamic> t, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm = ConflictAlgorithm.replace,
  }) {
    Map<String, dynamic> values = Map.from(t);
    _convertSafeMap(values);
    return db.insert(
      tableName,
      values,
      nullColumnHack: nullColumnHack,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  ///更新数据库中的模型
  Future<int> _updateSafe(
    String tableName,
    BaseDbModel? t, {
    ConflictAlgorithm? conflictAlgorithm = ConflictAlgorithm.replace,
  }) {
    if (t == null) return Future.value(-1);
    Map<String, dynamic> map = t.primaryKeyAndValue();
    Map<String, dynamic> values = t.toJson();
    _convertSafeMap(values);
    return db.update(
      tableName,
      values,
      conflictAlgorithm: conflictAlgorithm,
      where: "${map.keys.first} = ?",
      whereArgs: [map.values.first],
    );
  }

  ///将所有数组或者bean对象转换成string，重新放回数组中，这样才可以安全的存储map
  void _convertSafeMap(Map<String, Object?> values) {
    for (String key in values.keys) {
      Object? value = values[key];
      if (value == null) continue;
      if (value is bool) {
        values[key] = value.toString();
      } else if (_isClassBean(value)) {
        values[key] = jsonEncode(value);
      }
    }
  }

  ///判断是对象或者数组
  bool _isClassBean(Object obj) {
    bool isClassBean = true;
    if (obj is String || obj is num || obj is bool) {
      isClassBean = false;
    } else if (obj is Map && obj.isEmpty) {
      isClassBean = false;
    }
    return isClassBean;
  }
}
