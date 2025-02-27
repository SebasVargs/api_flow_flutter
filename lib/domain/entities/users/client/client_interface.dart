abstract class ClientInterface {
  int? get id;
  String get company_name;
  String get document_number;
  String get phone;
  String get email;
  String get address;
  int get id_document_type;
  int get id_city;
  int get id_department;
  
  Map<String, dynamic> toJson();
  Map<String, dynamic> toMap();
}
