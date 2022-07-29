import 'package:book_reader/common/model/reader_theme.dart';
import 'package:book_reader/common/utils/font_util.dart';
import 'package:book_reader/res/index.dart';
import 'package:flutter/cupertino.dart';

const String _readerThemeString = "reader_theme";

class Application {
  Application._internal() {
    _readerTheme = SpUtil.getObj<ReaderTheme>(
      _readerThemeString,
      (v) => ReaderTheme.fromJson(v),
      defValue: ReaderTheme.oldPaper(),
    );
    if (!TextUtil.isEmpty(_readerTheme?.font?.importPath)) {
      FontUtil.loadFontFromFile(_readerTheme!.font!);
    }
  }

  static Application? _instance;

  factory Application() => _getInstance();

  static Application get instance => _getInstance();

  final RouteObserver<ModalRoute<Object?>> routeObserver = RouteObserver<ModalRoute<Object?>>();

  static Application _getInstance() {
    _instance ??= Application._internal();
    return _instance!;
  }

  String? getUid() => "";

  String? getToken() => "";

  void saveUser() {}

  void clear() {}

  ReaderTheme? _readerTheme;

  ReaderTheme get getReaderTheme => _readerTheme!;

  void saveTheme(ReaderTheme readerTheme) {
    SpUtil.putObject(_readerThemeString, readerTheme);
  }
}
