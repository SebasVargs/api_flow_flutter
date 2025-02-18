import 'package:api_control_flow/domain/entities/bussines/buys/buys_interface.dart';
import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';

class BuysModel implements BuysInterface{
  @override
  final int? id;
  @override
  final DateTime date_buy;
  @override
  final double total;
  @override
  final int? id_supplier;
  @override
  final int id_status;
  @override
  final List<BuysDetailModel> details;

  BuysModel({
    required this.id,
    required this.date_buy,
    required this.total,
    this.id_supplier,
    required this.id_status,
    required this.details
  });

  factory BuysModel.fromJson(Map<String, dynamic> json){
    return BuysModel(
      id: json['id'],
      date_buy: DateTime.parse(json['date_buy']),
      total: (json['total'] as num).toDouble(),
      id_supplier: json['id_supplier'],
      id_status: json['id_status'],
      details: (json['details'] as List)
      .map((item) => BuysDetailModel.fromJson(item))
      .toList(),
    );
  }

  factory BuysModel.fromMap(Map<String, dynamic> map){
    return BuysModel(
      id: map['id'],
      date_buy: DateTime.parse(map['date_buy']),
      total: (map['total'] as num).toDouble(),
      id_supplier: map['id_supplier'],
      id_status: map['id_status'],
      details: (map['details'] as List)
      .map((item) => BuysDetailModel.fromMap(item))
      .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      'date_buy': date_buy.toIso8601String(),
      'total': total,
      'id_supplier': id_supplier,
      'id_status': id_status,
      'details': details.map((d) => d.toJson()).toList()
    };
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'date_buy': date_buy.toIso8601String(),
      'total': total,
      'id_supplier': id_supplier,
      'id_status': id_status,
      'details': details.map((d) => d.toMap()).toList()
    };
  }
}