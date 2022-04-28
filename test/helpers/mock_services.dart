import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/utils.dart';
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

  @override
  Future<List<Product>> saveBulk(List<Product>? productsToSave) =>
      super.noSuchMethod(Invocation.method(#saveBulk, [productsToSave]),
          returnValue: Future.value(
              generateProducts(amount: productsToSave?.length ?? 10)));
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
    ..category = 'alimentos';
}

List<Product> generateProducts({int amount = 10}) {
  final random = Random();
  return List.generate(
      amount,
      (index) => getDummyProduct(
          isOffer: random.nextBool(), isPrimary: random.nextBool()));
}

Future<void> dismissElement(WidgetTester tester, Finder finder,
    {required AxisDirection gestureDirection}) async {
  Offset downLocation;
  Offset upLocation;
  switch (gestureDirection) {
    case AxisDirection.left:
      // getTopRight() returns a point that's just beyond itemWidget's right
      // edge and outside the Dismissible event listener's bounds.
      downLocation = tester.getTopRight(finder);
      upLocation = tester.getTopLeft(finder) + const Offset(-0.1, 0);
      break;
    case AxisDirection.right:
      // we do the same thing here to keep the test symmetric
      downLocation = tester.getTopLeft(finder) + const Offset(0.1, 0);
      upLocation = tester.getTopRight(finder) + const Offset(0.1, 0);
      break;
    case AxisDirection.up:
      // getBottomLeft() returns a point that's just below itemWidget's bottom
      // edge and outside the Dismissible event listener's bounds.
      downLocation = tester.getBottomLeft(finder) + const Offset(0, -0.1);
      upLocation = tester.getTopLeft(finder) + const Offset(0, -0.1);
      break;
    case AxisDirection.down:
      // again with doing the same here for symmetry
      downLocation = tester.getTopLeft(finder) + const Offset(0.1, 0);
      upLocation = tester.getBottomLeft(finder) + const Offset(0.1, 0);
      break;
  }

  final gesture = await tester.startGesture(downLocation);
  await gesture.moveTo(upLocation);
  await gesture.up();
  await tester.pump();
  await tester.pump(); // start the slide
  await tester.pump(1.seconds); // finish the slide and start shrinking...
  await tester.pump(); // first frame of shrinking animation
  await tester.pump(1.seconds); // finish the shrinking and call the callback...
  await tester.pump(); // rebuild after the callback removes the entry
}
