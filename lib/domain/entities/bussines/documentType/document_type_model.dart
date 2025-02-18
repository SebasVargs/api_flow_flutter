import 'package:api_control_flow/domain/entities/bussines/documentType/document_type_interface.dart';

class DocumentTypeModel implements DocumentTypeInterface{

  @override
  final int? id;
  @override
  final String name;

  DocumentTypeModel({
    this.id,
    required this.name
  });

  factory DocumentTypeModel.fromJson(Map<String, dynamic> json){
    return DocumentTypeModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory DocumentTypeModel.fromMap(Map<String, dynamic> map){
    return DocumentTypeModel(
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