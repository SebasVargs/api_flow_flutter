import 'package:api_control_flow/domain/entities/bussines/status/status_interface.dart';

class StatusModel implements StatusInterface{
  @override
  final int? id;
  @override
  final String name;

  StatusModel({
    required this.id,
    required this.name
  });

  factory StatusModel.fromJson(Map<String, dynamic> json){
    return StatusModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory StatusModel.fromMap(Map<String, dynamic> map){
    return StatusModel(
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