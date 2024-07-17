import 'package:flutter/material.dart';

/// Barry
/// @date 2024/7/16
/// describe:

List<String> _keyWords = [
  "CREATE",
  "TABLE",
  "INTEGER",
  "TEXT",
  "BOOLEAN",
  "PRIMARY",
  "KEY",
  "AUTOINCREMENT",
  "KEY\n",
  "AUTOINCREMENT\n"
];

List<TextSpan> parseSql(String sql) {
  List<TextSpan> spans = [];
  List<String> splits = sql.split(" ");

  TextSpan empty = const TextSpan(text: " ");
  for (String split in splits) {
    if (split.endsWith(",\n")) {
      int index = split.indexOf(",");
      String key = split.substring(0, index);
      String tail = split.substring(index, split.length);
      if (_keyWords.contains(key)) {
        spans.add(TextSpan(text: key, style: TextStyle(color: _getColor(key), fontWeight: FontWeight.bold)));
        spans.add(TextSpan(text: tail, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)));
        spans.add(empty);
      }
      continue;
    }
    if (split.startsWith("`") && split.endsWith("`")) {
      spans.add(
          TextSpan(text: split, style: const TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold)));
      spans.add(empty);
      continue;
    }

    if (_keyWords.contains(split)) {
      spans.add(
          TextSpan(text: split, style: const TextStyle(color: Colors.lightGreenAccent, fontWeight: FontWeight.bold)));
      spans.add(empty);
      continue;
    }
    spans.add(TextSpan(text: split, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));
    spans.add(empty);
  }
  return spans;
}

Color _getColor(String key) {
  switch (key) {
    case "INTEGER":
      return Colors.purpleAccent;
    case "BOOLEAN":
      return Colors.amberAccent;
    case "DOUBLE":
      return Colors.tealAccent;
  }
  return Colors.blueAccent;
}
