import 'package:api_control_flow/domain/entities/bussines/measure/measure_model.dart';

abstract class MeasureRepository {
  Future<List<MeasureModel>> getMeasures();
}