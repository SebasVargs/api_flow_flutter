import 'package:api_control_flow/domain/entities/bussines/department/department_model.dart';

abstract class DepartmentRepository {
  Future<List<DepartmentModel>> getDepartments();
}