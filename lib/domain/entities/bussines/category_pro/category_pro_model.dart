import 'package:api_control_flow/domain/entities/bussines/category_pro/category_pro_interface.dart';

class CategoryProModel implements CategoryProInterface {
  @override
  final int? id;
  @override
  final String name;

  CategoryProModel({
    required this.id,
    required this.name,
  });

  factory CategoryProModel.fromJson(Map<String, dynamic> json) {
    return CategoryProModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory CategoryProModel.fromMap(Map<String, dynamic> map) {
    return CategoryProModel(
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
