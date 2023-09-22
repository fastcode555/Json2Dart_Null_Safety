import 'package:sqflite/sqflite.dart';

/// @date 19/6/22
/// describe:

mixin _InsertMixin<T> {
  ///插入单个model
  Future<int> insert(T? t, [String? tableName]);

  ///插入所有model
  Future<int> insertAll(
    List<T?> t, {
    String? tableName,
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm = ConflictAlgorithm.replace,
  });

  ///插入map
  Future<int> insertMap(Map<String, dynamic> t, [String? tableName]);
}
mixin _QueryMixin<T> {
  ///调用sqflite 封装好的查询
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
      int? offset});

  ///根据id，查询一个
  Future<T?> queryOne(Object arg, [String? tableName]);

  ///查询该表的所有数据
  Future<List<T>?> queryAll([String? tableName]);

  ///查询该表的总数
  Future<int> queryCount([String? tableName]);

  ///调用sql语句执行
  Future<List<T>?> rawQuery(String sql, [List<Object?>? arguments]);

  ///随机获取一个数据
  Future<T?> random([String? tableName]);

  ///随机查询一组数据
  Future<List<T>?> randoms(int count, [String? tableName]);

  ///查询多个ids
  Future<List<T>> queryMultiIds(List<Object?>? datas, [String? tableName]);
}

mixin _DeleteMixin<T> {
  ///删除数据
  Future<int> delete(T? t, [String? tableName]);

  ///删除多个Id
  Future<int> deleteMulti(List<Object?>? datas, [String? tableName]);
}

mixin _UpdateMixin<T> {
  ///更新map
  Future<int> update(T? t, [String? tableName]);

  ///更新所有数据库
  Future<int> updateAll(
    List<T>? t, {
    String? tableName,
    ConflictAlgorithm? conflictAlgorithm = ConflictAlgorithm.replace,
  });
}

mixin _HelpMixin<T> {
  ///组装Ids
  String composeIds(List<Object> ids);

  ///执行sql语句
  Future<void> execute(String sql, [List<Object?>? arguments]);

  ///清空表所有数据
  Future<void> clear([String? tableName]);

  ///删除表所有数据
  Future<void> drop([String? tableName]);

  T fromJson(Map json);
}

///增加升级表操作的功能
mixin _UpgradeTableFeature {
  void addColumn(String field);
}

///Abstract BaseDao
abstract class ABBaseDao<T>
    with _InsertMixin<T>, _QueryMixin<T>, _DeleteMixin<T>, _UpdateMixin<T>, _HelpMixin<T>, _UpgradeTableFeature {}
