import 'package:api_control_flow/domain/repositories/bussines/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository productRepository;

  DeleteProductUseCase(this.productRepository);

  Future<int> execute(int id){
    return productRepository.deleteProduct(id);
  }
}