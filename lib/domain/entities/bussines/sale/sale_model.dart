import 'package:api_control_flow/domain/entities/bussines/sale/sale_interface.dart';

class SaleModel implements SaleInterface{
  @override
  final int? id;
  @override
  final DateTime sell_date;
  @override
  final double total;
  @override
  final double discount;
  @override
  final int id_status;
  @override
  final int id_client;

  SaleModel({
    required this.id,
    required this.sell_date,
    required this.total,
    required this.discount,
    required this.id_status,
    required this.id_client
  });

  factory SaleModel.fromJson(Map<String, dynamic> json){
    return SaleModel(
      id: json['id'],
      sell_date: json['sell_date'],
      total: json['total'],
      discount: json['discount'],
      id_status: json['id_status'],
      id_client: json['id_client']
    );
  }

  factory SaleModel.fromMap(Map<String, dynamic> map){
    return SaleModel(
      id: map['id'],
      sell_date: map['sell_date'],
      total: map['total'],
      discount: map['discount'],
      id_status: map['id_status'],
      id_client: map['id_client']
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      'sell_date': sell_date,
      'total': total,
      'discount': discount,
      'id_status': id_status,
      'id_client': id_client
    };
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'sell_date': sell_date,
      'total': total,
      'discount': discount,
      'id_status': id_status,
      'id_client': id_client
    };
  }
}