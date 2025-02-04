import 'package:api_control_flow/domain/entities/users/supplier/supplier_model.dart';
import 'package:api_control_flow/domain/repositories/users/supplier_repository.dart';

class GetSupplierUseCase {
  final SupplierRepository supplierRepository;

  GetSupplierUseCase(this.supplierRepository);

  Future<List<SupplierModel>> execute(){
    return supplierRepository.getSuppliers();
  }
}