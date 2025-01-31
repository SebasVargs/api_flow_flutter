import 'package:api_control_flow/models/schedule/hability_interface.dart';

class HabilityModel implements HabilityInterface{

  @override
  final int id;
  @override
  final String name;

  HabilityModel({required this.id, required this.name});

  factory HabilityModel.fromJson(Map<String, dynamic> json){
    return HabilityModel(
      id: json['id'],
      name: json['name']
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'name': name
    };
  }
}