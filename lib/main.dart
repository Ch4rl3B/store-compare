import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:store_compare/constants/app_routes.dart';
import 'package:store_compare/constants/paths.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Store Compare',
      // The Mandy red, light theme.
      theme: FlexThemeData.light(scheme: FlexScheme.bahamaBlue),
      // The Mandy red, dark theme.
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.bahamaBlue),
      // Localizations delegate for having multiple languages
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
      ],
      routes: AppRoutes.appRoutes,
      initialRoute: Paths.splash,
      builder: (context, widget) => SafeArea(child: widget!),
    );
  }
}
