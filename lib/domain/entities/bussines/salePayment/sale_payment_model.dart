import 'package:api_control_flow/domain/entities/bussines/salePayment/sale_payment_interface.dart';

class SalePaymentModel implements SalePaymentInterface{
  @override
  final int? id_payment_meth;
  @override
  final int? id_sale;

  SalePaymentModel({
    required this.id_payment_meth,
    required this.id_sale
  });
}