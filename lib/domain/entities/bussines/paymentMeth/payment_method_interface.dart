abstract class PaymentMethodInterface {
  int? get id;
  String get name;

  Map<String, dynamic> toJson();
  Map<String, dynamic> toMap();
}