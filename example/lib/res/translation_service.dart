import 'package:get/get.dart';

import 'strings.dart';

class TranslationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => localizedSimpleValues;
}
