import 'package:gesound/common/model/playlist_model.dart';
import 'package:json2dart_db/json2dart_db.dart';

class PlaylistModelDao extends BaseDao<PlaylistModel> {
  static const String _tableName = 'playlist_model';

  PlaylistModelDao() : super(_tableName, 'playlist_id');

  static String tableSql([String? tableName]) => '''
      CREATE TABLE IF NOT EXISTS `${tableName ?? _tableName}` (
      `cover` TEXT,
      `create_time` TEXT,
      `singer_name` TEXT,
      `name` TEXT,
      `song_ids` TEXT,
      `count` INTEGER,
      `position` INTEGER,
      `singer_num` INTEGER,
      `song_num` TEXT,
      `type` INTEGER,
      `is_pin` BOOLEAN,
      `source` TEXT,
      `extra_id` TEXT,
      `ext` TEXT,
      `playlist_type` TEXT,
      `last_play_audioId` TEXT,
      `last_play_position` INTEGER,
      `playlist_id` INTEGER PRIMARY KEY AUTOINCREMENT
      );''';

  @override
  PlaylistModel fromJson(Map json) => PlaylistModel.fromJson(json);

  ///根据id，进行多Ids查询播放列表
  Future<List<PlaylistModel>> queryMultiIds(List<Object?>? playlistIds, [String? name]) async {
    if (playlistIds == null || playlistIds.isEmpty) return [];
    String sql = "select * from $table where playlist_id in(${playlistIds.join(',')})";
    List<PlaylistModel>? _playlists = await rawQuery(sql);
    return _playlists ?? [];
  }

  ///根据存储的额外id，进行导入
  Future<PlaylistModel?> queryFromExtraId(String extraId) async {
    List<PlaylistModel>? _models = await query(whereArgs: [extraId], where: "extra_id = ?");
    return _models != null && _models.isNotEmpty ? _models[0] : null;
  }
}
