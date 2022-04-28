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

  FutureOr<void> onUpgrade(Database db, int oldVersion, int newVersion) async {}

  FutureOr<void> onCreate(Database db, int version) async {}

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, getDbName());
    _database = await openDatabase(
      path,
      version: getDbVersion(),
      onCreate: onCreate,
      onUpgrade: onUpgrade,
    );
    BaseDbManager.initial(this);
  }

  //数据库的版本号，可复写
  int getDbVersion() => 1;

  //数据库名称，可复写
  String getDbName() => 'client_db.db';
}
