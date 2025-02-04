import 'package:api_control_flow/domain/entities/users/supplier/supplier_model.dart';

abstract class SupplierRepository {
  Future<List<SupplierModel>> getSuppliers();
  Future<int> insertSupplier(SupplierModel supplier);
  Future<int> updateSupplier(SupplierModel supplier);
  Future<int> deleteSupplier(int id);
  Future<SupplierModel?> getSupplierById(int id);
}