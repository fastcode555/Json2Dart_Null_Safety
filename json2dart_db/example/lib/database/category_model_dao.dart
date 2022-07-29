import 'package:gesound/common/model/category_model.dart';
import 'package:json2dart_db/json2dart_db.dart';

class CategoryModelDao extends BaseDao<CategoryModel> {
  static const String _tableName = 'category_model';

  CategoryModelDao() : super(_tableName, 'category_id');

  static String tableSql([String? tableName]) => '''
      CREATE TABLE IF NOT EXISTS `${tableName ?? _tableName}` (
      `playlist_count` INTEGER,
      `create_time` INTEGER,
      `song_count` INTEGER,
      `name` TEXT,
      `playlist_ids` TEXT,
      `position` INTEGER,
      `category_id` INTEGER PRIMARY KEY AUTOINCREMENT
      );''';

  @override
  CategoryModel fromJson(Map json) => CategoryModel.fromJson(json);
}
