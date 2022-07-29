import 'package:book_reader/common/model/font_eg.dart';
import 'package:json2dart_dbffi/json2dart_dbffi.dart';

///用户自定义导入字体的表
class FontEgDao extends BaseDao<FontEg> {
  static const String _tableName = 'font_eg';

  FontEgDao() : super(_tableName, 'md5_id');

  static String tableSql([String? tableName]) => '''
     CREATE TABLE IF NOT EXISTS `${tableName ?? _tableName}` (
      `import_path` TEXT,
      `md5_id` TEXT PRIMARY KEY,
      `font_family` TEXT,
      `title` TEXT
      );''';

  @override
  FontEg fromJson(Map json) => FontEg.fromJson(json);
}
