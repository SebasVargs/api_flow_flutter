import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';

abstract class BuysInterface {
  int? get id;
  DateTime get date_buy;
  double get total;
  int? get id_supplier;
  int get id_status;
  List<BuysDetailModel> get details;

  Map<String, dynamic> toJson();
  Map<String, dynamic> toMap();
}