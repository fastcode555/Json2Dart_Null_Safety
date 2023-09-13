import 'package:gesound/common/model/audio_model.dart';
import 'package:json2dart_db/json2dart_db.dart';

class AudioModelDao extends BaseDao<AudioModel> {
  static const String _tableName = 'audio_model';

  AudioModelDao() : super(_tableName, 'song_num');

  static String tableSql([String? tableName]) => '''
      CREATE TABLE IF NOT EXISTS `${tableName ?? _tableName}` (
      `lyrics_time` TEXT,
      `song_singer_name` TEXT,
      `song_name` TEXT,
      `music_verify` INTEGER,
      `duration` INTEGER,
      `playlist_ids` TEXT,
      `update_time` TEXT,
      `video_url` TEXT,
      `issue_date` TEXT,
      `song_singer_image` TEXT,
      `song_created_at` TEXT,
      `language_text` TEXT,
      `song_album_image` TEXT,
      `song_album_views` INTEGER,
      `song_singer_views` INTEGER,
      `song_singer` INTEGER,
      `audio_url_size` INTEGER,
      `song_views` INTEGER,
      `song_updated_at` TEXT,
      `audio_url_size_time` INTEGER,
      `song_album_name` TEXT,
      `lyric_content` TEXT,
      `down_load_url` TEXT,
      `song_album` INTEGER,
      `index_no` INTEGER,
      `album_update_time` TEXT,
      `audio_url` TEXT,
      `album_language` TEXT,
      `format` TEXT,
      `source` TEXT,
      `ext` TEXT,
      `local_path` TEXT,
      `is_audio_book` BOOLEAN,
      `song_num` TEXT PRIMARY KEY
      );''';

  @override
  AudioModel fromJson(Map json) => AudioModel.fromJson(json);

  @override
  Future<List<AudioModel>> queryMultiIds(List<Object?>? songIds, [String? tableName]) async {
    if (songIds == null || songIds.isEmpty) return [];
    String _ids = composeIds(songIds);
    //查询多条记录
    String sql = "select * from $table where song_num in($_ids) order by index_no ASC";
    List<AudioModel>? _playlists = await rawQuery(sql);
    return _playlists ?? [];
  }
}
