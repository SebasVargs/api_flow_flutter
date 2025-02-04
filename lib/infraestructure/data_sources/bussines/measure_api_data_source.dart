import 'package:api_control_flow/domain/entities/bussines/measure/measure_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/measure_repository.dart';
import 'package:sqflite/sqflite.dart';

class MeasureApiDataSource implements MeasureRepository{
  final Database db; // Recibe la instancia de la base de datos

  MeasureApiDataSource({required this.db});

  @override
  Future<List<MeasureModel>> getMeasures() async {
    final List<Map<String, dynamic>> maps = await db.query('measure');
    return List.generate(maps.length, (i) {
      return MeasureModel.fromMap(maps[i]);
    });
  }
}