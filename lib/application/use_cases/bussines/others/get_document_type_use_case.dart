import 'package:api_control_flow/domain/entities/bussines/documentType/document_type_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/document_type_repository.dart';

class GetDocumentTypeUseCase {
  final DocumentTypeRepository documentTypeRepository;

  GetDocumentTypeUseCase(this.documentTypeRepository);

  Future<List<DocumentTypeModel>> execute(){
    return documentTypeRepository.getDocumentsType();
  }
}