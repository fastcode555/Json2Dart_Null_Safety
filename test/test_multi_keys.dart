import 'dart:convert';

import 'package:json2dart_safe/json2dart.dart';

void main() {
  String json = '''{
     "isLike": 1,
      "isFollowed": false,
      "isCache": true,
      "isHandsome": "0",
      "isBeautiful": "1"
  }''';

  Map<String, dynamic> jsons = jsonDecode(json);

  print("定义了两个key，有bool值的key优先返回${jsons.asBools(['isFollowed', 'isLike'])}");
  print("定义了两个key，有bool值的key优先返回${jsons.asBools(['isLike', 'isFollowed'])}");
  print("定义了两个key，有bool值的key优先返回${jsons.asBools(['isLike'])}");
  print("定义了两个key，有bool值的key优先返回${jsons.asBools(['isHandsome', 'isLike'])}");
  print("定义了两个key，有bool值的key优先返回${jsons.asBools(['isHandsome'])}");
  print("定义了两个key，有bool值的key优先返回${jsons.asBools(['isLike'])}");
  print("定义了两个key，有bool值的key优先返回${jsons.asBools(['isCache'])}");
}
