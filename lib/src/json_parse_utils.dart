import 'dart:convert';

import 'json2dart.dart';

/// @author Barry
/// @date 2020/9/4
/// describe:

extension _ListExt on List {
  bool get is2dArray {
    if (this.isEmpty) return false;
    for (Object obj in this) {
      if (obj is List) {
        return true;
      }
    }
    return false;
  }
}

extension MapExt on Map? {
  ///单字段解析
  String asString(String key, [String? defValue]) {
    if (this == null) return defValue ?? '';
    Object? value = this![key];
    if (value == null) return defValue ?? '';
    if (value is String) return value;
    return value.toString();
  }

  ///多字段解析Strings
  String asStrings(List<String> keys, [String? defValue]) {
    if (this == null) return defValue ?? '';
    List<Object>? _values;
    for (String key in keys) {
      Object? value = this![key];
      if (value == null) continue;
      if (value is String) {
        return value;
      } else {
        _values ??= [];
        _values.add(value);
      }
    }
    if (_values != null && _values.isNotEmpty) {
      return _values[0].toString();
    }
    return defValue ?? "";
  }

  ///解析成double值
  double asDouble(String key, [double? defValue]) {
    if (this == null) return defValue ?? 0.0;
    Object? value = this![key];
    if (value == null) return defValue ?? 0.0;
    if (value is double) return value;
    try {
      double result = double.parse(value.toString());
      return result;
    } catch (e) {
      print(e);
      _print('json parse failed,exception value:\"$key\":$value');
      _printDetail('asDouble', key, this);
    }
    return defValue ?? 0.0;
  }

  ///多字段解析成double值
  double asDoubles(List<String> keys, [double? defValue]) {
    if (this == null) return defValue ?? 0.0;
    for (String key in keys) {
      Object? value = this![key];
      if (value == null) continue;
      if (value is double) return value;
      try {
        double result = double.parse(value.toString());
        return result;
      } catch (e) {
        print(e);
        _print('json parse failed,exception value::\"$key\":$value');
        _printDetail('asDoubles', key, this);
      }
    }
    return defValue ?? 0.0;
  }

  ///解析成int值
  int asInt(String key, [int? defValue]) {
    if (this == null) return defValue ?? 0;
    Object? value = this![key];
    if (value == null) return defValue ?? 0;
    if (value is int) return value;
    try {
      int result = int.parse(value.toString());
      return result;
    } catch (e) {
      print(e);
      _print('json parse failed,exception value::\"$key\":$value');
      _printDetail('asInt', key, this);
    }
    return defValue ?? 0;
  }

  ///解析成ints值
  int asInts(List<String> keys, [int? defValue]) {
    if (this == null) return defValue ?? 0;
    for (String key in keys) {
      Object? value = this![key];
      if (value == null) continue;
      if (value is int) return value;
      try {
        int result = int.parse(value.toString());
        return result;
      } catch (e) {
        print(e);
        _print('json parse failed,exception value::\"$key\":$value');
        _printDetail('asInts', key, this);
      }
    }
    return defValue ?? 0;
  }

  ///解析成bool值
  bool asBool(String key, [bool? defValue]) {
    if (this == null) return defValue ?? false;
    Object? value = this![key];
    if (value == null) return defValue ?? false;
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value == 'true') return true;
    if (value == '0') return false;
    if (value == '1') return true;
    if (value == 'false') return false;
    _print('json parse failed,exception value::\"$key\":$value');
    _printDetail('asBool', key, this);
    return defValue ?? false;
  }

  ///解析成int或者double值
  num asNum(String key) {
    if (this == null) return 0;
    Object? value = this![key];
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value;
    try {
      if (value is String) {
        if (value.contains('.')) {
          return double.parse(value);
        } else {
          return int.parse(value);
        }
      }
    } catch (e) {
      print(e);
      _print('json parse failed,exception value::\"$key\":$value');
      _printDetail('asNum', key, this);
    }
    return 0;
  }

  /* Color asColor(String key) {
    Object? value = this?[key];
    if (value == null) return Colors.amber;
    if (value is String) {
      try {
        String hexColor = value;
        if (hexColor.isEmpty) return Colors.amber;
        hexColor = hexColor.toUpperCase().replaceAll("#", "");
        hexColor = hexColor.replaceAll('0X', '');
        if (hexColor.length == 6) {
          hexColor = "FF" + hexColor;
        }
        return Color(int.parse(hexColor, radix: 16));
      } catch (e) {
        print(e);
        _print('json parse failed,exception value::\"$key\":$value');
        _printDetail('asColor', key, this);
      }
    }
    return Colors.amber;
  }*/

  ///解析成List
  List<T>? asList<T>(String key, [Function(Map json)? toBean]) {
    if (this == null) return null;
    try {
      Object? obj = this![key];
      if (toBean != null && obj != null) {
        if (obj is List) {
          if (obj.isEmpty) return [];
          //二维数组的处理
          if (obj.is2dArray) {
            //ele.map((v) => toBean(v)).toList(),这一步无法cast，所以会变成List<Dynamic>类型，最终见到的格式就是List<List>
            return obj.map((ele) => ele.map((v) => toBean(v)).toList()).toList().cast<T>();
          }
          return obj.map((v) => toBean(v)).toList().cast<T>();
        } else if (obj is String) {
          List _list = jsonDecode(obj);
          return _list.map((v) => toBean(v)).toList().cast<T>();
        }
      } else if (obj != null) {
        if (obj is List) {
          return _listFrom<T>(obj, key);
        } else if (obj is String) {
          return _listFrom<T>(jsonDecode(obj), key);
        }
      }
    } catch (e) {
      print(e);
      _print('json parse failed,exception value::\"$key\":${this![key]}');
      _printDetail('asList', key, this);
    }
    return null;
  }

  ///Two-dimensional array 二维数组解析
  List<List<T>>? asArray2d<T>(String key, [Function(Map json)? toBean]) {
    if (this == null) return null;
    try {
      Object? obj = this![key];
      if (toBean != null && obj != null) {
        if (obj is List) {
          if (obj.isEmpty) return [];
          if (obj.is2dArray) {
            return obj.map((ele) => ele.map((v) => toBean(v)).toList().cast<T>()).toList().cast<List<T>>();
          }
          return [];
        } else if (obj is String) {
          List _list = jsonDecode(obj);
          if (_list.is2dArray) {
            return _list.map((ele) => ele.map((v) => toBean(v)).toList().cast<T>()).toList().cast<List<T>>();
          }
          return [];
        }
      } else if (obj != null) {
        if (obj is List) {
          return _array2dFrom<T>(obj, key);
        } else if (obj is String) {
          return _array2dFrom<T>(jsonDecode(obj), key);
        }
      }
    } catch (e) {
      print(e);
      _print('json parse failed,exception value::\"$key\":${this![key]}');
      _printDetail('asList', key, this);
    }
    return null;
  }

  ///多字段解析成Lists
  List<T>? asLists<T>(List<String> keys, [Function(Map json)? toBean]) {
    if (this == null) return null;
    for (String key in keys) {
      try {
        Object? obj = this![key];
        if (obj != null) {
          if (toBean != null) {
            if (obj is List) {
              if (obj.isEmpty) return [];
              //二维数组的处理
              if (obj.is2dArray) {
                //ele.map((v) => toBean(v)).toList(),这一步无法cast，所以会变成List<Dynamic>类型，最终见到的格式就是List<List>
                return obj.map((ele) => ele.map((v) => toBean(v)).toList()).toList().cast<T>();
              }
              return obj.map((v) => toBean(v)).toList().cast<T>();
            } else if (obj is String) {
              List _list = jsonDecode(obj);
              return _list.map((v) => toBean(v)).toList().cast<T>();
            }
          } else {
            if (obj is List) {
              return _listFrom<T>(obj, key);
            } else if (obj is String) {
              return _listFrom<T>(jsonDecode(obj), key);
            }
          }
        }
      } catch (e) {
        print(e);
        _print('json parse failed,exception value::\"$key\":${this![key]}');
        _printDetail('asLists', key, this);
      }
    }

    return null;
  }

  ///多字段解析成model
  T? asBeans<T>(List<String> keys, Function(Map json) toBean) {
    if (this == null) return null;
    for (String key in keys) {
      try {
        Object? obj = this![key];
        if (obj != null && _isClassBean(obj)) {
          return toBean(this![key]);
        } else if (obj != null && obj is String) {
          Map _map = jsonDecode(obj);
          return toBean(_map);
        }
      } catch (e) {
        print(e);
        _print('json parse failed,exception value::\"$key\":${this![key]}');
        _printDetail('asBeans', key, this);
      }
    }

    return null;
  }

  ///解析成 model
  T? asBean<T>(String key, Function(Map json) toBean) {
    if (this == null) return null;
    try {
      Object? obj = this![key];
      if (obj != null && _isClassBean(obj)) {
        return toBean(this![key]);
      } else if (obj != null && obj is String) {
        Map _map = jsonDecode(obj);
        return toBean(_map);
      }
    } catch (e) {
      print(e);
      _print('json parse failed,exception value::\"$key\":${this![key]}');
      _printDetail('asBean', key, this);
    }
    return null;
  }

  ///key and value的功能
  Map put(String key, Object? value) {
    if (value != null && value is String && value.isNotEmpty) {
      this![key] = value;
    } else if (value != null && value is! String) {
      this![key] = value;
    }
    return this!;
  }

  ///移除掉空的
  void removeNull() {
    if (this == null || this!.isEmpty) return;
    var keys = List.from(this!.keys);
    for (Object key in keys) {
      if (this![key] == null) this?.remove(key);
    }
    keys.clear();
  }

  ///移除null值或空值
  void removeNullOrEmpty() {
    if (this == null || this!.isEmpty) return;
    var keys = List.from(this!.keys);
    for (Object key in keys) {
      Object? obj = this![key];
      if (obj == null) this?.remove(key);
      if (obj is String && obj.trim().isEmpty) {
        this?.remove(key);
      }
    }
    keys.clear();
  }
}

bool _isClassBean(Object obj) {
  bool isClassBean = true;
  if (obj is String || obj is num || obj is bool) {
    isClassBean = false;
  } else if (obj is Map && obj.isEmpty) {
    isClassBean = false;
  }
  return isClassBean;
}

void _print(String msg) {
  print(msg);
  Json2Dart.instance.callBack?.call(msg);
}

void _printDetail(String method, String key, Map? map) {
  Json2Dart.instance.detailCallBack?.call(method, key, map);
}

int _secureInt(dynamic value, [String? key]) {
  if (value is int) return value;
  if (value == null) return 0;
  if (value is double) return value.toInt();
  if (value is String) {
    try {
      if (value.contains(".")) {
        return double.parse(value).toInt();
      }
      return int.parse(value);
    } catch (e) {
      print(e);
      _print('json parse failed,exception value:\"$key\":$value');
    }
  }
  return 0;
}

num _secureNum(dynamic value, [String? key]) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value;
  try {
    if (value is String) {
      if (value.contains('.')) {
        return double.parse(value);
      } else {
        return int.parse(value);
      }
    }
  } catch (e) {
    print(e);
    _print('json parse failed,exception value::\"$key\":$value');
  }
  return 0;
}

double _secureDouble(dynamic value, [String? key]) {
  if (value == null) return 0.0;
  if (value is double) return value;
  try {
    double result = double.parse(value.toString());
    return result;
  } catch (e) {
    print(e);
    _print('json parse failed,exception value:\"$key\":$value');
  }
  return 0.0;
}

String _secureString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  return value.toString();
}

bool _secureBool(dynamic value, [String? key]) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is num) return value == 1;
  if (value == 'true') return true;
  if (value == '0') return false;
  if (value == '1') return true;
  if (value == 'false') return false;
  _print('json parse failed,exception value::\"$key\":$value');
  return false;
}

List<T> _listFrom<T>(List<dynamic> obj, [String? key]) {
  String type = "$T";
  obj = obj.where((value) => value != null).toList();
  if (type == "int") {
    List<int> results = [];
    for (int i = 0; i < obj.length; i++) {
      results.add(_secureInt(obj[i], key));
    }
    return results.cast<T>();
  } else if (type == "num") {
    List<num> results = [];
    for (int i = 0; i < obj.length; i++) {
      results.add(_secureNum(obj[i], key));
    }
    return results.cast<T>();
  } else if (type == "double") {
    List<double> results = [];
    for (int i = 0; i < obj.length; i++) {
      results.add(_secureDouble(obj[i], key));
    }
    return results.cast<T>();
  } else if (type == "String") {
    List<String> results = [];
    for (int i = 0; i < obj.length; i++) {
      results.add(_secureString(obj[i]));
    }
    return results.cast<T>();
  } else if (type == "bool") {
    List<bool> results = [];
    for (int i = 0; i < obj.length; i++) {
      results.add(_secureBool(obj[i], key));
    }
    return results.cast<T>();
  }
  // print("类型：$T");
  return List<T>.from(obj);
}

///二维数组普通类型解析
List<List<T>> _array2dFrom<T>(List<dynamic> obj, [String? key]) {
  if (obj.is2dArray) {
    return obj
        .where((element) => element != null)
        .map((e) => _listFrom(e, key).toList().cast<T>())
        .toList()
        .cast<List<T>>();
  }
  return [];
}
