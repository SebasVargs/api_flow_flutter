import 'package:api_control_flow/db/models/bussines/measure/measure_model.dart';
import 'package:sqflite/sqflite.dart';

class MeasureRepository {
  final Database db; // Recibe la instancia de la base de datos

  MeasureRepository({required this.db});

  Future<List<MeasureModel>> obtenerMedidas() async {
    final List<Map<String, dynamic>> maps = await db.query('measure');
    return List.generate(maps.length, (i) {
      return MeasureModel.fromMap(maps[i]);
    });
  }

}