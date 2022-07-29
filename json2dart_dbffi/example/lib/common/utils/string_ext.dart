/// @date 18/7/22
/// describe:
const _symbols = [
  "-",
  ",",
  ".",
  "=",
  "'",
  "?",
  "!",
  "！",
  "？",
  "，",
  "。",
  "\\",
  "/",
  "%s",
  "…",
  "+",
  "\$",
  "￥",
  "•",
  "%",
  "’",
  "@",
  "(",
  ")",
  "|",
  "—",
  ";",
  ":",
  "“",
  "”",
  "&",
  "*",
  ">",
  "<",
  "©",
  "™",
  "[",
  "]",
  "«",
  "»",
  "↳",
  "№",
  "·"
];

extension StringExt on String {
  String get clearSymbol {
    String result = this;
    for (var element in _symbols) {
      if (result.contains(element)) {
        result = result.replaceAll(element, "");
      }
    }
    return result.trim();
  }
}
