import 'package:api_control_flow/domain/entities/bussines/city/city_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/city_repository.dart';
import 'package:sqflite/sqflite.dart';

class CityApiDataSource implements CityRepository{
  final Database db;

  CityApiDataSource({required this.db});

  @override
  Future<List<CityModel>> getCities() async {
    final List<Map<String, dynamic>> maps = await db.query('city');
    return List.generate(maps.length, (i) {
      return CityModel.fromMap(maps[i]);
    });
  }
}