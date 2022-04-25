// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_compare/services/product_service.dart';
import 'package:store_compare/views/home/home.dart';
import 'package:store_compare/views/home/home_controller.dart';
import 'package:store_compare/views/home/widgets/product_detail.dart';
import 'package:store_compare/views/home/widgets/product_list.dart';
import 'package:supercharged/supercharged.dart';

import '../helpers/mock_services.dart';
import '../helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, String>{});
  late List<Product> mockProducts;

  Future<ProductServiceContract> getService() async {
    final mockService = MockProductService();
    mockProducts = generateProducts();

    when(mockService.fetchAll())
        .thenAnswer((_) async => Future<List<Product>>.value(mockProducts));
    when(mockService.filter(any)).thenAnswer(
        (_) async => Future<List<Product>>.value([mockProducts.first]));

    return mockService;
  }

  setUp(() async {
    await setupParseInstance();
    await Get.putAsync(getService);
  });

  testWidgets(
      'Home view has a list of products and an app bar with a search button',
      (WidgetTester tester) async {
    Get.put(HomeController());

    await tester.pumpWidget(const TestApp(child: HomeView()));
    expect(find.byType(HomeView), findsOneWidget);
    await tester.pump(2.seconds);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byKey(const ValueKey('#search')), findsOneWidget);
    expect(find.byType(ProductList), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);
    expect(find.byKey(ValueKey(mockProducts.first.objectId)), findsOneWidget);
  });

  testWidgets(
      'HomeView when a search returns one result then a details view appears',
      (WidgetTester tester) async {
    Get.put(HomeController());
    await tester.pumpWidget(const TestApp(child: HomeView()));
    await tester.pump(2.seconds);
    expect(find.byKey(const ValueKey('#search')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('#search')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('#searchField')), findsOneWidget,
        reason: 'When clicked the button a text field appears');
    await tester.enterText(find.byKey(const ValueKey('#searchField')),
        mockProducts.first.productName);
    await tester.pump(500.milliseconds); //Time to fire the search
    expect(Get.find<HomeController>().products.length, 1,
        reason: 'The search returned only one item');
    await tester.pumpAndSettle();
    expect(find.byType(ProductDetail), findsOneWidget);
    expect(find.byType(ProductList), findsOneWidget,
        reason: 'ProductDetail has a list');
    expect(find.byType(ListTile), findsWidgets,
        reason: 'ProductDetail has a list of occurrences');
    expect(find.byKey(ValueKey(mockProducts.first.objectId)), findsOneWidget,
        reason: 'There is a product with the given objectId');
  });

  testWidgets('Home view when click on a product goes to details',
      (WidgetTester tester) async {
    Get.put(HomeController());

    await tester.pumpWidget(const TestApp(child: HomeView()));
    expect(find.byType(HomeView), findsOneWidget);
    await tester.pump(2.seconds);
    expect(find.byType(ProductList), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);
    expect(find.byKey(ValueKey(mockProducts.first.objectId)), findsOneWidget);
    await tester.tap(find.byKey(ValueKey(mockProducts.first.objectId)));
    await tester.pumpAndSettle(1.seconds);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byIcon(Icons.cancel), findsOneWidget,
        reason: 'AppBar has a cancel icon at right of the search field');
    expect(find.byKey(const ValueKey('#searchField')), findsOneWidget,
        reason:
            'AppBar has a text field as the click action triggers a search');
    final searchField = find.byKey(const ValueKey('#searchField'));
    expect((searchField.evaluate().first.widget as TextField).controller?.text,
        mockProducts.first.productName,
        reason: 'Search Field has the name of the clicked product');
    expect(find.byType(ProductDetail), findsOneWidget);
    expect(find.byType(ProductList), findsOneWidget,
        reason: 'ProductDetail has a list');
    expect(find.byType(ListTile), findsWidgets,
        reason: 'ProductDetail has a list of occurrences');
    expect(find.byKey(ValueKey(mockProducts.first.objectId)), findsOneWidget,
        reason: 'There is a product with the given objectId');
  });
}
