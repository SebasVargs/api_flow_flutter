import 'package:api_control_flow/domain/entities/bussines/product/product_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/product_repository.dart';

class GetProductByIdUseCase {
  final ProductRepository productRepository;

  GetProductByIdUseCase(this.productRepository);

  Future<ProductModel?> execute(int id){
    return productRepository.getProductById(id);
  }
}