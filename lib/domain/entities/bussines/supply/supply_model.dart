import 'package:api_control_flow/domain/entities/bussines/supply/supply_interface.dart';

class BuysDetailModel implements BuysDetailInterface{
  @override
  final int? id;
  @override
  final String description;
  @override
  final int stock;
  @override
  final double? weight;
  @override
  final double? size;
  @override
  final double unit_cost;
  @override
  final int id_measure;
  @override
  int? id_buys;
  @override
  final int id_category_sup;


  BuysDetailModel({
    this.id,
    required this.description,
    required this.stock,
    this.weight,
    this.size,
    required this.unit_cost,
    required this.id_measure,
    this.id_buys,
    required this.id_category_sup
  });

  factory BuysDetailModel.fromJson(Map<String, dynamic> json){
    return BuysDetailModel(
      id: json['id'],
      description: json['description'],
      stock: json['stock'],
      weight: json['weight'],
      size: json['size'],
      unit_cost: json['unit_cost'],
      id_measure: json['id_measuse'],
      id_buys: json['id_buys'],
      id_category_sup: json['id_category_sup']
    );
  }

  factory BuysDetailModel.fromMap(Map<String, dynamic> map){
    return BuysDetailModel(
      id: map['id'],
      description: map['description'],
      stock: map['stock'],
      weight: map['weight'],
      size: map['size'],
      unit_cost: map['unit_cost'],
      id_measure: map['id_measure'],
      id_buys: map['id_buys'],
      id_category_sup: map['id_category_sup']
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      'description': description,
      'stock': stock,
      'weight': weight,
      'size': size,
      'unit_cost': unit_cost,
      'id_measure': id_measure,
      'id_buys': id_buys,
      'id_category_sup': id_category_sup
    };
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'description': description,
      'stock': stock,
      'weight': weight,
      'size': size,
      'unit_cost': unit_cost,
      'id_measure': id_measure,
      'id_buys': id_buys,
      'id_category_sup': id_category_sup
    };
  }
}