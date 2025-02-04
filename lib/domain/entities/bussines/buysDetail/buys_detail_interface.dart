abstract class BuysDetailInterface {
  int? get id;
  int get amount;
  double get unit_price;
  double get sub_total;
  int get id_buys;
  int get id_supply;

  Map<String, dynamic> toJson();
  Map<String, dynamic> toMap();
}