
import 'package:api_control_flow/domain/entities/bussines/product/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts();
  Future<int> insertProduct(ProductModel product);
  Future<int> updateProduct(ProductModel product);
  Future<int> deleteProduct(int id);
  Future<ProductModel?> getProductById(int id);
}