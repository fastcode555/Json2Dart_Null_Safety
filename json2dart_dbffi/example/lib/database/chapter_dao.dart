import 'package:book_reader/common/model/chapter.dart';
import 'package:json2dart_dbffi/json2dart_dbffi.dart';

///书籍章节的表
class ChapterDao extends BaseDao<Chapter> {
  static const String _tableName = 'chapter';

  ChapterDao() : super(_tableName, 'chapter_id');

  static String tableSql([String? tableName]) => '''
     CREATE TABLE IF NOT EXISTS `${tableName ?? _tableName}` (
      `start` INTEGER,
      `chapter_title` TEXT,
      `end` INTEGER,
      `content` TEXT,
      `chapter_id` INTEGER PRIMARY KEY AUTOINCREMENT
      );''';

  @override
  Chapter fromJson(Map json) => Chapter.fromJson(json);
}
