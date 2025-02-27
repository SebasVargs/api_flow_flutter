import 'package:api_control_flow/domain/entities/bussines/buys/buys_interface.dart';

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
  final int id_status_bill;
  @override
  final int? id_client;


  BuysModel({
    required this.id,
    required this.date_buy,
    required this.total,
    this.id_supplier,
    required this.id_status_bill,
    this.id_client
  });

  factory BuysModel.fromJson(Map<String, dynamic> json){
    return BuysModel(
      id: json['id'],
      date_buy: DateTime.parse(json['date_buy']),
      total: (json['total'] as num).toDouble(),
      id_supplier: json['id_supplier'],
      id_status_bill: json['id_status_bill'],
      id_client: json['id_client']
    );
  }

  factory BuysModel.fromMap(Map<String, dynamic> map){
    return BuysModel(
      id: map['id'],
      date_buy: DateTime.parse(map['date_buy']),
      total: (map['total'] as num).toDouble(),
      id_supplier: map['id_supplier'],
      id_status_bill: map['id_status_bill'],
      id_client: map['id_client']
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      'date_buy': date_buy.toIso8601String(),
      'total': total,
      'id_supplier': id_supplier,
      'id_status_bill': id_status_bill,
      'id_client': id_client
    };
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'date_buy': date_buy.toIso8601String(),
      'total': total,
      'id_supplier': id_supplier,
      'id_status_bill': id_status_bill,
      'id_client': id_client
    };
  }
}