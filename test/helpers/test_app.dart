import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

class TestApp extends StatelessWidget {
  final Widget child;

  const TestApp({super.key, required this.child});

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
      home: SafeArea(child: child,),
    );
  }
}
