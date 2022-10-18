import 'dart:async';

import 'package:json2dart_dbffi/database/model/column_info.dart';
import 'package:json2dart_dbffi/database/model/table_info.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

abstract class BaseDbManager {
  static BaseDbManager? _instance;
  Database? _database;

  Database get db => _database!;

  //获取数据库的版本
  int oldVersion = -1;
  int newVersion = -1;

  static BaseDbManager get instance => _instance!;
  bool isCreateFinish = false;

  static initial(BaseDbManager manager) {
    BaseDbManager._instance = manager;
  }

  ///版本号变更，调用onCreate，创建未创建的table
  FutureOr<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    this.newVersion = newVersion;
    this.oldVersion = oldVersion;
    //执行创建新的表
    await onCreate(db, newVersion);
  }

  /// onCreate the database
  FutureOr<void> onCreate(Database db, int version) async {}

  ///on open the database
  FutureOr<void> onOpen(Database db) async {}

  ///项目进行初始化
  Future<void> init([String? dbName]) async {
    // Init ffi loader if needed.
    sqfliteFfiInit();
    var databasesPath = await databaseFactoryFfi.getDatabasesPath();
    String path = join(databasesPath, dbName ?? getDbName());
    _database = await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: getDbVersion(),
        onCreate: onCreate,
        onUpgrade: onUpgrade,
        onOpen: onOpen,
      ),
    );
    BaseDbManager.initial(this);
  }

  ///数据库的版本号，可复写
  int getDbVersion() => 2;

  ///数据库名称，可复写
  String getDbName() => 'client_db.db';

  ///查询数据库中所有的表
  Future<List<String>> queryTables() async {
    List<Map<String, Object?>> maps =
        await _database!.rawQuery("select name from sqlite_master where type='table' order by name;");
    List<String> _tables = [];
    for (Map<String, Object?> map in maps) {
      _tables.add(map['name'].toString());
    }
    return _tables;
  }

  ///查询表信息
  Future<TableInfo?> queryTableInfo(String name) async {
    List<Map<String, Object?>> maps = await _database!.rawQuery('select * from sqlite_master where name = "$name"');
    if (maps.isNotEmpty) {
      TableInfo tableInfo = TableInfo.fromJson(maps[0]);
      List<Map<String, Object?>> datas = await _database!.rawQuery("pragma table_info ('$name');");
      List<ColumnInfo> columns = [];
      for (Map<String, Object?> map in datas) {
        ColumnInfo info = ColumnInfo.fromJson(map);
        columns.add(info);
      }
      tableInfo.columns = columns;
      return tableInfo;
    }
    return null;
  }
}
