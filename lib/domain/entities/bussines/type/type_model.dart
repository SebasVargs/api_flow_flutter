import 'package:api_control_flow/domain/entities/bussines/type/type_interface.dart';

class TypeModel implements TypeInterface{
  @override
  final int? id;
  @override
  final String name;

  TypeModel({
    required this.id,
    required this.name
  });

    factory TypeModel.fromJson(Map<String, dynamic> json){
    return TypeModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory TypeModel.fromMap(Map<String, dynamic> map){
    return TypeModel(
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