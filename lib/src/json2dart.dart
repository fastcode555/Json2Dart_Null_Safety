class Json2Dart {
  static Json2Dart? _instance;

  factory Json2Dart() => _getInstance();

  static Json2Dart get instance => _getInstance();

  static Json2Dart _getInstance() => _instance ??= Json2Dart._();

  Json2Dart._();

  Function(String)? callBack;
  Function(String method, String key, Map? map)? detailCallBack;

  ///添加报错回调
  void addCallback(Function(String) callBack) {
    this.callBack = callBack;
  }

  ///添加报错回调，详细的解析方式跟map
  void addDetailCallback(Function(String method, String key, Map? map) callBack) {
    this.detailCallBack = callBack;
  }
}
