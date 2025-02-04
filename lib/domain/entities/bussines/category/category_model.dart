import 'package:api_control_flow/domain/entities/bussines/category/category_interface.dart';

class CategoryModel implements CategoryInterface {
  @override
  final int? id;
  @override
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
