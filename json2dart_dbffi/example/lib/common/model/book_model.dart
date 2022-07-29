import 'dart:convert';

import 'package:book_reader/common/model/chapter.dart';
import 'package:json2dart_dbffi/json2dart_dbffi.dart';
import 'package:json2dart_safe/json2dart.dart';

class BookModel with BaseDbModel {
  String? cover;
  String? path;
  List<Chapter>? chapter;
  int? wordCount;
  String? md5Id;
  String? author;
  String? description;
  String? title;
  int? chapterCount;
  int? lastIndex;
  double? lastOffset;

  BookModel({
    this.cover,
    this.path,
    this.chapter,
    this.wordCount,
    this.md5Id,
    this.author,
    this.description,
    this.title,
    this.chapterCount,
    this.lastIndex,
    this.lastOffset,
  });

  @override
  int get hashCode => md5Id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is BookModel) {
      return other.md5Id == md5Id;
    }
    return super == other;
  }

  @override
  Map<String, dynamic> toJson() => {
        'cover': cover,
        'path': path,
        'wordCount': wordCount,
        'chapter': chapter?.map((v) => v.toJson()).toList(),
        'md5_id': md5Id,
        'author': author,
        'description': description,
        'title': title,
        'chapter_count': chapterCount,
        'last_index': lastIndex,
        'last_offset': lastOffset,
      };

  BookModel.fromJson(Map json) {
    cover = json.asString('cover');
    path = json.asString('path');
    chapter = json.asList<Chapter>('chapter', (v) => Chapter.fromJson(v));
    wordCount = json.asInt('wordCount');
    md5Id = json.asString('md5_id');
    author = json.asString('author');
    description = json.asString('description');
    title = json.asString('title');
    chapterCount = json.asInt('chapter_count');
    lastIndex = json.asInt('last_index');
    lastOffset = json.asDouble('last_offset');
  }

  static BookModel toBean(Map json) => BookModel.fromJson(json);

  @override
  Map<String, dynamic> primaryKeyAndValue() => {"md5_id": md5Id};

  @override
  String toString() => jsonEncode(toJson());
}
