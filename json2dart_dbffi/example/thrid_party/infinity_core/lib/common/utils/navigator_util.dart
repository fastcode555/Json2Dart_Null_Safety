import 'package:get/get.dart';
import 'package:infinity_core/core.dart';

class NavigatorUtil {
  ///跳转页面
  static Future<T?>? pushName<T>(String routeName, {dynamic arguments}) {
    return Get.toNamed<T>(routeName, arguments: arguments);
  }

  ///把当前页面替换为新的页面
  static Future<T?>? pushReplacementNamed<T>(String routeName, {dynamic arguments}) {
    return Get.offNamed<T>(routeName, arguments: arguments);
  }

  ///返回
  static void pop<T>({T? result}) {
    return Get.back(result: result);
  }
}
