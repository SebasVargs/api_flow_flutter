import 'package:api_control_flow/domain/entities/bussines/paymentMeth/payment_method_interface.dart';

class PaymentMethodModel implements PaymentMethodInterface{
  @override
  final int? id;
  @override
  final String name;

  PaymentMethodModel({
    required this.id,
    required this.name
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json){
    return PaymentMethodModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map){
    return PaymentMethodModel(
      id: map['id'],
      name: map['name'],
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      'name': name,
    };
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'name': name,
    };
  }
}