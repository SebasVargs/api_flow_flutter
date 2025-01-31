abstract class MeasureInterface {
  int? get id;
  String get name;

  Map<String, dynamic> toJson();
  Map<String, dynamic> toMap();
}