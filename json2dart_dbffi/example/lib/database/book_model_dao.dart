import 'dart:async';

import 'package:book_reader/common/model/book_model.dart';
import 'package:book_reader/database/db_manager.dart';
import 'package:flutter/material.dart';
import 'package:json2dart_dbffi/json2dart_dbffi.dart';

///书籍的表
class BookModelDao extends BaseDao<BookModel> {
  static const String _tableName = "book_model";

  BookModelDao() : super(_tableName, "md5_id");

  static String tableSql([String? tableName]) => '''
      CREATE TABLE IF NOT EXISTS `${tableName ?? _tableName}` (
      `cover` TEXT,
      `path` TEXT,
      `chapter` TEXT,
      `wordCount` INTEGER,
      `md5_id` TEXT PRIMARY KEY,
      `author` TEXT,
      `description` TEXT,
      `title` TEXT,
      `last_index` INTEGER,
      `last_offset` DOUBLE,
      `chapter_count` INTEGER
      );''';

  @override
  FutureOr<void> onUpgrade(int oldVersion, int newVersion) {
    ///测试了两次表更新功能，都能正常升级，插入新的字段
    if (oldVersion == 4 && newVersion == 5) {
      execute('ALTER TABLE $table ADD COLUMN testKey String');
      debugPrint("执行表升级的操作");
    }
    if (oldVersion == 5 && newVersion == 6) {
      execute('ALTER TABLE $table ADD COLUMN test_key2 String');
      debugPrint("执行表升级的操作，测试是否正常升级表test_key2");
    }
  }

  @override
  BookModel fromJson(Map json) => BookModel.fromJson(json);

  @override
  Future<int> delete(BookModel? t, [String? tableName]) async {
    //删除书籍也需要跟着删除书籍所带有的所有章节内容
    await DbManager.instance.chapterDao.clear("chapter_${t?.md5Id}");
    return super.delete(t, tableName);
  }
}
