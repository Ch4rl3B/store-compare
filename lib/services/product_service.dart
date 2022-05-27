import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:store_compare/constants/keys.dart';
import 'package:store_compare/models/product.dart';
import 'package:store_compare/services/contracts.dart';

export 'package:store_compare/models/product.dart';
export 'package:store_compare/services/contracts.dart';

class ProductService extends GetxService implements ProductServiceContract {
  @override
  Future<List<Product>> fetchAll() async {
    // Create your query
    final parseQuery = QueryBuilder<Product>(Product())
      ..setLimit(1000)
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
        ..whereEqualTo(keySearchCode, int.tryParse(filter) ?? filter.hashCode),
      QueryBuilder<Product>(Product())..whereContains(keyName, filter),
      QueryBuilder<Product>(Product())..whereContains(keyTag, filter),
      QueryBuilder<Product>(Product())..whereContains(keyCategory, filter),
    ])
      ..orderByDescending('createdAt');
    // The query will resolve only after calling this method, retrieving
    // an array of `Product`, if success
    final apiResponse = await parseQuery.query<Product>();

    if (apiResponse.success) {
      return (apiResponse.results ?? <Product>[]) as List<Product>;
    } else {
      return Future.error(apiResponse.error!.message);
    }
  }

  @override
  Future<List<Product>> saveBulk(List<Product> productsToSave) async {
    final listToReturn = List<Product>.empty(growable: true);
    for (final product in productsToSave) {
      final response = await product.save();
      if (response.success) {
        listToReturn.add(response.result);
      } else {
        throw Exception(response.error?.message);
      }
    }
    return listToReturn;
  }

  @override
  Future<List<Product>> getAllByTagAndCategory(
      String tag, String category) async {
    // Create your query
    final parseQuery = QueryBuilder<Product>(Product())
      ..whereContains(keyTag, tag)
      ..whereContains(keyCategory, category)
      ..orderByDescending('createdAt');

    // The query will resolve only after calling this method, retrieving
    // an array of `Product`, if success
    final apiResponse = await parseQuery.query<Product>();

    if (apiResponse.success) {
      return (apiResponse.results ?? <Product>[]) as List<Product>;
    } else {
      return Future.error(apiResponse.error!.message);
    }
  }
}
