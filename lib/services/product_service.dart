import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:store_compare/models/product.dart';
import 'package:store_compare/services/product_service_contract.dart';

export 'package:store_compare/models/product.dart';
export 'package:store_compare/services/product_service_contract.dart';

class ProductService extends GetxService implements ProductServiceContract {
  @override
  Future<List<Product>> fetchAll() async {
    // Create your query
    final parseQuery = QueryBuilder<Product>(Product())
      ..orderByDescending('createdAt');
    // The query will resolve only after calling this method, retrieving
    // an array of `Product`, if success
    final apiResponse = await parseQuery.query<Product>();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results! as List<Product>;
    } else {
      return Future.error(apiResponse.error!.message);
    }
  }

  @override
  Future<List<Product>> filter(String filter) async {
    // Create your query
    final parseQuery = QueryBuilder<Product>.or(Product(), [
      QueryBuilder<Product>(Product())
        ..whereContains('productName', filter),
      QueryBuilder<Product>(Product())..whereContains('tag', filter),
      QueryBuilder<Product>(Product())..whereContains('category', filter),
    ])
      ..orderByDescending('createdAt');
    // The query will resolve only after calling this method, retrieving
    // an array of `Product`, if success
    final apiResponse = await parseQuery.query<Product>();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results! as List<Product>;
    } else {
      return Future.error(apiResponse.error!.message);
    }
  }
}
