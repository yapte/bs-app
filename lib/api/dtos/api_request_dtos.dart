import '../../common/models/models.dart';
import 'json_readers.dart';

abstract final class ApiRequestDto {
  static JsonMap createClient(CreateClient value) => {
    'name': value.name,
    'email': value.email,
    'phone': value.phone,
    'birth': value.birth.toIso8601String(),
    'sex': value.sex,
    if (value.userId != null) 'userId': value.userId,
    if (value.comment != null) 'comment': value.comment,
  };

  static JsonMap updateClient(UpdateClient value) => {
    if (value.name != null) 'name': value.name,
    if (value.email != null) 'email': value.email,
    if (value.phone != null) 'phone': value.phone,
    if (value.birth != null) 'birth': value.birth!.toIso8601String(),
    if (value.sex != null) 'sex': value.sex,
    if (value.userId != null) 'userId': value.userId,
    if (value.comment != null) 'comment': value.comment,
  };

  static JsonMap createUser(CreateUser value) => {
    'name': value.name,
    'email': value.email,
    'role': value.role,
    'password': value.password,
  };

  static JsonMap updateUser(UpdateUser value) => {
    if (value.name != null) 'name': value.name,
    if (value.email != null) 'email': value.email,
    if (value.role != null) 'role': value.role,
    if (value.retryCount != null) 'retryCount': value.retryCount,
  };

  static JsonMap createRoom(CreateRoom value) => {
    'name': value.name,
    'type': value.type,
    'capacity': value.capacity,
    'bedCount': value.bedCount,
    'price': value.price,
    if (value.description != null) 'description': value.description,
  };

  static JsonMap updateRoom(UpdateRoom value) => {
    if (value.name != null) 'name': value.name,
    if (value.type != null) 'type': value.type,
    if (value.capacity != null) 'capacity': value.capacity,
    if (value.bedCount != null) 'bedCount': value.bedCount,
    if (value.price != null) 'price': value.price,
    if (value.description != null) 'description': value.description,
  };

  static JsonMap createReservation(CreateReservation value) => {
    'clientId': value.clientId,
    'roomId': value.roomId,
    'checkInDate': value.checkInDate.toIso8601String(),
    'checkOutDate': value.checkOutDate.toIso8601String(),
    'status': value.status,
    if (value.discount != null) 'discount': value.discount,
    if (value.absoluteDiscount != null)
      'absoluteDiscount': value.absoluteDiscount,
    if (value.comment != null) 'comment': value.comment,
  };

  static JsonMap updateReservation(UpdateReservation value) => {
    if (value.clientId != null) 'clientId': value.clientId,
    if (value.roomId != null) 'roomId': value.roomId,
    if (value.checkInDate != null)
      'checkInDate': value.checkInDate!.toIso8601String(),
    if (value.checkOutDate != null)
      'checkOutDate': value.checkOutDate!.toIso8601String(),
    if (value.status != null) 'status': value.status,
    if (value.discount != null) 'discount': value.discount,
    if (value.absoluteDiscount != null)
      'absoluteDiscount': value.absoluteDiscount,
    if (value.comment != null) 'comment': value.comment,
  };

  static JsonMap createPayment(CreatePayment value) => {
    'reservationId': value.reservationId,
    'amount': value.amount,
    'paymentDate': value.paymentDate.toIso8601String(),
    'paymentMethod': value.paymentMethod,
  };

  static JsonMap updatePayment(UpdatePayment value) => {
    if (value.reservationId != null) 'reservationId': value.reservationId,
    if (value.amount != null) 'amount': value.amount,
    if (value.paymentDate != null)
      'paymentDate': value.paymentDate!.toIso8601String(),
    if (value.paymentMethod != null) 'paymentMethod': value.paymentMethod,
  };

  static JsonMap createEmployee(CreateEmployee value) => {
    'name': value.name,
    'position': value.position,
    'email': value.email,
    'phone': value.phone,
    'userId': value.userId,
  };

  static JsonMap updateEmployee(UpdateEmployee value) => {
    if (value.name != null) 'name': value.name,
    if (value.position != null) 'position': value.position,
    if (value.email != null) 'email': value.email,
    if (value.phone != null) 'phone': value.phone,
    if (value.userId != null) 'userId': value.userId,
  };

  static JsonMap timeInterval(TimeInterval value) => {
    'from': value.from,
    'to': value.to,
  };

  static JsonMap createEmployeeSchedule(CreateEmployeeSchedule value) => {
    'employeeId': value.employeeId,
    'date': value.date.toIso8601String(),
    'intervals': value.intervals.map(timeInterval).toList(),
  };

  static JsonMap updateEmployeeSchedule(UpdateEmployeeSchedule value) => {
    if (value.employeeId != null) 'employeeId': value.employeeId,
    if (value.date != null) 'date': value.date!.toIso8601String(),
    if (value.intervals != null)
      'intervals': value.intervals!.map(timeInterval).toList(),
  };

  static JsonMap createSpaProcedure(CreateSpaProcedure value) => {
    if (value.slug != null) 'slug': value.slug,
    'name': value.name,
    'description': value.description,
    'duration': value.durationMinutes,
    'price': value.price,
    if (value.groupId != null) 'spaProcedureGroupId': value.groupId,
    'availableEmployeeIds': value.availableEmployeeIds,
  };

  static JsonMap updateSpaProcedure(UpdateSpaProcedure value) => {
    if (value.slug != null) 'slug': value.slug,
    if (value.name != null) 'name': value.name,
    if (value.description != null) 'description': value.description,
    if (value.durationMinutes != null) 'duration': value.durationMinutes,
    if (value.price != null) 'price': value.price,
    if (value.groupId != null) 'spaProcedureGroupId': value.groupId,
    if (value.availableEmployeeIds != null)
      'availableEmployeeIds': value.availableEmployeeIds,
  };

  static JsonMap createAppointment(CreateAppointment value) => {
    'employeeIds': value.employeeIds,
    'clientId': value.clientId,
    'spaProcedureId': value.spaProcedureId,
    'startAt': value.startAt.toIso8601String(),
    'endAt': value.endAt.toIso8601String(),
    'status': value.status,
    if (value.cabinet != null) 'cabinet': value.cabinet,
    if (value.comment != null) 'comment': value.comment,
  };

  static JsonMap updateAppointment(UpdateAppointment value) => {
    if (value.employeeIds != null) 'employeeIds': value.employeeIds,
    if (value.clientId != null) 'clientId': value.clientId,
    if (value.spaProcedureId != null) 'spaProcedureId': value.spaProcedureId,
    if (value.startAt != null) 'startAt': value.startAt!.toIso8601String(),
    if (value.endAt != null) 'endAt': value.endAt!.toIso8601String(),
    if (value.status != null) 'status': value.status,
    if (value.cabinet != null) 'cabinet': value.cabinet,
    if (value.comment != null) 'comment': value.comment,
  };
}
