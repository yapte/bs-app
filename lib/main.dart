import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_routes.dart';
import 'theme.dart';

void main() {
  runApp(const BigSaltsApp());
}

class BigSaltsApp extends StatelessWidget {
  const BigSaltsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          '\u0421\u041F\u0410 \u0411\u043E\u043B\u044C\u0448\u0438\u0435 '
          '\u0441\u043E\u043B\u0438',
      debugShowCheckedModeBanner: false,
      theme: SpaTheme.light,
      locale: const Locale('ru', 'RU'),
      supportedLocales: const [Locale('ru', 'RU'), Locale('en', 'US')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      initialRoute: '/',
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
