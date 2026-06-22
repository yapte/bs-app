import 'package:flutter/widgets.dart';

import '../auth/auth_repository.dart';
import 'api_services.dart';

class ApiScope extends InheritedWidget {
  const ApiScope({
    required this.services,
    required this.authRepository,
    required super.child,
    super.key,
  });

  final ApiServices services;
  final AuthRepository authRepository;

  static ApiServices of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ApiScope>();
    assert(scope != null, 'ApiScope is not available in this context');
    return scope!.services;
  }

  static AuthRepository authRepositoryOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ApiScope>();
    assert(scope != null, 'ApiScope is not available in this context');
    return scope!.authRepository;
  }

  @override
  bool updateShouldNotify(ApiScope oldWidget) {
    return services != oldWidget.services ||
        authRepository != oldWidget.authRepository;
  }
}
