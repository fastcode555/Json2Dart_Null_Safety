import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDbManager {
  static BaseDbManager? _instance;
  Database? _database;

  Database get db => _database!;

  static BaseDbManager get instance => _instance!;
  bool isCreateFinish = false;

  static initial(BaseDbManager manager) {
    BaseDbManager._instance = manager;
  }

  ///版本号变更，调用onCreate，创建未创建的table
  FutureOr<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    await onCreate(db, newVersion);
  }

  FutureOr<void> onCreate(Database db, int version) async {}

  Future<void> init([String? dbName]) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName ?? getDbName());
    _database = await openDatabase(
      path,
      version: getDbVersion(),
      onCreate: onCreate,
      onUpgrade: onUpgrade,
    );
    BaseDbManager.initial(this);
  }

  ///数据库的版本号，可复写
  int getDbVersion() => 2;

  ///数据库名称，可复写
  String getDbName() => 'client_db.db';
}
