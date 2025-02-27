import 'package:api_control_flow/domain/entities/users/client/client_interface.dart';

class ClientModel implements ClientInterface{
  @override
  final int? id;
  @override
  final String company_name;
  @override
  final String document_number;
  @override
  final String phone;
  @override
  final String email;
  @override
  final String address;
  @override
  final int id_document_type;
  @override
  final int id_city;
  @override
  final int id_department;

  ClientModel({
    this.id,
    required this.company_name,
    required this.document_number,
    required this.phone,
    required this.email,
    required this.address,
    required this.id_document_type,
    required this.id_city,
    required this.id_department
  });

  factory ClientModel.fromJson(Map<String, dynamic> json){
    return ClientModel(
      id: json['id'],
      company_name: json['company_name'],
      document_number: json['document_number'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      id_document_type: json['id_document_type'],
      id_city: json['id_city'],
      id_department: json['id_department']
    );
  }

  factory ClientModel.fromMap(Map<String, dynamic> map){
    return ClientModel(
      id: map['id'],
      company_name: map['company_name'],
      document_number: map['document_number'],
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
      id_document_type: map['id_document_type'],
      id_city: map['id_city'],
      id_department: map['id_department']
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      'company_name': company_name,
      'document_number': document_number,
      'phone': phone,
      'email': email,
      'address': address,
      'id_document_type': id_document_type,
      'id_city': id_city,
      'id_department': id_department
    };
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'company_name': company_name,
      'document_number': document_number,
      'phone': phone,
      'email': email,
      'address': address,
      'id_document_type': id_document_type,
      'id_city': id_city,
      'id_department': id_department
    };
  }
}