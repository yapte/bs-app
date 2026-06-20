import 'common_models.dart';

class Payment {
  const Payment({
    required this.id,
    required this.reservationId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.audit,
  });

  final int id;
  final int reservationId;
  final double amount;
  final DateTime paymentDate;
  final String paymentMethod;
  final AuditData audit;
}

class CreatePayment {
  const CreatePayment({
    required this.reservationId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
  });

  final int reservationId;
  final double amount;
  final DateTime paymentDate;
  final String paymentMethod;
}

class UpdatePayment {
  const UpdatePayment({
    this.reservationId,
    this.amount,
    this.paymentDate,
    this.paymentMethod,
  });

  final int? reservationId;
  final double? amount;
  final DateTime? paymentDate;
  final String? paymentMethod;
}
