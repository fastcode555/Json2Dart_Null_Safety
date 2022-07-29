import 'package:flutter/cupertino.dart';
import 'package:infinity_core/core.dart';
import 'package:infinity_core/model/language_model.dart';

///设置语言工具
class LanguageUtil {
  //支持的多语言
  static List<LanguageModel> languages = Global.languages;

  static LanguageModel? _selectLanguage;

  static setLocalModel(LanguageModel model) {
    List<LanguageModel> list = languages;
    if (model.isSystem()) {
      _selectLanguage = model;
      LanguageModel _lang = getLocaleFromDevice();
      CoreConfig.lang = _lang.languageCode;
      SpUtil.putObject(CoreConfig.KEY_LANGUAGE, model.toJson());
      Get.updateLocale(_lang.toLocale());
    } else {
      if (list.contains(model)) {
        _selectLanguage = model;
      } else {
        _selectLanguage = list[0];
      }
      CoreConfig.lang = _selectLanguage!.languageCode;
      SpUtil.putObject(CoreConfig.KEY_LANGUAGE, _selectLanguage!.toJson());
      Get.updateLocale(model.toLocale());
    }
  }

  static LanguageModel getCurrentLanguage() {
    if (null == _selectLanguage) {
      _selectLanguage = SpUtil.getObj(CoreConfig.KEY_LANGUAGE, (Map v) => LanguageModel.fromJson(v));
      if (null == _selectLanguage) {
        for (LanguageModel lang in languages) {
          if (lang.isSystem()) {
            _selectLanguage = lang;
            return _selectLanguage!;
          }
        }
        _selectLanguage = languages[0];
      }
    }
    return _selectLanguage!;
  }

  static LanguageModel initLanguage() {
    LanguageModel? selectLanguage = SpUtil.getObj(CoreConfig.KEY_LANGUAGE, (Map v) => LanguageModel.fromJson(v));

    //有跟随系统的功能
    if (selectLanguage == null || selectLanguage.isSystem()) {
      for (LanguageModel lang in languages) {
        if (lang.isSystem()) {
          selectLanguage = lang;
          //setLocalModel(lang);
          CoreConfig.lang = selectLanguage.languageCode;
          return selectLanguage;
        }
      }
    }

    //首次设置，使用系统的，没有再默认英文
    if (selectLanguage == null) {
      LanguageModel _lang = getLocaleFromDevice();
      setLocalModel(_lang);
      return _lang;
    } else {
      CoreConfig.lang = selectLanguage.languageCode;
    }
    return selectLanguage;
  }

  static LanguageModel getLocaleFromDevice() {
    Locale? deviceLocale = Get.deviceLocale;
    List<LanguageModel> list = languages;
    if (null == deviceLocale) {
      return list[0];
    }
    for (var element in list) {
      String scriptCode = TextUtil.isEmpty(deviceLocale.scriptCode) ? "" : "-${deviceLocale.scriptCode}";
      String languageCode = "${deviceLocale.languageCode}$scriptCode";
      //zh-tw 台湾繁体中文
      // zh-hk 香港繁体中文
      // zh-sg 新加坡繁体中文
      // zh-mo 澳门繁体中文
      if (deviceLocale.toString().contains("zh_") &&
          deviceLocale.toString() != "zh_CN" &&
          !deviceLocale.toString().contains("zh_Hans")) {
        if (element.languageCode == "zh-Hant") {
          return element;
        }
      } else if (languageCode == element.languageCode || element.languageCode.contains(languageCode)) {
        return element;
      }
    }
    return list[0];
  }

  static Locale? mergeLocale(Locale? locale) {
    if (locale == null) {
      return null;
    }
    String code = locale.languageCode;
    debugPrint("设置多语言=$code");
    return Locale(code, locale.countryCode);
  }
}
