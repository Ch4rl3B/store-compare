
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Product extends ParseObject implements ParseCloneable {

  Product() : super('Products');
  Product.clone() : this();

  /// Looks strangely hacky but due to Flutter not using reflection, we have to
  /// mimic a clone
  @override
  Product clone(Map<String, dynamic> map) => Product.clone()..fromJson(map);

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
  set isPrimary(bool? isPrimary) =>
      set<bool>('isPrimary', isPrimary ?? false);

  String get tag => get<String>('tag')!;
  set tag(String tag) =>
      set<String>('tag', tag);

  bool get isOffer => get<bool>('isOffer')!;
  set isOffer(bool? isOffer) =>
      set<bool>('isOffer', isOffer ?? false);

  @override
  bool operator ==(Object other) {
    return (other is Product) && productName == other.productName;
  }

  @override
  int get hashCode => productName.hashCode;

}
