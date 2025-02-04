import 'package:api_control_flow/domain/entities/users/supplier/supplier_model.dart';
import 'package:api_control_flow/domain/repositories/users/supplier_repository.dart';

class UpdateSupplierUseCase {
  final SupplierRepository supplierRepository;

  UpdateSupplierUseCase(this.supplierRepository);

  Future<int> execute(SupplierModel supplier){
    return supplierRepository.updateSupplier(supplier);
  }
}