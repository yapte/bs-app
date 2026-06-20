import 'common_models.dart';

class Reservation {
  const Reservation({
    required this.id,
    required this.clientId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    required this.audit,
    this.discount,
    this.absoluteDiscount,
    this.comment,
  });

  final int id;
  final int clientId;
  final int roomId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String status;
  final double? discount;
  final double? absoluteDiscount;
  final String? comment;
  final AuditData audit;
}

class CreateReservation {
  const CreateReservation({
    required this.clientId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    this.discount,
    this.absoluteDiscount,
    this.comment,
  });

  final int clientId;
  final int roomId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String status;
  final double? discount;
  final double? absoluteDiscount;
  final String? comment;
}

class UpdateReservation {
  const UpdateReservation({
    this.clientId,
    this.roomId,
    this.checkInDate,
    this.checkOutDate,
    this.status,
    this.discount,
    this.absoluteDiscount,
    this.comment,
  });

  final int? clientId;
  final int? roomId;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String? status;
  final double? discount;
  final double? absoluteDiscount;
  final String? comment;
}

class ReservationQuery extends PageQuery {
  const ReservationQuery({
    super.sort,
    super.sortDirection,
    super.search,
    super.itemsPerPage,
    super.page,
    this.statuses = const [],
    this.roomId,
    this.clientId,
    this.from,
    this.to,
  });

  final List<String> statuses;
  final int? roomId;
  final int? clientId;
  final DateTime? from;
  final DateTime? to;
}
