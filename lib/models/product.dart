
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Product extends ParseObject implements ParseCloneable {

  Product() : super('Products');
  Product.clone() : this();

  String get productName => get<String>('productName')!;
  set productName(String productName) =>
      set<String>('productName', productName);

  num get price => get<num>('price')!;
  set price(num price) =>
      set<num>('price', price);

  num get realPrice => get<num>('realPrice')!;
  set realPrice(num realPrice) =>
      set<num>('realPrice', realPrice);

  String get category => get<String>('category')!;
  set category(String category) =>
      set<String>('category', category);

  bool get isPrimary => get<bool>('isPrimary')!;
  set isPrimary(bool productName) =>
      set<bool>('isPrimary', isPrimary);

  String get tag => get<String>('tag')!;
  set tag(String productName) =>
      set<String>('tag', tag);
}
