import 'dart:convert';

import 'package:gesound/common/model/playlist_model.dart';
import 'package:gesound/res/strings.dart';
import 'package:get/get.dart';
import 'package:json2dart_safe/json2dart.dart';

class CategoryModel with BaseDbModel {
  String get finalName => (categoryId == 0 || categoryId == 1) ? name?.tr ?? "" : name ?? '';

  int? playlistCount;
  int? songCount;
  int? createTime;
  String? name;
  int? position;
  int? categoryId;
  List<int>? playlistIds;
  List<PlaylistModel>? playlists;

  CategoryModel({
    this.playlistCount,
    this.createTime,
    this.name,
    this.position,
    this.categoryId,
    this.songCount,
    this.playlistIds,
    this.playlists,
  });

  CategoryModel.music() {
    playlistCount = 0;
    createTime = 0;
    name = Ids.defaultx;
    position = 0;
    categoryId = 0;
    songCount = 0;
    playlistIds;
  }

  CategoryModel.empty({this.name}) {
    playlistCount = 0;
    createTime = 0;
    position = 0;
    songCount = 0;
    playlistIds;
  }

  CategoryModel.novel() {
    playlistCount = 0;
    createTime = 0;
    name = Ids.novel;
    position = 1;
    categoryId = 1;
    songCount = 0;
    playlistIds;
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{}
    ..put('playlist_count', playlistCount)
    ..put('create_time', createTime)
    ..put('name', name)
    ..put('position', position)
    ..put('song_count', songCount)
    ..put('playlist_ids', playlistIds)
    ..put('category_id', categoryId);

  CategoryModel.fromJson(Map json) {
    playlistCount = json.asInt('playlist_count');
    createTime = json.asInt('create_time');
    name = json.asString('name');
    position = json.asInt('position');
    songCount = json.asInt('song_count');
    playlistIds = json.asList<int>('playlist_ids') ?? [];
    categoryId = json.asInt('category_id');
  }

  static CategoryModel toBean(Map json) => CategoryModel.fromJson(json);

  @override
  Map<String, dynamic> primaryKeyAndValue() => {"category_id": categoryId};

  @override
  int get hashCode => categoryId?.hashCode ?? super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is CategoryModel && categoryId != null) {
      return other.categoryId == categoryId;
    }
    return super == other;
  }

  @override
  String toString() => jsonEncode(toJson());
}
