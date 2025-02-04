import 'package:api_control_flow/domain/entities/bussines/product/product_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/product_repository.dart';

class GetProductUseCase {
  final ProductRepository productRepository;

  GetProductUseCase(this.productRepository);

  Future<List<ProductModel>> execute(){
    return productRepository.getProducts();
  }
}