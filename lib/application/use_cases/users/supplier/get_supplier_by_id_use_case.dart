import 'package:api_control_flow/domain/entities/users/supplier/supplier_model.dart';
import 'package:api_control_flow/domain/repositories/users/supplier_repository.dart';

class GetSupplierByIdUseCase {
  final SupplierRepository supplierRepository;

  GetSupplierByIdUseCase(this.supplierRepository);

  Future<SupplierModel?> execute(int id) {
    return supplierRepository.getSupplierById(id);
  }
}