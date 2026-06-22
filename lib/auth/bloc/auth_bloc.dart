import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/api_exception.dart';
import '../../common/models/models.dart';
import '../auth_repository.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthLoginSubmitted extends AuthEvent {
  const AuthLoginSubmitted({required this.email, required this.password});

  final String email;
  final String password;
}

enum AuthStatus { initial, loading, success, failure }

class AuthState {
  const AuthState({this.status = AuthStatus.initial, this.errorMessage});

  final AuthStatus status;
  final String? errorMessage;
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState()) {
    on<AuthLoginSubmitted>(_onLoginSubmitted);
  }

  final AuthRepository _authRepository;

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (state.status == AuthStatus.loading) {
      return;
    }

    emit(const AuthState(status: AuthStatus.loading));

    try {
      await _authRepository.login(
        LoginCredentials(email: event.email, password: event.password),
      );
      emit(const AuthState(status: AuthStatus.success));
    } on ApiException catch (error) {
      emit(
        AuthState(
          status: AuthStatus.failure,
          errorMessage: error.statusCode == 401
              ? 'Неверный email или пароль'
              : error.message,
        ),
      );
    } catch (_) {
      emit(
        const AuthState(
          status: AuthStatus.failure,
          errorMessage: 'Не удалось войти. Проверьте подключение к интернету.',
        ),
      );
    }
  }
}
