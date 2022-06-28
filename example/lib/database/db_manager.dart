import 'dart:async';

import 'package:json2dart_db/json2dart_db.dart';
import 'package:sqflite/sqflite.dart';

import 'audio_model_dao.dart';
import 'category_model_dao.dart';
import 'playlist_model_dao.dart';

class DbManager extends BaseDbManager {
  static DbManager? _instance;

  factory DbManager() => _getInstance();

  static DbManager get instance => _getInstance();

  static DbManager _getInstance() {
    _instance ??= DbManager._internal();
    return _instance!;
  }

  DbManager._internal();

  @override
  FutureOr<void> onCreate(Database db, int version) async {
    await db.execute(AudioModelDao.tableSql());
    await db.execute(PlaylistModelDao.tableSql());
    await db.execute(CategoryModelDao.tableSql());
  }

  @override
  int getDbVersion() => 3;

  CategoryModelDao? _categoryModelDao;

  CategoryModelDao get categoryModelDao => _categoryModelDao ??= CategoryModelDao();

  PlaylistModelDao? _playlistModelDao;

  PlaylistModelDao get playlistModelDao => _playlistModelDao ??= PlaylistModelDao();

  AudioModelDao? _audioModelDao;

  AudioModelDao get audioModelDao => _audioModelDao ??= AudioModelDao();
}
