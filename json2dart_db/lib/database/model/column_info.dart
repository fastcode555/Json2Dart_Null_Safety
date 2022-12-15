import 'dart:convert';

import 'package:json2dart_safe/json2dart.dart';

class ColumnInfo {
  int? notnull;
  String? name;
  int? pk;
  String? type;
  int? cid;

  ColumnInfo({
    this.notnull,
    this.name,
    this.pk,
    this.type,
    this.cid,
  });

  Map<String, dynamic> toJson() => {
        'notnull': notnull,
        'name': name,
        'pk': pk,
        'type': type,
        'cid': cid,
      };

  ColumnInfo.fromJson(Map json) {
    notnull = json.asInt('notnull');
    name = json.asString('name');
    pk = json.asInt('pk');
    type = json.asString('type');
    cid = json.asInt('cid');
  }

  static ColumnInfo toBean(Map json) => ColumnInfo.fromJson(json);

  @override
  String toString() => jsonEncode(toJson());
}
