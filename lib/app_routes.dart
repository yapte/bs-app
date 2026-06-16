import 'package:flutter/material.dart';

import 'screens/home_screen/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/procedure_details_screen/procedure_details_screen.dart';
import 'screens/splash_screen.dart';

abstract final class AppRoutes {
  static String procedureDetails(String id) {
    return '/procedure-details?id=${Uri.encodeComponent(id)}';
  }

  static String chatWithProcedureDraft(String id) {
    return '/home?tab=chat&procedureId=${Uri.encodeComponent(id)}';
  }

  static Route<void> onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (context) {
        return switch (uri.path) {
          '/' => const SplashScreen(),
          '/login' => const LoginScreen(),
          '/home' => HomeScreen(
            initialTab: uri.queryParameters['tab'],
            draftProcedureId: uri.queryParameters['procedureId'],
          ),
          '/procedure-details' => _procedureDetailsScreen(uri),
          _ => const SplashScreen(),
        };
      },
    );
  }

  static Widget _procedureDetailsScreen(Uri uri) {
    final id = uri.queryParameters['id'];
    if (id == null) {
      return const SplashScreen();
    }

    return ProcedureDetailsScreen(procedureId: id);
  }
}
