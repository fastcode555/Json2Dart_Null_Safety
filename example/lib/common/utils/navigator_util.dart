import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NavigatorUtil {
  ///跳转页面
  static Future<T?>? pushName<T>(String routeName, {dynamic arguments}) {
    return Get.toNamed<T>(routeName, arguments: arguments);
  }

  ///清除其他的
  static Future<T?>? offAllNamed<T>(String routeName, {dynamic arguments}) {
    return Get.offAllNamed(routeName, arguments: arguments, predicate: (_) => true);
  }

  ///移除目标页面上的所有其它页面
  static void popUntil(String routeName) {
    Navigator.of(Get.context!).popUntil(ModalRoute.withName(routeName));
  }

  ///把当前页面替换为新的页面
  static Future<T?>? pushReplacementNamed<T>(String routeName, {dynamic arguments}) {
    return Get.offNamed<T>(routeName, arguments: arguments);
  }

  ///清除其他的
  static Future<T?>? offAll<T>(String page, {dynamic arguments}) {
    return Get.offAll(page, arguments: arguments);
  }

  ///一直删掉路由栈中的路由，直到遇到untilName，然后再push routeName
  static Future pushNamedAndRemoveUntil(String routeName, String untilName, {Object? arguments}) async {
    debugPrint("client name:" + routeName);
    return Get.offNamedUntil(routeName, ModalRoute.withName(untilName), arguments: arguments);
  }

/*  static Future<T?>? pushTransparentPage<T>(Widget client, {required String pageName}) {
    debugPrint("client name:" + pageName);
    Monitor.instance.putPage(pageName);
    return Get.to(new TransparentRoute(builder: (ctx) => client));
  }*/

  static void until(String untilName, {int? id}) {
    return Get.until(ModalRoute.withName(untilName), id: id);
  }

  static void pushAndRemoveUntil(String pageName) {
    if (pageName.isNotEmpty) {
      offAllNamed(pageName);
    }
  }

  ///跳转页面
  static Future<T?>? pushPage<T>(Widget widget, {dynamic arguments}) {
    return Get.to(widget, arguments: arguments);
  }

  ///返回
  static void pop<T>({T? result}) {
    return Get.back(result: result);
  }

  ///弹出弹窗
  static Future<T?>? showCommonDialog<T>(Widget dialog) {
    return Get.generalDialog(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return dialog;
    });
  }

  ///底部弹窗
  static Future<T?>? bottomSheet<T>(Widget dialog) {
    return Get.bottomSheet(dialog);
  }

  ///退出应用
  static void exitApp() {
    if (GetPlatform.isIOS) {
      exit(0);
    } else {
      SystemNavigator.pop();
    }
  }
}
