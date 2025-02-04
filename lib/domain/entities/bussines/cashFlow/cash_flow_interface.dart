abstract class CashFlowInterface {
  int? get id;
  DateTime get cash_date;
  double get amount;
  String get detail;
  int get id_sale;
  int get id_buys;
  int get id_type_cash;
  int get id_concept_cash;

  Map<String, dynamic> toJson();
  Map<String, dynamic> toMap();
}