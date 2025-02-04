abstract class ProductInterface {
  int? get id;
  String get name;
  double get unit_price;
  double get unit_cost;
  int get stock;
  double get weight;
  int get id_measure;
  int get id_category;

  Map<String, dynamic> toJson();
  Map<String, dynamic> toMap();
}