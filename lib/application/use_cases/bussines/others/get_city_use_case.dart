import 'package:api_control_flow/domain/entities/bussines/city/city_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/city_repository.dart';

class GetCityUseCase {
  final CityRepository cityRepository;

  GetCityUseCase(this.cityRepository);

  Future<List<CityModel>> execute(){
    return cityRepository.getCities();
  }
}