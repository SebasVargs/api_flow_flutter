import 'package:api_control_flow/domain/entities/bussines/supply/supply_interface.dart';

class SupplyModel implements SupplyInterface{
  @override
  final int? id;
  @override
  final String name;
  @override
  final int stock;
  @override
  final double weight;
  @override
  final double unit_cost;
  @override
  final int id_measure;


  SupplyModel({
    required this.id,
    required this.name,
    required this.stock,
    required this.weight,
    required this.unit_cost,
    required this.id_measure,
  });

  factory SupplyModel.fromJson(Map<String, dynamic> json){
    return SupplyModel(
      id: json['id'],
      name: json['name'],
      stock: json['stock'],
      weight: json['weight'],
      unit_cost: json['unit_cost'],
      id_measure: json['id_measuse'],
    );
  }

  factory SupplyModel.fromMap(Map<String, dynamic> map){
    return SupplyModel(
      id: map['id'],
      name: map['name'],
      stock: map['stock'],
      weight: map['weight'],
      unit_cost: map['unit_cost'],
      id_measure: map['id_measure'],
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'stock': stock,
      'weight': weight,
      'unit_cost': unit_cost,
      'id_measure': id_measure,
    };
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'stock': stock,
      'weight': weight,
      'unit_cost': unit_cost,
      'id_measure': id_measure,
    };
  }
}