import 'package:api_control_flow/db/models/bussines/measure/measure_interface.dart';

class MeasureModel implements MeasureInterface{
  @override
  final int? id;
  @override
  final String name;


  MeasureModel({
    required this.id,
    required this.name,
  });

  factory MeasureModel.fromJson(Map<String, dynamic> json){
    return MeasureModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory MeasureModel.fromMap(Map<String, dynamic> map){
    return MeasureModel(
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