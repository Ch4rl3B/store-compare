

import 'package:store_compare/models/product.dart';

abstract class ProductServiceContract {
  Future<List<Product>> fetchAll();
  Future<List<Product>> filter(String filter);
}