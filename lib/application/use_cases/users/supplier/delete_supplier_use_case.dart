import 'package:api_control_flow/domain/repositories/users/supplier_repository.dart';

class DeleteSupplierUseCase {
  final SupplierRepository supplierRepository;

  DeleteSupplierUseCase(this.supplierRepository);

  Future<int> execute(int id){
    return supplierRepository.deleteSupplier(id);
  }
}