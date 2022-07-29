import 'dart:async';

import 'package:json2dart_dbffi/database/base_db_manager.dart';
import 'package:sqflite/sqflite.dart';

import 'book_model_dao.dart';
import 'chapter_dao.dart';
import 'font_eg_dao.dart';

class DbManager extends BaseDbManager {
  static DbManager? _instance;

  factory DbManager() => _getInstance();

  static DbManager get instance => _getInstance();

  static DbManager _getInstance() => _instance ??= DbManager._internal();

  DbManager._internal();

  @override
  FutureOr<void> onCreate(Database db, int version) async {
    await db.execute(FontEgDao.tableSql());
    await db.execute(ChapterDao.tableSql());
    await db.execute(BookModelDao.tableSql());
  }

  @override
  int getDbVersion() => 6;

  BookModelDao? _bookModelDao;

  BookModelDao get bookModelDao => _bookModelDao ??= BookModelDao();

  ChapterDao? _chapterDao;

  ChapterDao get chapterDao => _chapterDao ??= ChapterDao();

  FontEgDao? _fontEgDao;

  FontEgDao get fontEgDao => _fontEgDao ??= FontEgDao();
}
