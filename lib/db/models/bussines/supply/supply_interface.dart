abstract class SupplyInterface {
  int? get id;
  String get name;
  int get stock;
  double get weight;
  double get unit_cost;
  int get id_measure;
  
  Map<String, dynamic> toJson();
  Map<String, dynamic> toMap();
}
