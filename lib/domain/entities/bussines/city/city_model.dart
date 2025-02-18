import 'package:api_control_flow/domain/entities/bussines/city/city_interface.dart';

class CityModel implements CityInterface{
  
  @override
  final int? id;
  @override
  final String name;

  CityModel({
    this.id,
    required this.name
  });

  factory CityModel.fromJson(Map<String, dynamic> json){
    return CityModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory CityModel.fromMap(Map<String, dynamic> map){
    return CityModel(
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