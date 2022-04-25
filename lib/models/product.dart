import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:store_compare/constants/keys.dart';

class Product extends ParseObject implements ParseCloneable {

  Product() : super('Products');
  Product.clone() : this();

  /// Looks strangely hacky but due to Flutter not using reflection, we have to
  /// mimic a clone
  @override
  Product clone(Map<String, dynamic> map) => Product.clone()..fromJson(map);

  String get productName => get<String>(keyName)!;
  set productName(String productName) =>
      set<String>(keyName, productName);

  num get price => get<num>(keyPrice)!;
  set price(num price) =>
      set<num>(keyPrice, price);

  num get realPrice => get<num>(keyRealPrice)!;
  set realPrice(num realPrice) =>
      set<num>(keyRealPrice, realPrice);

  String get category => get<String>(keyCategory)!;
  set category(String category) =>
      set<String>(keyCategory, category);

  bool get isPrimary => get<bool>(keyIsPrimary)!;
  set isPrimary(bool? isPrimary) =>
      set<bool>(keyIsPrimary, isPrimary ?? false);

  String get tag => get<String>(keyTag)!;
  set tag(String tag) =>
      set<String>(keyTag, tag);

  bool get isOffer => get<bool>(keyIsOffer)!;
  set isOffer(bool? isOffer) =>
      set<bool>(keyIsOffer, isOffer ?? false);

  int get searchCode => get<int>(keySearchCode)!;
  set searchCode(int? searchCode) =>
      set<int>(keySearchCode, searchCode ?? hashCode);

  String get shop => get<String>(keyShop)!;
  set shop(String shop) =>
      set<String>(keyShop, shop);

  @override
  bool operator ==(Object other) {
    return (other is Product) && productName == other.productName;
  }

  @override
  int get hashCode => productName.hashCode;

  factory Product.fromMap(Map<String, dynamic> objectData) {
    return Product()
      ..productName = objectData[keyName]
      ..tag = objectData[keyTag]
      ..price = objectData[keyPrice]
      ..realPrice = objectData[keyRealPrice]
      ..isPrimary = objectData[keyIsPrimary]
      ..isOffer = objectData[keyIsOffer]
      ..category = objectData[keyCategory]
      ..searchCode = objectData[keyName].hashCode
      ..shop= objectData[keyShop]
    ;
  }
}
