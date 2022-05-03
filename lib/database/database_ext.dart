import 'dart:convert';

import 'package:json2dart_safe/base_db_model.dart';
import 'package:sqflite/sqflite.dart';

/// @author: Barry
/// @date 27/4/22
/// describe: 对DataBase 一些相关操作进行封装
extension DataBaseExt on Database {
  ///将模型插入到数据库中
  Future<int> insertSafe(
    String tableName,
    BaseDbModel t, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm = ConflictAlgorithm.replace,
  }) {
    Map<String, dynamic> values = t.toJson();
    _convertSafeMap(values);
    return insert(
      tableName,
      values,
      nullColumnHack: nullColumnHack,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  ///将模型插入到数据库中
  Future<int> insertMap(
    String tableName,
    Map<String, dynamic> t, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm = ConflictAlgorithm.replace,
  }) {
    Map<String, dynamic> values = Map.from(t);
    _convertSafeMap(values);
    return insert(
      tableName,
      values,
      nullColumnHack: nullColumnHack,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  ///更新数据库中的模型
  Future<int> updateSafe(
    String tableName,
    BaseDbModel t, {
    ConflictAlgorithm? conflictAlgorithm = ConflictAlgorithm.replace,
  }) {
    Map<String, dynamic> values = t.toJson();
    _convertSafeMap(values);
    return update(tableName, values, conflictAlgorithm: conflictAlgorithm);
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
