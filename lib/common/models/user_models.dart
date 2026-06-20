import 'common_models.dart';

class UserAccount {
  const UserAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.audit,
    this.retryCount,
  });

  final int id;
  final String name;
  final String email;
  final String role;
  final int? retryCount;
  final AuditData audit;
}

class CreateUser {
  const CreateUser({
    required this.name,
    required this.email,
    required this.role,
    required this.password,
  });

  final String name;
  final String email;
  final String role;
  final String password;
}

class UpdateUser {
  const UpdateUser({this.name, this.email, this.role, this.retryCount});

  final String? name;
  final String? email;
  final String? role;
  final int? retryCount;
}
