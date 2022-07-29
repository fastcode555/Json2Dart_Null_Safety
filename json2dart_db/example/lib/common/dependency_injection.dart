import 'package:gesound/common/config/app_image_config.dart';
import 'package:gesound/common/config/image_loader.dart';
import 'package:gesound/database/db_manager.dart';
import 'package:get/get.dart';

import '../page/controller/database_controller.dart';

class DependencyInjection {
  static Future<void> init() async {
    await DbManager.instance.init();
    ImageLoader.init(AppImageConfig());
    Get.put(DataBaseController());
  }
}
