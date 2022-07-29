import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:gesound/common/model/audio_model.dart';
import 'package:gesound/database/db_manager.dart';
import 'package:json2dart_db/json2dart_db.dart';
import 'package:json2dart_safe/json2dart.dart';

class PlaylistModel with BaseDbModel {
  static const String audioBook = 'audio_book';
  static const String album = 'album';
  static const int localPlaylistId = -1000000;

  String? cover;
  String? createTime;
  String? singerName;
  String? name;
  int? count;
  int? position;
  int? singerNum;
  String? songNum;
  bool? isPin;
  int? playlistId;
  String? extraId;
  List<String>? songIds;
  String? source;
  String? ext;
  String? playlistType;

  //上次播放的列表的Id
  String? lastPlayAudioId;
  int? lastPlayPosition;

  bool get isAudiobook => playlistType == PlaylistModel.audioBook;

  bool get isAlbum => playlistType == PlaylistModel.album;

  //播放列表的类型，小说跟音乐
  int? type;

  bool get isLocal => AudioModel.sourceLocal == source;

  bool get isRemote => AudioModel.sourceRemote == source || TextUtil.isEmpty(source);

  bool get isCloud => AudioModel.sourceCloud == source;

  PlaylistModel({
    this.cover,
    this.createTime,
    this.singerName,
    this.name,
    this.count,
    this.position,
    this.singerNum,
    this.songNum,
    this.isPin,
    this.playlistId,
    this.extraId,
    this.songIds,
    this.type,
    this.source,
    this.ext,
    this.playlistType,
    this.lastPlayAudioId,
    this.lastPlayPosition,
  });

  PlaylistModel.empty({
    this.cover,
    this.createTime,
    this.singerName,
    this.name,
    this.count = 0,
    this.position,
    this.singerNum,
    this.songNum,
    this.isPin = false,
    this.playlistId,
    this.extraId,
    this.type,
    this.songIds,
    this.ext,
    this.playlistType,
    this.lastPlayAudioId,
    this.lastPlayPosition,
  });

  PlaylistModel.local({
    this.cover,
    this.createTime,
    this.singerName,
    this.name,
    this.count = 0,
    this.position,
    this.singerNum,
    this.songNum,
    this.isPin = false,
    this.playlistId = localPlaylistId,
    this.extraId,
    this.type,
    this.songIds,
    this.ext,
    this.source = AudioModel.sourceLocal,
    this.lastPlayAudioId,
    this.lastPlayPosition,
  });

  int get index {
    if (position == null) return playlistId!;
    return position == 0 && position == playlistId ? 0 : (position! > 0 ? position! : playlistId!);
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{}
    ..put('cover', cover)
    ..put('create_time', createTime)
    ..put('singer_name', singerName)
    ..put('name', name)
    ..put('count', count)
    ..put('position', position)
    ..put('singer_num', singerNum)
    ..put('song_num', songNum)
    ..put('is_pin', isPin)
    ..put('song_ids', songIds)
    ..put('type', type)
    ..put('source', source)
    ..put('ext', ext)
    ..put('extra_id', extraId)
    ..put('playlist_type', playlistType)
    ..put('last_play_audioId', lastPlayAudioId)
    ..put('last_play_position', lastPlayPosition)
    ..put('playlist_id', playlistId);

  PlaylistModel.fromJson(Map json) {
    cover = json.asString('cover');
    createTime = json.asString('create_time');
    singerName = json.asString('singer_name');
    name = json.asString('name');
    source = json.asString('source');
    ext = json.asString('ext');
    count = json.asInt('count');
    position = json.asInt('position');
    singerNum = json.asInt('singer_num');
    songNum = json.asString('songNum');
    isPin = json.asBool('is_pin');
    songIds = json.asList<String>('song_ids');
    playlistId = json.asInt('playlist_id');
    extraId = json.asString('extra_id');
    playlistType = json.asString('playlist_type');
    lastPlayAudioId = json.asString('last_play_audioId');
    lastPlayPosition = json.asInt('last_play_position');
    type = json.asInt('type');
  }

  static PlaylistModel toBean(Map json) => PlaylistModel.fromJson(json);

  @override
  Map<String, dynamic> primaryKeyAndValue() => {"playlist_id": playlistId};

  @override
  int get hashCode => playlistId?.hashCode ?? super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is PlaylistModel && playlistId != null) {
      return other.playlistId == playlistId;
    }
    return super == other;
  }

  @override
  String toString() => jsonEncode(toJson());

  void clearCover() {
    cover = '';
    songNum = null;
    source = '';
  }

  ///将audio添加到playlist中
  Future importAudios(List<AudioModel> audioModels) async {
    for (AudioModel audio in audioModels) {
      //将需要导入的数据写入到数据库中
      audio.playlistIds ??= [];
      if (!audio.playlistIds!.contains(playlistId)) {
        audio.playlistIds?.add(playlistId!);
      }
      //insert audio to db
      await DbManager.instance.audioModelDao.insert(audio);
      if (!TextUtil.isEmpty(audio.songNum)) {
        if (!songIds!.contains(audio.songNum)) {
          songIds!.add(audio.songNum!);
        }
      }
      if (TextUtil.isEmpty(cover)) {
        if (audio.isLocal) {
          cover = audio.audioUrl;
          songNum = audio.songNum.toString();
          source = audio.source;
        } else {
          cover = (TextUtil.isEmpty(audio.songAlbumImage) ? audio.songSingerImage : audio.songAlbumImage);
        }
      }
    }
    count = songIds!.length;
    //update playlist
    DbManager.instance.playlistModelDao.update(this);
  }
}
