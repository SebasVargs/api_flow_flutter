import 'package:api_control_flow/domain/entities/bussines/buysDetail/buys_detail_interface.dart';

class BuysDetailModel implements BuysDetailInterface{
  @override
  final int? id;
  @override
  final int amount;
  @override
  final double unit_price;
  @override
  final double sub_total;
  @override
  final int id_buys;
  @override
  final int id_supply;

  BuysDetailModel({
    required this.id,
    required this.amount,
    required this.unit_price,
    required this.sub_total,
    required this.id_buys,
    required this.id_supply
  });

  factory BuysDetailModel.fromJson(Map<String, dynamic> json){
    return BuysDetailModel(
      id: json['id'],
      amount: json['amount'],
      unit_price: json['unit_price'],
      sub_total: json['sub_total'],
      id_buys: json['id_buys'],
      id_supply: json['id_supply']
    );
  }

  factory BuysDetailModel.fromMap(Map<String, dynamic> map){
    return BuysDetailModel(
      id: map['id'],
      amount: map['amount'],
      unit_price: map['unit_price'],
      sub_total: map['sub_total'],
      id_buys: map['id_buys'],
      id_supply: map['id_supply']
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      'amount': amount,
      'unit_price': unit_price,
      'sub_total': sub_total,
      'id_buys': id_buys,
      'id_supply': id_supply
    };
  }

  @override
  Map<String, dynamic> toMap(){
        return {
      'amount': amount,
      'unit_price': unit_price,
      'sub_total': sub_total,
      'id_buys': id_buys,
      'id_supply': id_supply
    };
  }
}