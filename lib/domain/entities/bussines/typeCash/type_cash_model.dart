import 'package:api_control_flow/domain/entities/bussines/typeCash/type_cash_interface.dart';

class TypeCashModel implements TypeCashInterface{
  @override
  final int? id;
  @override
  final String name;

  TypeCashModel({
    required this.id,
    required this.name
  });

  factory TypeCashModel.fromJson(Map<String, dynamic> json){
    return TypeCashModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory TypeCashModel.fromMap(Map<String, dynamic> map){
    return TypeCashModel(
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