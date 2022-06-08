

import 'package:store_compare/models/nomenclator.dart';
import 'package:store_compare/models/product.dart';
import 'package:store_compare/models/shop_item.dart';

abstract class ProductServiceContract {
  Future<List<Product>> fetchAll();
  Future<List<Product>> filter(String filter);
  Future<List<Product>> getAllByTagAndCategory(String tag, String category);
  Future<List<Product>> saveBulk(List<Product> productsToSave);
  Future<List<String>> getTags(String filter);
}

abstract class ShopItemContract {
  Future<List<ShopItem>> fetchAll();
  Future<ShopItem> save(ShopItem itemToSave);
  Future<bool> toggle(ShopItem itemToSave);
  Future<void> delete(ShopItem itemToDelete);
}

abstract class NomenclatorsServiceContract {
  late Map<String, List<Nomenclator>> nomenclators;
  Future<List<Nomenclator>> fetchAll();
  Future<Nomenclator> save(Nomenclator itemToSave);
  Future<bool> toggle(Nomenclator itemToSave);
  Future<void> delete(Nomenclator itemToDelete);
}
