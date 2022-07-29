import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

///获取controller的 baseView, 这里要在路由里声明 controller
abstract class BaseView<T> extends GetView<T> {
  const BaseView({Key? key}) : super(key: key);

  @override
  StatelessElement createElement() {
    onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onReady();
    });
    return super.createElement();
  }

  ///ui build之前，可以设置数据
  void onInit() {}

  ///初始化数据
  void onReady() {}
}
