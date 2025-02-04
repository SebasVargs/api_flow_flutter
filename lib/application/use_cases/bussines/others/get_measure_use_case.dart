import 'package:api_control_flow/domain/entities/bussines/measure/measure_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/measure_repository.dart';

class GetMeasureUseCase {
  final MeasureRepository measureRepository;

  GetMeasureUseCase(this.measureRepository);

  Future<List<MeasureModel>> execute(){
    return measureRepository.getMeasures();
  }
}