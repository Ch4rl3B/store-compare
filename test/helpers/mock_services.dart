import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:store_compare/constants/keys.dart';
import 'package:store_compare/models/nomenclator.dart';
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

  @override
  Future<List<Product>> saveBulk(List<Product>? productsToSave) =>
      super.noSuchMethod(Invocation.method(#saveBulk, [productsToSave]),
          returnValue: Future.value(
              generateProducts(amount: productsToSave?.length ?? 10)));
}

class MockNomenclatorsService extends Mock
    implements NomenclatorsServiceContract {

  @override
  Map<String, List<Nomenclator>> nomenclators = {
    'SHOP' : generateNomenclators(amount: 5)
  };

  @override
  Future<List<Nomenclator>> fetchAll() async =>
      super.noSuchMethod(Invocation.method(#fetchAll, []),
          returnValue: Future.value(generateNomenclators()));

  @override
  Future<Nomenclator> save(Nomenclator? item) async =>
      super.noSuchMethod(Invocation.method(#save, []),
          returnValue: Future.value(getDummyNomenclator()));

  @override
  Future<bool> toggle(Nomenclator? itemToSave) async =>
      super.noSuchMethod(Invocation.method(#toggle, []),
          returnValue: Future.value(true));

  @override
  Future<void> delete(Nomenclator? itemToSave) async =>
      super.noSuchMethod(Invocation.method(#fetchAll, []),);
}

Future<void> setupParseInstance() async {
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, appName: keyApplicationName, debug: true);
}

Product getDummyProduct({bool isPrimary = false, bool isOffer = false}) {
  final faker = Faker();
  final date =
      DateTime.now().subtract(Duration(days: faker.randomGenerator.integer(6)));
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
    ..shop = 'Test'
    ..searchCode = name.hashCode
    ..category = 'alimento';
}

Nomenclator getDummyNomenclator({String? type, bool neww = false}) {
  final faker = Faker();
  final date =
      DateTime.now().subtract(Duration(days: faker.randomGenerator.integer(6)));
  final value = faker.company.name();
  type ??= 'SHOP';
  return Nomenclator()
    ..objectId = neww ? null : const Uuid().v4()
    ..set('createdAt', date)
    ..set('updatedAt', date)
    ..type = type
    ..value = value
    ..active = faker.randomGenerator.integer(10) % 3 == 0;
}

List<Nomenclator> generateNomenclators({int amount = 10}) =>
    List.generate(amount, (index) => getDummyNomenclator());

List<Product> generateProducts({int amount = 10}) {
  final random = Random();
  return List.generate(
      amount,
      (index) => getDummyProduct(
          isOffer: random.nextBool(), isPrimary: random.nextBool()));
}
