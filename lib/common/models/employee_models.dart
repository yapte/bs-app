import 'common_models.dart';

class Employee {
  const Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.email,
    required this.phone,
    required this.userId,
    required this.audit,
  });

  final int id;
  final String name;
  final String position;
  final String email;
  final String phone;
  final int userId;
  final AuditData audit;
}

class EmployeeSummary {
  const EmployeeSummary({
    required this.id,
    required this.name,
    required this.position,
  });

  final int id;
  final String name;
  final String position;
}

class CreateEmployee {
  const CreateEmployee({
    required this.name,
    required this.position,
    required this.email,
    required this.phone,
    required this.userId,
  });

  final String name;
  final String position;
  final String email;
  final String phone;
  final int userId;
}

class UpdateEmployee {
  const UpdateEmployee({
    this.name,
    this.position,
    this.email,
    this.phone,
    this.userId,
  });

  final String? name;
  final String? position;
  final String? email;
  final String? phone;
  final int? userId;
}
