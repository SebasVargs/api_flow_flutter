import 'package:api_control_flow/domain/entities/bussines/city/city_model.dart';

abstract class CityRepository {
  Future<List<CityModel>> getCities();
}