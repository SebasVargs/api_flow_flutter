import 'package:api_control_flow/db/models/users/client/client_interface.dart';

class ClientModel implements ClientInterface{
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

  ClientModel({required this.id, required this.name, required this.phone, required this.email, required this.address});

  factory ClientModel.fromJson(Map<String, dynamic> json){
    return ClientModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address']
    );
  }

  factory ClientModel.fromMap(Map<String, dynamic> map){
    return ClientModel(
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