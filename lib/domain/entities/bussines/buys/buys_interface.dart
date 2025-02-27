abstract class BuysInterface {
  int? get id;
  DateTime get date_buy;
  double get total;
  int? get id_supplier;
  int get id_status_bill;
  int? get id_client;

  Map<String, dynamic> toJson();
  Map<String, dynamic> toMap();
}