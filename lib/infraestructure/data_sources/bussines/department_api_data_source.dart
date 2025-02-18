import 'package:api_control_flow/domain/entities/bussines/department/department_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/department_repository.dart';
import 'package:sqflite/sqflite.dart';

class DepartmentApiDataSource implements DepartmentRepository{
  final Database db;

  DepartmentApiDataSource({required this.db});

  @override
  Future<List<DepartmentModel>> getDepartments() async {
    final List<Map<String, dynamic>> maps = await db.query('department');
    return List.generate(maps.length, (i) {
      return DepartmentModel.fromMap(maps[i]);
    });
  }
}