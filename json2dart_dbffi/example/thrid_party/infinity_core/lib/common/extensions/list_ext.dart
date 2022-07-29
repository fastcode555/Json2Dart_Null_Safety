import 'package:flutter/cupertino.dart';

/// @date 27/7/21
/// describe:
extension ListExt<T> on List<T> {
  List<Widget> mapWidget(Widget Function(int index, T t) builder) {
    List<Widget> _widgets = [];
    for (int i = 0; i < this.length; i++) {
      T t = this[i];
      Widget widget = builder(i, t);
      _widgets.add(widget);
    }
    return _widgets;
  }
}
