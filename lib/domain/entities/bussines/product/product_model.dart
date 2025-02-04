import 'package:api_control_flow/domain/entities/bussines/product/product_interface.dart';

class ProductModel implements ProductInterface{
  @override
  final int? id;
  @override
  final String name;
  @override
  final double unit_price;
  @override
  final double unit_cost;
  @override
  final int stock;
  @override
  final double weight;
  @override
  final int id_measure;
  @override
  final int id_category;

  ProductModel({
    required this.id,
    required this.name,
    required this.unit_price,
    required this.unit_cost,
    required this.stock,
    required this.weight,
    required this.id_measure,
    required this.id_category
  });

    factory ProductModel.fromJson(Map<String, dynamic> json){
    return ProductModel(
      id: json['id'],
      name: json['name'],
      unit_price: json['unit_price'],
      unit_cost: json['unit_cost'],
      stock: json['stock'],
      weight: json['weight'],
      id_measure: json['id_measure'],
      id_category: json['id_category']
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> map){
    return ProductModel(
      id: map['id'],
      name: map['name'],
      unit_price: map['unit_price'],
      unit_cost: map['unit_cost'],
      stock: map['stock'],
      weight: map['weight'],
      id_measure: map['id_measure'],
      id_category: map['id_category']
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'unit_price': unit_price,
      'unit_cost': unit_cost,
      'stock': stock,
      'id_measure': id_measure,
      'id_category': id_category
    };
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'unit_price': unit_price,
      'unit_cost': unit_cost,
      'stock': stock,
      'id_measure': id_measure,
      'id_category': id_category
    };
  }
}