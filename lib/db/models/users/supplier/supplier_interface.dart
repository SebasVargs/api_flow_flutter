abstract class SupplierInterface {
  int? get id;
  String get name;
  String get phone;
  String get email;
  String get address;
  
  Map<String, dynamic> toJson();
  Map<String, dynamic> toMap();
}
