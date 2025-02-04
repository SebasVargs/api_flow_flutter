abstract class SaleDetailInterface {
  int? get id;
  int get amount;
  double get unit_price;
  double get sub_total;
  int get id_sale;
  int get id_product;

  Map<String, dynamic> toJson();
  Map<String, dynamic> toMap();
}