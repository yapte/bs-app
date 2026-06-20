import 'common_models.dart';

class Appointment {
  const Appointment({
    required this.id,
    required this.employeeIds,
    required this.clientId,
    required this.spaProcedureId,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.audit,
    this.cabinet,
    this.comment,
  });

  final int id;
  final List<int> employeeIds;
  final int clientId;
  final int spaProcedureId;
  final DateTime startAt;
  final DateTime endAt;
  final String status;
  final String? cabinet;
  final String? comment;
  final AuditData audit;
}

class CreateAppointment {
  const CreateAppointment({
    required this.employeeIds,
    required this.clientId,
    required this.spaProcedureId,
    required this.startAt,
    required this.endAt,
    required this.status,
    this.cabinet,
    this.comment,
  });

  final List<int> employeeIds;
  final int clientId;
  final int spaProcedureId;
  final DateTime startAt;
  final DateTime endAt;
  final String status;
  final String? cabinet;
  final String? comment;
}

class UpdateAppointment {
  const UpdateAppointment({
    this.employeeIds,
    this.clientId,
    this.spaProcedureId,
    this.startAt,
    this.endAt,
    this.status,
    this.cabinet,
    this.comment,
  });

  final List<int>? employeeIds;
  final int? clientId;
  final int? spaProcedureId;
  final DateTime? startAt;
  final DateTime? endAt;
  final String? status;
  final String? cabinet;
  final String? comment;
}

class AppointmentQuery extends PageQuery {
  const AppointmentQuery({
    super.sort,
    super.sortDirection,
    super.search,
    super.itemsPerPage,
    super.page,
    this.statuses = const [],
    this.employeeIds = const [],
    this.clientId,
    this.spaProcedureId,
    this.from,
    this.to,
  });

  final List<String> statuses;
  final List<int> employeeIds;
  final int? clientId;
  final int? spaProcedureId;
  final DateTime? from;
  final DateTime? to;
}

class AppointmentSearch {
  const AppointmentSearch({
    required this.employeeIds,
    required this.from,
    required this.to,
    this.statuses = const [],
  });

  final List<int> employeeIds;
  final DateTime from;
  final DateTime to;
  final List<String> statuses;
}
