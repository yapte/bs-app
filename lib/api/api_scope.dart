import 'package:flutter/widgets.dart';

import '../auth/auth_repository.dart';
import 'ws/chat_ws_service.dart';
import 'api_services.dart';

class ApiScope extends InheritedWidget {
  const ApiScope({
    required this.services,
    required this.authRepository,
    this.chatWsService,
    required super.child,
    super.key,
  });

  final ApiServices services;
  final AuthRepository authRepository;
  final ChatWsService? chatWsService;

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

  static ChatWsService? chatWsServiceOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ApiScope>()
        ?.chatWsService;
  }

  @override
  bool updateShouldNotify(ApiScope oldWidget) {
    return services != oldWidget.services ||
        authRepository != oldWidget.authRepository ||
        chatWsService != oldWidget.chatWsService;
  }
}
