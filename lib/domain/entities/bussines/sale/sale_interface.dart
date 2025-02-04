abstract class SaleInterface {
  int? get id;
  DateTime get sell_date;
  double get total;
  double get discount;
  int get id_status;
  int get id_client;

  Map<String, dynamic> toJson();
  Map<String, dynamic> toMap();
}