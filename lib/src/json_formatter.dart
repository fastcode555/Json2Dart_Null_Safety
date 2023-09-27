import 'dart:convert';

class JsonFormatter {
  JsonFormatter._();

  //count：当前的层级
  //缩进符号：indentation
  //style：需要进行格式化的样式
  static String format(
    dynamic data, {
    int deep = 0,
    String indentation = "  ",
    String key = "",
  }) {
    try {
      if (data is String) {
        data = jsonDecode(data);
      }
      StringBuffer buffer = StringBuffer();
      //解析List
      if (data is List) {
        buffer.write(_parseList(data));
      } else if (data is Map) {
        //解析map
        buffer.write(_parseMap(data, count: deep, indentation: indentation));
      }
      return buffer.toString();
    } catch (e) {
      print(e);
    }
    return "";
  }

  ///解析Map
  static String _parseMap(
    Map data, {
    int count = 0,
    String indentation = " ",
    String key = "",
  }) {
    String symbolSpace = indentation * count;
    String space = indentation * (count + 1);
    StringBuffer buffer = StringBuffer();
    if (key.isNotEmpty) {
      buffer.write("$symbolSpace\"$key\":{\n");
    } else {
      buffer.write("$symbolSpace{\n");
    }
    List<dynamic> keys = data.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      Object? obj = data[key];
      if (obj == null) {
        buffer.write("$space\"$key\":$obj");
      } else if (obj is String) {
        buffer.write('$space\"$key\":"$obj"');
      } else if (obj is num || obj is bool) {
        buffer.write('$space\"$key\":$obj');
      } else if (obj is Map) {
        buffer.write(_parseMap(obj,
            count: count + 1, indentation: indentation, key: key));
      } else if (obj is List) {
        buffer.write(_parseList(obj,
            deep: count + 1, indentation: indentation, key: key));
      }
      if (i != keys.length - 1) {
        buffer.write(",\n");
      } else {
        buffer.write("\n");
      }
    }
    buffer.write("$symbolSpace}");
    return buffer.toString();
  }

  ///解析列表
  static String _parseList(
    List<dynamic> data, {
    int deep = 0,
    String indentation = " ",
    String key = "",
  }) {
    String symbolSpace = indentation * deep;
    String space = indentation * (deep + 1);
    if (data.isEmpty) {
      if (key.isNotEmpty) {
        return '$symbolSpace\"$key\":[]';
      }
      return "$symbolSpace[]";
    }
    StringBuffer buffer = StringBuffer();
    //解析list
    if (key.isNotEmpty) {
      buffer.write("$symbolSpace\"$key\":[\n");
    } else {
      buffer.write("$symbolSpace[\n");
    }
    for (int i = 0; i < data.length; i++) {
      Object? obj = data[i];
      if (obj == null || obj is num || obj is bool) {
        buffer.write("$space$obj");
      } else if (obj is String) {
        buffer.write('$space"$obj"');
      } else if (obj is Map) {
        buffer.write(_parseMap(obj, count: deep + 1, indentation: indentation));
      } else if (obj is List) {
        buffer.write(_parseList(obj,
            deep: deep + 1, indentation: indentation, key: key));
      }
      if (i != data.length - 1) {
        buffer.write(",\n");
      } else {
        buffer.write("\n");
      }
    }
    buffer.write('$symbolSpace]');
    return buffer.toString();
  }
}
