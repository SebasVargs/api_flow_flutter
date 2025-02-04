import 'package:api_control_flow/domain/entities/bussines/saleDetail/sale_detail_interface.dart';

class SaleDetailModel implements SaleDetailInterface{
  @override
  final int? id;
  @override
  final int amount;
  @override
  final double unit_price;
  @override
  final double sub_total;
  @override
  final int id_sale;
  @override
  final int id_product;

  SaleDetailModel({
    required this.id,
    required this.amount,
    required this.unit_price,
    required this.sub_total,
    required this.id_sale,
    required this.id_product
  });

    factory SaleDetailModel.fromJson(Map<String, dynamic> json){
    return SaleDetailModel(
      id: json['id'],
      amount: json['amount'],
      unit_price: json['unit_price'],
      sub_total: json['sub_total'],
      id_sale: json['id_sale'],
      id_product: json['id_product']
    );
  }

  factory SaleDetailModel.fromMap(Map<String, dynamic> map){
    return SaleDetailModel(
      id: map['id'],
      amount: map['amount'],
      unit_price: map['unit_price'],
      sub_total: map['sub_total'],
      id_sale: map['id_sale'],
      id_product: map['id_product']
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      'amount': amount,
      'unit_price': unit_price,
      'sub_total': sub_total,
      'id_sale': id_sale,
      'id_product': id_product
    };
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'amount': amount,
      'unit_price': unit_price,
      'sub_total': sub_total,
      'id_sale': id_sale,
      'id_product': id_product
    };
  }
}