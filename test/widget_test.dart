import 'dart:convert';

import 'package:json2dart_safe/json2dart.dart';

void main() {
  ///测试返回跟实际不同的问题
  Map<String, dynamic> maps = jsonDecode('{"ids":["1","3.23",1,2,2.0,3.43]}');
  print(jsonEncode(maps.asList<int>('ids')));
  print(jsonEncode(maps.asList<String>('ids')));
  print(jsonEncode(maps.asList<bool>('ids')));
  print(jsonEncode(maps.asList<double>('ids')));
  print(jsonEncode(maps.asList<num>('ids')));
}
