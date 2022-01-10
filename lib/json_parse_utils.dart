/// @author Barry
/// @date 2020/9/4
/// describe:
extension MapExt on Map? {
  //单字段解析
  String asString(String key) {
    if (this == null) return '';
    Object? value = this![key];
    if (value == null) return "";
    if (value is String) return value;
    return value.toString();
  }

  //多字段解析
  String asStrings(List<String> keys) {
    if (this == null) return '';
    for (String key in keys) {
      Object? value = this![key];
      if (value == null) continue;
      if (value is String) {
        return value;
      }
    }
    return "";
  }

  double asDouble(String key) {
    if (this == null) return 0.0;
    Object? value = this![key];
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

  double asDoubles(List<String> keys) {
    if (this == null) return 0.0;
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
      }
    }
    return 0.0;
  }

  int asInt(String key) {
    if (this == null) return 0;
    Object? value = this![key];
    if (value == null) return 0;
    if (value is int) return value;
    try {
      int result = int.parse(value.toString());
      return result;
    } catch (e) {
      print(e);
      _print('json parse failed,exception value::\"$key\":$value');
    }
    return 0;
  }

  int asInts(List<String> keys) {
    if (this == null) return 0;
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
      }
    }
    return 0;
  }

  bool asBool(String key) {
    if (this == null) return false;
    Object? value = this![key];
    if (value == null) return false;
    if (value is bool) return value;
    if (value == 'true') return true;
    if (value == 'false') return false;
    _print('json parse failed,exception value::\"$key\":$value');
    return false;
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
    }
    return 0;
  }

/*
  Color asColor(String key) {
    Object? value = this[key];
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
      }
    }
    return Colors.amber;
  }
*/

  List<T>? asList<T>(String key, T Function(Map json)? toBean) {
    if (this == null) return null;
    try {
      if (toBean != null && this![key] != null) {
        return (this![key] as List).map((v) => toBean(v)).toList().cast<T>();
      } else if (this![key] != null) {
        return List<T>.from(this![key]);
      }
    } catch (e) {
      print(e);
      _print('json parse failed,exception value::\"$key\":${this![key]}');
    }
    return null;
  }

  List<T>? asLists<T>(List<String> keys, Function(Map json)? toBean) {
    if (this == null) return null;
    for (String key in keys) {
      try {
        if (this![key] != null) {
          if (toBean != null && this![key] != null) {
            return (this![key] as List).map((v) => toBean(v)).toList().cast<T>();
          } else {
            return List<T>.from(this![key]);
          }
        }
      } catch (e) {
        print(e);
        _print('json parse failed,exception value::\"$key\":${this![key]}');
      }
    }

    return null;
  }

  T? asBeans<T>(List<String> keys, Function(Map json) toBean) {
    if (this == null) return null;
    for (String key in keys) {
      try {
        if (this![key] != null && _isClassBean(this![key])) {
          return toBean(this![key]);
        }
      } catch (e) {
        print(e);
        _print('json parse failed,exception value::\"$key\":${this![key]}');
      }
    }

    return null;
  }

  T? asBean<T>(String key, Function(Map json) toBean) {
    if (this == null) return null;
    try {
      if (this![key] != null && _isClassBean(this![key])) {
        return toBean(this![key]);
      }
    } catch (e) {
      print(e);
      _print('json parse failed,exception value::\"$key\":${this![key]}');
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

  Map put(String key, Object? value) {
    if (value != null && value is String && value.isNotEmpty) {
      this![key] = value;
    } else if (value != null && value is! String) {
      this![key] = value;
    }
    return this!;
  }
}

class Json2Dart {
  static Json2Dart? _instance;

  factory Json2Dart() => _getInstance();

  static Json2Dart get instance => _getInstance();

  static Json2Dart _getInstance() {
    if (_instance == null) {
      _instance = Json2Dart._internal();
    }
    return _instance!;
  }

  Json2Dart._internal() {}

  Function(String)? callBack;

  void addCallback(Function(String) callBack) {
    this.callBack = callBack;
  }
}
