import 'dart:ui';

import 'package:infinity_core/core.dart';
import 'package:json2dart_safe/json2dart.dart';

class LanguageModel {
  String titleId;
  String languageCode;
  String countryCode;
  bool isSelected;
  String? flag;

  LanguageModel(
    this.titleId,
    this.languageCode,
    this.countryCode, {
    this.isSelected: false,
    this.flag,
  });

  LanguageModel.system(
    this.titleId, {
    this.languageCode = '',
    this.countryCode = '',
    this.isSelected: false,
    this.flag,
  });

  ///如果国家号跟手机号都为空，就视为跟随系统
  bool isSystem() => TextUtil.isEmpty(languageCode) && TextUtil.isEmpty(countryCode);

  LanguageModel.fromJson(Map json)
      : titleId = json.asString('titleId'),
        languageCode = json.asString('languageCode'),
        countryCode = json.asString('countryCode'),
        flag = json.asString('flag'),
        isSelected = json.asBool('isSelected');

  Map<String, dynamic> toJson() => {
        'titleId': titleId,
        'languageCode': languageCode,
        'countryCode': countryCode,
        'flag': flag,
        'isSelected': isSelected,
      };

  Locale toLocale() {
    if (TextUtil.isEmpty(languageCode) && TextUtil.isEmpty(countryCode)) {
      return LanguageUtil.getLocaleFromDevice().toLocale();
    }
    return Locale(languageCode, countryCode);
  }

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"titleId\":\"$titleId\"");
    sb.write(",\"languageCode\":\"$languageCode\"");
    sb.write(",\"countryCode\":\"$countryCode\"");
    sb.write(",\"flag\":\"$flag\"");
    sb.write('}');
    return sb.toString();
  }

  @override
  int get hashCode => titleId.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is LanguageModel) {
      return other.titleId == this.titleId;
    }
    return super == other;
  }
}
