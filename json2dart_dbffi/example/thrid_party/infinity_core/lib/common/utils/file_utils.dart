import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinity_core/core.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<Directory> getAppDirectory() async {
    Directory tempDir;
    //web 居然isMacos为true
    debugPrint(
        'GetPlatform.isIOS=${GetPlatform.isIOS},GetPlatform.isMacOS=${GetPlatform.isMacOS}, GeneralPlatform.isWeb=${GetPlatform.isWeb}');
    if (GetPlatform.isIOS || GetPlatform.isMacOS) {
      tempDir = await getApplicationDocumentsDirectory();
    } else {
      tempDir = (await getExternalStorageDirectory())!;
    }
    String tempPath = tempDir.path + "/";
    Directory file = new Directory(tempPath);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    return file;
  }
}
