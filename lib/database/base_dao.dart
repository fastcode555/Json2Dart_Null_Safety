import 'package:json2dart_safe/json2dart.dart';

import 'database_ext.dart';

/// @date 27/4/22
/// describe:
///@author:Barry

abstract class BaseDao<T extends BaseDbModel> {
  Future<int> insert(T t, [String? tableName]) {
    return BaseDbManager.instance.db.insertSafe(tableName ?? table, t);
  }

  Future<int> update(T t, [String? tableName]) {
    return BaseDbManager.instance.db.updateSafe(tableName ?? table, t);
  }

  Future<void> execute(String sql, [List<Object?>? arguments]) {
    return BaseDbManager.instance.db.execute(sql);
  }

  ///删除数据库中的数据
  Future<void> delete(T t, [String? tableName]) {
    Map<String, dynamic> map = t.primaryKeyAndValue();
    return BaseDbManager.instance.db.delete(
      tableName ?? table,
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
    List<Map<String, Object?>> _lists = await BaseDbManager.instance.db.query(tableName ?? table,
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
    List<Map<String, Object?>> _lists = await BaseDbManager.instance.db.query(tableName ?? table);
    List<T> _datas = [];
    for (Map<String, Object?> map in _lists) {
      _datas.add(toBean(map));
    }
    return _datas;
  }

  String get table;
}
