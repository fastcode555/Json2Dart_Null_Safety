import 'dart:convert';

import 'package:json2dart_safe/json_formatter.dart';

/// @author Barry
/// @date 2020/9/4
/// describe:
extension StringExtendsion on String? {
  String formatJson() {
    if (this == null || this!.isEmpty) return '';
    dynamic obj = jsonDecode(this!);
    return JsonFormatter.decode(obj);
  }
}

extension MapExt on Map? {
  //单字段解析
  String asString(String key, [String? defValue]) {
    if (this == null) return defValue ?? '';
    Object? value = this![key];
    if (value == null) return defValue ?? '';
    if (value is String) return value;
    return value.toString();
  }

  //多字段解析
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

  bool asBool(String key, [bool? defValue]) {
    if (this == null) return defValue ?? false;
    Object? value = this![key];
    if (value == null) return defValue ?? false;
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value == 'true') return true;
    if (value == 'false') return false;
    _print('json parse failed,exception value::\"$key\":$value');
    _printDetail('asBool', key, this);
    return defValue ?? false;
  }

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

  List<T>? asList<T>(String key, [Function(Map json)? toBean]) {
    if (this == null) return null;
    try {
      Object? obj = this![key];
      if (toBean != null && obj != null) {
        if (obj is List) {
          return obj.map((v) => toBean(v)).toList().cast<T>();
        } else if (obj is String) {
          List _list = jsonDecode(obj);
          return _list.map((v) => toBean(v)).toList().cast<T>();
        }
      } else if (obj != null) {
        if (obj is List) {
          return List<T>.from(obj);
        } else if (obj is String) {
          List _list = jsonDecode(obj);
          return List<T>.from(_list);
        }
      }
    } catch (e) {
      print(e);
      _print('json parse failed,exception value::\"$key\":${this![key]}');
      _printDetail('asList', key, this);
    }
    return null;
  }

  List<T>? asLists<T>(List<String> keys, [Function(Map json)? toBean]) {
    if (this == null) return null;
    for (String key in keys) {
      try {
        Object? obj = this![key];
        if (obj != null) {
          if (toBean != null) {
            if (obj is List) {
              return obj.map((v) => toBean(v)).toList().cast<T>();
            } else if (obj is String) {
              List _list = jsonDecode(obj);
              return _list.map((v) => toBean(v)).toList().cast<T>();
            }
          } else {
            if (obj is List) {
              return List<T>.from(obj);
            } else if (obj is String) {
              List _list = jsonDecode(obj);
              return List<T>.from(_list);
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

  bool _isClassBean(Object obj) {
    bool isClassBean = true;
    if (obj is String || obj is num || obj is bool) {
      isClassBean = false;
    } else if (obj is Map && obj.length == 0) {
      isClassBean = false;
    }
    return isClassBean;
  }

  void _print(String msg) {
    print(msg);
    Json2Dart.instance.callBack?.call(msg);
    //Monitor.instance.put('JsonError', msg);
  }

  void _printDetail(String method, String key, Map? map) {
    Json2Dart.instance.detailCallBack?.call(method, key, map);
  }

  Map put(String key, Object? value) {
    if (value != null && value is String && value.isNotEmpty) {
      this![key] = value;
    } else if (value != null && value is! String) {
      this![key] = value;
    }
    return this!;
  }

  void removeNull() {
    if (this == null || this!.isEmpty) return;
    var keys = List.from(this!.keys);
    for (Object key in keys) {
      if (this![key] == null) this?.remove(key);
    }
    keys.clear();
  }

  void removeNullOrEmpty() {
    if (this == null || this!.isEmpty) return;
    var keys = List.from(this!.keys);
    for (Object key in keys) {
      Object? obj = this![key];
      if (obj == null) this?.remove(key);
      if (obj is String && obj.trim().length == 0) {
        this?.remove(key);
      }
    }
    keys.clear();
  }

  String formatJson({dynamic obj, int deep = 0}) {
    return JsonFormatter.decode(obj, deep: deep);
  }
}

class Json2Dart {
  static Json2Dart? _instance;

  factory Json2Dart() => _getInstance();

  static Json2Dart get instance => _getInstance();

  static Json2Dart _getInstance() => _instance ??= Json2Dart._();

  Json2Dart._();

  Function(String)? callBack;
  Function(String method, String key, Map? map)? detailCallBack;

  void addCallback(Function(String) callBack) {
    this.callBack = callBack;
  }

  void addDetailCallback(Function(String method, String key, Map? map) callBack) {
    this.detailCallBack = callBack;
  }
}
