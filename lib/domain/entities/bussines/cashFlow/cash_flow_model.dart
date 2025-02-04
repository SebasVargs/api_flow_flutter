import 'package:api_control_flow/domain/entities/bussines/cashFlow/cash_flow_interface.dart';

class CashFlowModel implements CashFlowInterface{
  @override
  final int? id;
  @override
  final DateTime cash_date;
  @override
  final double amount;
  @override
  final String detail;
  @override
  final int id_sale;
  @override
  final int id_buys;
  @override
  final int id_type_cash;
  @override
  final int id_concept_cash;

  CashFlowModel({
    required this.id,
    required this.cash_date,
    required this.amount,
    required this.detail,
    required this.id_sale,
    required this.id_buys,
    required this.id_type_cash,
    required this.id_concept_cash
  });

  factory CashFlowModel.fromJson(Map<String, dynamic> json){
    return CashFlowModel(
      id: json['id'],
      cash_date: json['cash_date'],
      amount: json['amount'],
      detail: json['detail'],
      id_sale: json['id_sale'],
      id_buys: json['id_buys'],
      id_type_cash: json['id_type_cash'],
      id_concept_cash: json['id_concept_cash']
    );
  }

  factory CashFlowModel.fromMap(Map<String, dynamic> map){
    return CashFlowModel(
      id: map['id'],
      cash_date: map['cash_date'],
      amount: map['amount'],
      detail: map['detail'],
      id_sale: map['id_sale'],
      id_buys: map['id_buys'],
      id_type_cash: map['id_type_cash'],
      id_concept_cash: map['id_concept_cash']
    );
  }

  @override
  Map<String, dynamic> toJson(){
    return {
      'amount': amount,
      'cash_date': cash_date,
      'detail': detail,
      'id_sale': id_sale,
      'id_buys': id_buys,
      'id_type_cash': id_type_cash,
      'id_concept_cash': id_concept_cash
    };
  }

  @override
  Map<String, dynamic> toMap(){
     return {
      'amount': amount,
      'cash_date': cash_date,
      'detail': detail,
      'id_sale': id_sale,
      'id_buys': id_buys,
      'id_type_cash': id_type_cash,
      'id_concept_cash': id_concept_cash
    };
  }
}