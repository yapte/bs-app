import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';

abstract final class AppRoutes {
  static Route<void> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (context) {
        return switch (settings.name) {
          '/' => const SplashScreen(),
          '/login' => const LoginScreen(),
          '/home' => const HomeScreen(),
          _ => const SplashScreen(),
        };
      },
    );
  }
}
