import 'package:api_control_flow/domain/entities/bussines/department/department_interface.dart';

class DepartmentModel implements DepartmentInterface {

  @override
  final int? id;
  @override
  final String name;

  DepartmentModel({
    this.id,
    required this.name
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json){
    return DepartmentModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory DepartmentModel.fromMap(Map<String, dynamic> map){
    return DepartmentModel(
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