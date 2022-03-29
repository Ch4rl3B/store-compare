import 'dart:math';

import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:store_compare/constants/keys.dart';
import 'package:store_compare/services/product_service.dart';
import 'package:uuid/uuid.dart';

class MockProductService extends Mock implements ProductServiceContract {
  @override
  Future<List<Product>> fetchAll() async =>
      super.noSuchMethod(Invocation.method(#fetchAll, []),
          returnValue: Future.value(generateProducts()));

  @override
  Future<List<Product>> filter(String? filter) async =>
      super.noSuchMethod(Invocation.method(#filter, [filter]),
          returnValue: Future.value(generateProducts()));
}

Future<void> setupParseInstance() async {
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, appName: keyApplicationName, debug: true);
}

Product getDummyProduct({bool isPrimary = false, bool isOffer = false}) {
  final faker = Faker();
  final date = DateTime.now();
  final name = faker.food.dish();
  final price = faker.randomGenerator.decimal(min: 1);
  return Product()
    ..objectId = const Uuid().v4()
    ..set('createdAt', date)
    ..set('updatedAt', date)
    ..productName = name
    ..tag = name
    ..price = price
    ..realPrice = price
    ..isPrimary = isPrimary
    ..isOffer = isOffer
    ..category = 'alimentos';
}

List<Product> generateProducts() {
  final random = Random();
  return List.generate(
      10,
      (index) => getDummyProduct(
          isOffer: random.nextBool(), isPrimary: random.nextBool()));
}
