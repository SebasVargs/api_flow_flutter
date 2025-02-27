abstract class BuysDetailInterface {
  int? get id;
  String get description;
  int get stock;
  double? get weight;
  double? get size;
  double get unit_cost;
  int get id_measure;
  int? get id_buys;
  int get id_category_sup;
  
  Map<String, dynamic> toJson();
  Map<String, dynamic> toMap();
}
