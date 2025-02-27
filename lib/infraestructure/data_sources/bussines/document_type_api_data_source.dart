import 'package:api_control_flow/domain/entities/bussines/documentType/document_type_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/document_type_repository.dart';
import 'package:sqflite/sqflite.dart';

class DocumentTypeApiDataSource implements DocumentTypeRepository {
  final Database db;

  DocumentTypeApiDataSource({required this.db});

  @override
  Future<List<DocumentTypeModel>> getDocumentsType() async {
    final List<Map<String, dynamic>> maps = await db.query('document_type');
    return List.generate(maps.length, (i) {
      return DocumentTypeModel.fromMap(maps[i]);
    });
  }


}
