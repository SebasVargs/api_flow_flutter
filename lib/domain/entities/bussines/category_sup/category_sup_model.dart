
import 'package:api_control_flow/domain/entities/bussines/category_sup/category_sup_interface.dart';

class CategorySupModel implements CategorySupInterface {
  @override
  final int? id;
  @override
  final String name;

  CategorySupModel({
    required this.id,
    required this.name,
  });

  factory CategorySupModel.fromJson(Map<String, dynamic> json) {
    return CategorySupModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory CategorySupModel.fromMap(Map<String, dynamic> map) {
    return CategorySupModel(
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
