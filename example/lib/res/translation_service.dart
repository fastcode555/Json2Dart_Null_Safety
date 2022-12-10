import 'package:get/get.dart';

import 'string_en.dart';
import 'string_zh_hans.dart';
import 'string_zh_hant.dart';

class TranslationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh-Hans_CN': languageZhHans,
        'en_US': languageEn,
        'zh-Hant_HK': languageZhHant,
      };
}
