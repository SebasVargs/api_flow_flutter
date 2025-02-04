import 'package:api_control_flow/domain/entities/bussines/product/product_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/product_repository.dart';

class InsertProductUseCase {
  final ProductRepository productRepository;

  InsertProductUseCase(this.productRepository);

  Future<int> execute(ProductModel product){
    return productRepository.insertProduct(product);
  }
}