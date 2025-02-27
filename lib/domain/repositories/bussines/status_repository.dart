import 'package:api_control_flow/domain/entities/bussines/status/status_model.dart';

abstract class StatusRepository {
  Future<List<StatusModel>> getStatues();
  Future<int> insertStatus(StatusModel status);
  Future<int> updateStatus(StatusModel status);
  Future<int> deleteStatus(int id);
}