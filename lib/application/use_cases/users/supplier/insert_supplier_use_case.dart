import 'package:api_control_flow/domain/entities/users/supplier/supplier_model.dart';
import 'package:api_control_flow/domain/repositories/users/supplier_repository.dart';

class InsertSupplierUseCase {
  final SupplierRepository supplierRepository;

  InsertSupplierUseCase(this.supplierRepository);

  Future<int> execute(SupplierModel supplier){
    return supplierRepository.insertSupplier(supplier);
  }
}