import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_compare/services/product_service.dart';

import '../helpers/mock_services.dart';

void main(){
  ProductServiceContract? service;
  SharedPreferences.setMockInitialValues(<String, String>{});

  Future<ProductServiceContract> getService() async {
    service ??= ProductService();
    return service!;
  }

  setUp(() async {
    await setupParseInstance();
    await getService();
  });

  tearDown(() async {
    service = null;
  });

  test('Service has been instantiated', () async {
    expect(true, service != null);
  });

  test('Get All Products from API', () async {
    final products = await service!.fetchAll();
    expect(products.isNotEmpty, true);
  });

  test('Find all alimentos from API', () async {
    final products = await service!.filter('alimento');
    expect(products.isNotEmpty, true);
  });

  test('There are Gurken in list', () async {
    final products = await service!.filter('Gurken');
    expect(products.isNotEmpty, true);
    expect(products.last.price, 0.99);
  });

  test('The find method is case insensitive', () async {
    final products = await service!.filter('gurken');
    expect(products.isNotEmpty, true);
    expect(products.last.price, 0.99);
  });
}
