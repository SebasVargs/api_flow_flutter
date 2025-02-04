import 'package:api_control_flow/domain/entities/bussines/clientType/client_type_interface.dart';

class ClientTypeModel implements ClientTypeInterface{
  @override
  final int? id_client;
  @override
  final int? id_type;

  ClientTypeModel({
    required this.id_client,
    required this.id_type
  });
}