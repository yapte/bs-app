import 'common_models.dart';

class FavoriteProcedure {
  const FavoriteProcedure({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.price,
  });

  final String id;
  final String title;
  final String description;
  final String duration;
  final double price;
}

class SpaProcedure {
  const SpaProcedure({
    required this.id,
    required this.name,
    required this.description,
    required this.durationMinutes,
    required this.price,
    required this.availableEmployeeIds,
    required this.audit,
    this.slug,
    this.groupId,
  });

  final int id;
  final String? slug;
  final String name;
  final String description;
  final int durationMinutes;
  final double price;
  final int? groupId;
  final List<int> availableEmployeeIds;
  final AuditData audit;
}

class CreateSpaProcedure {
  const CreateSpaProcedure({
    required this.name,
    required this.description,
    required this.durationMinutes,
    required this.price,
    required this.availableEmployeeIds,
    this.slug,
    this.groupId,
  });

  final String? slug;
  final String name;
  final String description;
  final int durationMinutes;
  final double price;
  final int? groupId;
  final List<int> availableEmployeeIds;
}

class UpdateSpaProcedure {
  const UpdateSpaProcedure({
    this.slug,
    this.name,
    this.description,
    this.durationMinutes,
    this.price,
    this.groupId,
    this.availableEmployeeIds,
  });

  final String? slug;
  final String? name;
  final String? description;
  final int? durationMinutes;
  final double? price;
  final int? groupId;
  final List<int>? availableEmployeeIds;
}

class SpaProcedureGroup {
  const SpaProcedureGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.audit,
  });

  final int id;
  final String name;
  final String description;
  final AuditData audit;
}

class CreateSpaProcedureGroup {
  const CreateSpaProcedureGroup({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

class UpdateSpaProcedureGroup {
  const UpdateSpaProcedureGroup({this.name, this.description});

  final String? name;
  final String? description;
}
