/// @date 27/4/22
/// describe:
mixin BaseDbModel {
  /// 模型的key跟value值
  Map<String, dynamic> primaryKeyAndValue();

  /// 模型转换成Json
  Map<String, dynamic> toJson();
}
