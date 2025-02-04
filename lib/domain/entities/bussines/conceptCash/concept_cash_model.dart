import 'package:api_control_flow/domain/entities/bussines/conceptCash/concept_cash_interface.dart';

class ConceptCashModel implements ConceptCashInterface{
  @override
  final int? id;
  @override
  final String name;

  ConceptCashModel({
    required this.id,
    required this.name
  });

  factory ConceptCashModel.fromJson(Map<String, dynamic> json){
    return ConceptCashModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory ConceptCashModel.fromMap(Map<String, dynamic> map){
    return ConceptCashModel(
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