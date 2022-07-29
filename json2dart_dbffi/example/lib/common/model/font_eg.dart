import 'dart:convert';

import 'package:book_reader/common/utils/md5_utils.dart';
import 'package:book_reader/res/index.dart';
import 'package:json2dart_dbffi/json2dart_dbffi.dart';
import 'package:json2dart_safe/json2dart.dart';

class FontEg with BaseDbModel {
  static final List<FontEg> fonts = [
    FontEg("系统字体", ""),
    FontEg("方正仿宋简体", R.squareSimple),
    FontEg("荆南波波黑", R.jingnanBoHei),
    FontEg("摄图摩登小方体", R.modeng),
    FontEg("美呗嘿嘿体", R.meibei),
    FontEg("站酷快乐体", R.zhanku),
    FontEg("仓耳小丸子", R.ball),
    FontEg("雷盖体", R.leigai),
  ];
  String? importPath;
  String? md5Id;
  String? fontFamily;
  String? title;

  FontEg(
    this.title,
    this.fontFamily, {
    this.importPath,
    this.md5Id,
  }) {
    if (!TextUtil.isEmpty(importPath)) {
      md5Id = Md5Util.generateMd5(importPath!);
    } else if (!TextUtil.isEmpty(title)) {
      md5Id = Md5Util.generateMd5(title!);
    }
  }

  FontEg.normal({this.title = "系统字体", this.fontFamily, this.importPath});

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'import_path': importPath,
        'md5_id': md5Id,
        'font_family': fontFamily,
        'title': title,
      };

  FontEg.fromJson(Map json) {
    importPath = json.asString('import_path');
    md5Id = json.asString('md5_id');
    fontFamily = json.asString('font_family');
    title = json.asString('title');
  }

  static FontEg toBean(Map json) => FontEg.fromJson(json);

  @override
  Map<String, dynamic> primaryKeyAndValue() => {"md5_id": md5Id};

  @override
  int get hashCode => md5Id?.hashCode ?? super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is FontEg && md5Id != null) {
      return other.md5Id == md5Id;
    }
    return super == other;
  }

  @override
  String toString() => jsonEncode(toJson());
}
