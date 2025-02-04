import 'package:api_control_flow/domain/entities/users/supplier/supplier_interface.dart';

class SupplierModel implements SupplierInterface{
  @override
  final int? id;
  @override
  final String name;
  @override
  final String phone;
  @override
  final String email;
  @override
  final String address;

  SupplierModel({required this.id, required this.name, required this.phone, required this.email, required this.address});

  factory SupplierModel.fromJson(Map<String, dynamic> json){
    return SupplierModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address']
    );
  }

  factory SupplierModel.fromMap(Map<String, dynamic> map){
    return SupplierModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      address: map['address']
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address
    };
  }

  @override
  Map<String, dynamic> toMap(){
        return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address
    };
  }
}