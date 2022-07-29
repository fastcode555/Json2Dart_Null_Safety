import 'package:book_reader/res/string_en.dart';
import 'package:book_reader/res/string_zh_hans.dart';
import 'package:book_reader/res/string_zh_hant.dart';
import 'package:get/get.dart';

class TranslationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => const {
        'zh-Hans_CN': languageZhHans,
        'en_US': languageEn,
        'zh-Hant_HK': languageZhHant,
      };
}
