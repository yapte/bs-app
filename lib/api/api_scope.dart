import 'package:flutter/widgets.dart';

import 'api_services.dart';

class ApiScope extends InheritedWidget {
  const ApiScope({required this.services, required super.child, super.key});

  final ApiServices services;

  static ApiServices of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ApiScope>();
    assert(scope != null, 'ApiScope is not available in this context');
    return scope!.services;
  }

  @override
  bool updateShouldNotify(ApiScope oldWidget) => services != oldWidget.services;
}
