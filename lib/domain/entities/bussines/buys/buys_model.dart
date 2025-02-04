import 'package:api_control_flow/domain/entities/bussines/buys/buys_interface.dart';

class BuysModel implements BuysInterface{
  @override
  final int? id;
  @override
  final DateTime date_buy;
  @override
  final double total;
  @override
  final int id_supplier;
  @override
  final int id_status;

  BuysModel({
    required this.id,
    required this.date_buy,
    required this.total,
    required this.id_supplier,
    required this.id_status
  });

  factory BuysModel.fromJson(Map<String, dynamic> json){
    return BuysModel(
      id: json['id'],
      date_buy: json['date_buy'],
      total: json['total'],
      id_supplier: json['id_supplier'],
      id_status: json['id_status']
    );
  }

  factory BuysModel.fromMap(Map<String, dynamic> map){
        return BuysModel(
      id: map['id'],
      date_buy: map['date_buy'],
      total: map['total'],
      id_supplier: map['id_supplier'],
      id_status: map['id_status']
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      'date_buy': date_buy,
      'total': total,
      'id_supplier': id_supplier,
      'id_status': id_status
    };
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'date_buy': date_buy,
      'total': total,
      'id_supplier': id_supplier,
      'id_status': id_status
    };
  }
}