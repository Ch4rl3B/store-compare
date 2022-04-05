// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:store_compare/main.dart';
import 'package:store_compare/views/home/home.dart';
import 'package:store_compare/views/home/home_controller.dart';
import 'package:store_compare/views/splash/splash.dart';

import '../helpers/mock_services.dart';

void main() {
  testWidgets('Loading the application, first view is Splash',
          (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    expect(find.byType(SplashView), findsOneWidget);
  });
}
