import 'package:book_reader/database/db_manager.dart';

class DependencyInjection {
  static Future<void> init() async {
    await DbManager.instance.init();
  }
}
