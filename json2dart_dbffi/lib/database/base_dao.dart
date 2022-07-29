import 'dart:async';
import 'dart:convert';

import 'package:sqflite_common/sqlite_api.dart';

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
  Database get _db => BaseDbManager.instance.db;

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
    final _batch = _db.batch();
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
    final _batch = _db.batch();
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
  Future<void> execute(String sql, [List<Object?>? arguments]) => _db.execute(sql, arguments);

  @override
  Future<int> delete(T? t, [String? tableName]) {
    if (t == null) return Future.value(-1);
    Map<String, dynamic> map = t.primaryKeyAndValue();
    return _db.delete(
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

  @override
  Future<List<T>?> queryAll([String? tableName]) async {
    List<Map<String, Object?>> _lists = await _db.query(tableName ?? table);
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
    List<Map<String, dynamic>> _maps = await _db.query(tableName ?? table, columns: [_primaryKey]);
    return _maps.length;
  }

  @override
  Future<List<T>?> rawQuery(String sql, [List<Object?>? arguments]) async {
    List<Map<String, Object?>> _lists = await _db.rawQuery(sql, arguments);
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
      await _db.execute("delete from ${tableName ?? table}");
      //reset the auto increase id
      await _db.execute("update sqlite_sequence SET seq = 0 where name ='${tableName ?? table}';");
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
    return _db.execute("DROP TABLE ${tableName ?? table}");
  }
}

mixin _SafeInsertFeature {
  Database get _db;

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
    return _db.insert(
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
    return _db.insert(
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
    return _db.update(
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
      if (_isClassBean(value)) {
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
