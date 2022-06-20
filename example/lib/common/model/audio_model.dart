import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:json2dart_safe/json2dart.dart';

class Items {
  late List<AudioModel> audios;
}

class AudioModel with BaseDbModel {
  static const String sourceRemote = 'source_remote';
  static const String sourceLocal = 'source_local';
  static const String sourceCloud = 'source_cloud';

  String? lyricsTime;
  String? songSingerName;
  String? songName;
  int? musicVerify;
  int? durationTime;
  List<int>? playlistIds;
  String? updateTime;
  String? videoUrl;
  String? issueDate;
  String? songSingerImage;
  String? songCreatedAt;
  String? languageText;
  String? songAlbumImage;
  int? songAlbumViews;
  int? songSingerViews;
  int? songSinger;
  int? audioUrlSize;
  int? songViews;
  String? songUpdatedAt;
  int? audioUrlSizeTime;
  String? songAlbumName;
  String? lyricContent;
  String? downLoadUrl;
  int? songAlbum;
  String? albumUpdateTime;
  String? audioUrl;
  String? albumLanguage;
  String? source;
  String? format;
  String? songNum;
  bool? isAudioBook;
  String? ext;
  int? indexNo;
  String? localPath;

  String get finalImage => TextUtil.isEmpty(songAlbumImage) ? songSingerImage ?? '' : songAlbumImage ?? '';

  String get finalFormat => (audioUrl?.contains(".m4a") ?? false) ? 'm4a' : "mp3";

  bool get isLocal => AudioModel.sourceLocal == source;

  bool get isRemote => AudioModel.sourceRemote == source || TextUtil.isEmpty(source);

  bool get isCloud => AudioModel.sourceCloud == source;

  AudioModel({
    this.lyricsTime,
    this.musicVerify,
    this.durationTime,
    this.playlistIds,
    this.updateTime,
    this.videoUrl,
    this.issueDate,
    this.songSingerImage,
    this.songCreatedAt,
    this.languageText,
    this.songAlbumImage,
    this.songAlbumViews,
    this.songSingerViews,
    this.songSinger,
    this.audioUrlSize,
    this.songViews,
    this.songUpdatedAt,
    this.audioUrlSizeTime,
    this.lyricContent,
    this.downLoadUrl,
    this.songAlbum,
    this.albumUpdateTime,
    this.albumLanguage,
    this.songNum,
    this.source,
    this.format,
    this.isAudioBook,
    this.ext,
    this.indexNo,
    this.localPath,
    required this.songSingerName,
    required this.audioUrl,
    required this.songAlbumName,
    required this.songName,
    String? genre,
  });

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{}
    ..put('lyrics_time', lyricsTime)
    ..put('song_singer_name', songSingerName)
    ..put('song_name', songName)
    ..put('music_verify', musicVerify)
    ..put('duration', durationTime)
    ..put('playlist_ids', playlistIds)
    ..put('update_time', updateTime)
    ..put('video_url', videoUrl)
    ..put('issue_date', issueDate)
    ..put('song_singer_image', songSingerImage)
    ..put('song_created_at', songCreatedAt)
    ..put('language_text', languageText)
    ..put('song_album_image', songAlbumImage)
    ..put('song_album_views', songAlbumViews)
    ..put('song_singer_views', songSingerViews)
    ..put('song_singer', songSinger)
    ..put('audio_url_size', audioUrlSize)
    ..put('song_views', songViews)
    ..put('song_updated_at', songUpdatedAt)
    ..put('audio_url_size_time', audioUrlSizeTime)
    ..put('song_album_name', songAlbumName)
    ..put('lyric_content', lyricContent)
    ..put('down_load_url', downLoadUrl)
    ..put('song_album', songAlbum)
    ..put('album_update_time', albumUpdateTime)
    ..put('audio_url', audioUrl)
    ..put('album_language', albumLanguage)
    ..put('source', source)
    ..put('format', format)
    ..put('is_audio_book', isAudioBook)
    ..put('ext', ext)
    ..put('index_no', indexNo)
    ..put('local_path', localPath)
    ..put('song_num', songNum);

  factory AudioModel.fromJson(Map json, [String? bookName, String? bookAuthor, String? bookCover]) {
    return AudioModel(
      lyricsTime: json.asString('lyrics_time'),
      songSingerName: bookAuthor ?? json.asString('song_singer_name'),
      songName: json.asStrings(['song_name', 'track_title']),
      musicVerify: json.asInt('music_verify'),
      durationTime: json.asInt('duration'),
      playlistIds: json.asList<int>('playlist_ids'),
      updateTime: json.asString('update_time'),
      videoUrl: json.asString('video_url'),
      issueDate: json.asString('issue_date'),
      songSingerImage: json.asString('song_singer_image'),
      songCreatedAt: json.asString('song_created_at'),
      languageText: json.asString('language_text'),
      songAlbumImage: bookCover ?? json.asString('song_album_image'),
      songAlbumViews: json.asInt('song_album_views'),
      songSingerViews: json.asInt('song_singer_views'),
      songSinger: json.asInt('song_singer'),
      audioUrlSize: json.asInt('audio_url_size'),
      songViews: json.asInt('song_views'),
      songUpdatedAt: json.asString('song_updated_at'),
      audioUrlSizeTime: json.asInt('audio_url_size_time'),
      isAudioBook: !TextUtil.isEmpty(bookName) ? true : json.asBool('is_audio_book'),
      songAlbumName: bookName ?? json.asString('song_album_name'),
      lyricContent: json.asString('lyric_content'),
      downLoadUrl: json.asString('down_load_url'),
      songAlbum: json.asInt('song_album'),
      albumUpdateTime: json.asString('album_update_time'),
      audioUrl: json.asStrings(['audio_url', 'down_load_url']),
      albumLanguage: json.asString('album_language'),
      source: json.asString('source', AudioModel.sourceRemote),
      songNum: json.asStrings(['song_num', 'resource_source_id']),
      format: json.asString('format'),
      ext: json.asString('ext'),
      indexNo: json.asInt('index_no'),
      localPath: json.asString('local_path'),
    );
  }

  static AudioModel toBean(Map json) => AudioModel.fromJson(json);

  @override
  Map<String, dynamic> primaryKeyAndValue() => {"song_num": songNum};

  @override
  int get hashCode => songNum?.hashCode ?? super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is AudioModel && songNum != null) {
      return other.songNum == songNum;
    }
    return super == other;
  }

  @override
  String toString() => jsonEncode(toJson());
}
