import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_core/core.dart';
import 'package:uuid/uuid.dart';

class InfinityCore {
  static const MethodChannel _channel = const MethodChannel('infinity_core');
  static const String _DEVICE_ID = "DEVICE_ID";
  static String? _deviceId = null;
  static Uuid _uuid = Uuid();

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> getDeviceId() async {
    //从临时变量取deviceId
    if (!TextUtil.isEmpty(_deviceId)) {
      return _deviceId;
    }
    //从本地文件取deviceId
    _deviceId = SpUtil.getString(_DEVICE_ID);
    if (!TextUtil.isEmpty(_deviceId)) {
      return _deviceId;
    }
    //从各个系统平台获取deviceId,
    if (Platform.isIOS) {
      _deviceId = await _channel.invokeMethod('getDeviceId');
    }
    //如果还是为空，就随机生成一个，进行保存起来
    if (TextUtil.isEmpty(_deviceId)) {
      _deviceId = await _uuid.v1();
    }
    SpUtil.putString(_DEVICE_ID, _deviceId!);
    return _deviceId;
  }

  //don't finish the app,just go to the home
  static Future<bool> backToDesktop() async {
    //通知安卓返回到手机桌面
    try {
      if (Platform.isAndroid) {
        Object? result = await _channel.invokeMethod<bool>('backDesktop');
        return result != null && result is bool && result;
      }
    } on PlatformException catch (e) {
      debugPrint("通信失败，设置回退到安卓手机桌面失败");
      print(e.toString());
    }
    return Future.value(false);
  }
}
