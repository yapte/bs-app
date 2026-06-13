import 'package:flutter/material.dart';

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
      initialRoute: '/',
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
