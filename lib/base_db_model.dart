/// @date 27/4/22
/// describe:
abstract class BaseDbModel {
  Map<String, dynamic> primaryKeyAndValue();

  Map<String, dynamic> toJson();
}
