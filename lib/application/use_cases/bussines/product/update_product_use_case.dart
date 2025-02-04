import 'package:api_control_flow/domain/entities/bussines/product/product_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository productRepository;

  UpdateProductUseCase(this.productRepository);

  Future<int> execute(ProductModel product){
    return productRepository.updateProduct(product);
  }
}