import 'common_models.dart';

class Client {
  const Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.birth,
    required this.sex,
    required this.audit,
    this.userId,
    this.comment,
  });

  final int id;
  final String name;
  final String email;
  final String phone;
  final DateTime birth;
  final String sex;
  final int? userId;
  final String? comment;
  final AuditData audit;
}

class CreateClient {
  const CreateClient({
    required this.name,
    required this.email,
    required this.phone,
    required this.birth,
    required this.sex,
    this.userId,
    this.comment,
  });

  final String name;
  final String email;
  final String phone;
  final DateTime birth;
  final String sex;
  final int? userId;
  final String? comment;
}

class UpdateClient {
  const UpdateClient({
    this.name,
    this.email,
    this.phone,
    this.birth,
    this.sex,
    this.userId,
    this.comment,
  });

  final String? name;
  final String? email;
  final String? phone;
  final DateTime? birth;
  final String? sex;
  final int? userId;
  final String? comment;
}
