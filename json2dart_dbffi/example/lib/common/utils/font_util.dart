import 'dart:collection';
import 'dart:io';

import 'package:book_reader/common/model/font_eg.dart';
import 'package:book_reader/res/index.dart';
import 'package:flutter/services.dart';

class FontUtil {
  static final Map<String, FontEg> _fontMaps = HashMap<String, FontEg>();

  //动态加载字体来显示指定文本
  static Future<bool> loadFontFromFile(FontEg font) async {
    String filePath = font.importPath!;
    String fontFamily = font.fontFamily!;
    if (TextUtil.isEmpty(filePath) || TextUtil.isEmpty(filePath) || _fontMaps.containsKey(font.importPath)) {
      return false;
    }
    File fontFile = File(filePath);
    if (!fontFile.existsSync()) {
      return false;
    }
    //加载本地字体到app中
    Future<void> loadFontToApp(String path) async {
      try {
        var fontLoader = FontLoader(fontFamily);
        Future<ByteData> _byteData = File(path).readAsBytes().then((value) {
          return value.buffer.asByteData();
        });
        _fontMaps[path] = font;
        fontLoader.addFont(_byteData);
        await fontLoader.load();
      } catch (e) {
        print(e);
      }
    }

    loadFontToApp(filePath);
    return true;
  }
}
