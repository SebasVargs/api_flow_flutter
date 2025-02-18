import 'package:api_control_flow/domain/entities/bussines/documentType/document_type_model.dart';

abstract class DocumentTypeRepository {
  Future<List<DocumentTypeModel>> getDocumentsType();
}