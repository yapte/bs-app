import '../../common/models/models.dart';
import 'json_readers.dart';

class AuditDto {
  const AuditDto({
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
  });

  factory AuditDto.fromJson(JsonMap json) {
    return AuditDto(
      createdAt: readDate(json['createdAt']),
      updatedAt: readDate(json['updatedAt']),
      deletedAt: readNullableDate(json['deletedAt']),
      createdBy: readNullableInt(json['createdBy']),
      updatedBy: readNullableInt(json['updatedBy']),
      deletedBy: readNullableInt(json['deletedBy']),
    );
  }

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int? createdBy;
  final int? updatedBy;
  final int? deletedBy;

  AuditData toDomain() => AuditData(
    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
    createdBy: createdBy,
    updatedBy: updatedBy,
    deletedBy: deletedBy,
  );
}

class ClientDto {
  ClientDto.fromJson(JsonMap json)
    : id = readInt(json['id']),
      name = readString(json['name']),
      email = readString(json['email']),
      phone = readString(json['phone']),
      birth = readDate(json['birth']),
      sex = readString(json['sex']),
      userId = readNullableInt(json['userId']),
      comment = readNullableString(json['comment']),
      audit = AuditDto.fromJson(json);

  final int id;
  final String name;
  final String email;
  final String phone;
  final DateTime birth;
  final String sex;
  final int? userId;
  final String? comment;
  final AuditDto audit;

  Client toDomain() => Client(
    id: id,
    name: name,
    email: email,
    phone: phone,
    birth: birth,
    sex: sex,
    userId: userId,
    comment: comment,
    audit: audit.toDomain(),
  );
}

class UserDto {
  UserDto.fromJson(JsonMap json)
    : id = readInt(json['id']),
      name = readString(json['name']),
      email = readString(json['email']),
      role = readString(json['role']),
      retryCount = readNullableInt(json['retryCount']),
      audit = AuditDto.fromJson(json);

  final int id;
  final String name;
  final String email;
  final String role;
  final int? retryCount;
  final AuditDto audit;

  UserAccount toDomain() => UserAccount(
    id: id,
    name: name,
    email: email,
    role: role,
    retryCount: retryCount,
    audit: audit.toDomain(),
  );
}

class RoomDto {
  RoomDto.fromJson(JsonMap json)
    : id = readInt(json['id']),
      name = readString(json['name']),
      type = readString(json['type']),
      capacity = readInt(json['capacity']),
      bedCount = readInt(json['bedCount']),
      price = readDouble(json['price']),
      description = readNullableString(json['description']),
      audit = AuditDto.fromJson(json);

  final int id;
  final String name;
  final String type;
  final int capacity;
  final int bedCount;
  final double price;
  final String? description;
  final AuditDto audit;

  Room toDomain() => Room(
    id: id,
    name: name,
    type: type,
    capacity: capacity,
    bedCount: bedCount,
    price: price,
    description: description,
    audit: audit.toDomain(),
  );
}

class ReservationDto {
  ReservationDto.fromJson(JsonMap json)
    : id = readInt(json['id']),
      clientId = readInt(json['clientId']),
      roomId = readInt(json['roomId']),
      checkInDate = readDate(json['checkInDate']),
      checkOutDate = readDate(json['checkOutDate']),
      status = readString(json['status']),
      discount = readNullableDouble(json['discount']),
      absoluteDiscount = readNullableDouble(json['absoluteDiscount']),
      comment = readNullableString(json['comment']),
      audit = AuditDto.fromJson(json);

  final int id;
  final int clientId;
  final int roomId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String status;
  final double? discount;
  final double? absoluteDiscount;
  final String? comment;
  final AuditDto audit;

  Reservation toDomain() => Reservation(
    id: id,
    clientId: clientId,
    roomId: roomId,
    checkInDate: checkInDate,
    checkOutDate: checkOutDate,
    status: status,
    discount: discount,
    absoluteDiscount: absoluteDiscount,
    comment: comment,
    audit: audit.toDomain(),
  );
}

class PaymentDto {
  PaymentDto.fromJson(JsonMap json)
    : id = readInt(json['id']),
      reservationId = readInt(json['reservationId']),
      amount = readDouble(json['amount']),
      paymentDate = readDate(json['paymentDate']),
      paymentMethod = readString(json['paymentMethod']),
      audit = AuditDto.fromJson(json);

  final int id;
  final int reservationId;
  final double amount;
  final DateTime paymentDate;
  final String paymentMethod;
  final AuditDto audit;

  Payment toDomain() => Payment(
    id: id,
    reservationId: reservationId,
    amount: amount,
    paymentDate: paymentDate,
    paymentMethod: paymentMethod,
    audit: audit.toDomain(),
  );
}

class EmployeeDto {
  EmployeeDto.fromJson(JsonMap json)
    : id = readInt(json['id']),
      name = readString(json['name']),
      position = readString(json['position']),
      email = readString(json['email']),
      phone = readString(json['phone']),
      userId = readInt(json['userId']),
      audit = AuditDto.fromJson(json);

  final int id;
  final String name;
  final String position;
  final String email;
  final String phone;
  final int userId;
  final AuditDto audit;

  Employee toDomain() => Employee(
    id: id,
    name: name,
    position: position,
    email: email,
    phone: phone,
    userId: userId,
    audit: audit.toDomain(),
  );
}

class EmployeeSummaryDto {
  EmployeeSummaryDto.fromJson(JsonMap json)
    : id = readInt(json['id']),
      name = readString(json['name']),
      position = readString(json['position']);

  final int id;
  final String name;
  final String position;

  EmployeeSummary toDomain() =>
      EmployeeSummary(id: id, name: name, position: position);
}

class TimeIntervalDto {
  TimeIntervalDto.fromJson(JsonMap json)
    : from = readString(json['from']),
      to = readString(json['to']);

  final String from;
  final String to;

  TimeInterval toDomain() => TimeInterval(from: from, to: to);
}

class EmployeeScheduleDto {
  EmployeeScheduleDto.fromJson(JsonMap json)
    : id = readInt(json['id']),
      employeeId = readInt(json['employeeId']),
      employee = EmployeeSummaryDto.fromJson(readMap(json['employee'])),
      date = readDate(json['date']),
      intervals = (json['intervals'] as List? ?? const [])
          .map((item) => TimeIntervalDto.fromJson(readMap(item)))
          .toList();

  final int id;
  final int employeeId;
  final EmployeeSummaryDto employee;
  final DateTime date;
  final List<TimeIntervalDto> intervals;

  EmployeeSchedule toDomain() => EmployeeSchedule(
    id: id,
    employeeId: employeeId,
    employee: employee.toDomain(),
    date: date,
    intervals: intervals.map((item) => item.toDomain()).toList(),
  );
}

class EmployeeScheduleItemDto {
  EmployeeScheduleItemDto.fromJson(JsonMap json)
    : employee = EmployeeSummaryDto.fromJson(readMap(json['employee'])),
      intervals = (json['intervals'] as List? ?? const [])
          .map((item) => TimeIntervalDto.fromJson(readMap(item)))
          .toList();

  final EmployeeSummaryDto employee;
  final List<TimeIntervalDto> intervals;

  EmployeeScheduleItem toDomain() => EmployeeScheduleItem(
    employee: employee.toDomain(),
    intervals: intervals.map((item) => item.toDomain()).toList(),
  );
}

class EmployeeScheduleDayDto {
  EmployeeScheduleDayDto.fromJson(JsonMap json)
    : date = readDate(json['date']),
      employees = (json['employees'] as List? ?? const [])
          .map((item) => EmployeeScheduleItemDto.fromJson(readMap(item)))
          .toList();

  final DateTime date;
  final List<EmployeeScheduleItemDto> employees;

  EmployeeScheduleDay toDomain() => EmployeeScheduleDay(
    date: date,
    employees: employees.map((item) => item.toDomain()).toList(),
  );
}

class FavoriteProcedureDto {
  FavoriteProcedureDto.fromJson(JsonMap json)
    : id = readString(json['id']),
      title = readString(json['title']),
      description = readString(json['description']),
      duration = readString(json['duration']),
      price = readDouble(json['price']);

  final String id;
  final String title;
  final String description;
  final String duration;
  final double price;

  FavoriteProcedure toDomain() => FavoriteProcedure(
    id: id,
    title: title,
    description: description,
    duration: duration,
    price: price,
  );
}

class SpaProcedureDto {
  SpaProcedureDto.fromJson(JsonMap json)
    : id = readInt(json['id']),
      slug = readNullableString(json['slug']),
      name = readString(json['name']),
      description = readString(json['description']),
      durationMinutes = readInt(json['duration']),
      price = readDouble(json['price']),
      groupId = readNullableInt(json['spaProcedureGroupId']),
      availableEmployeeIds = readIntList(json['availableEmployeeIds']),
      audit = AuditDto.fromJson(json);

  final int id;
  final String? slug;
  final String name;
  final String description;
  final int durationMinutes;
  final double price;
  final int? groupId;
  final List<int> availableEmployeeIds;
  final AuditDto audit;

  SpaProcedure toDomain() => SpaProcedure(
    id: id,
    slug: slug,
    name: name,
    description: description,
    durationMinutes: durationMinutes,
    price: price,
    groupId: groupId,
    availableEmployeeIds: availableEmployeeIds,
    audit: audit.toDomain(),
  );
}

class SpaProcedureGroupDto {
  SpaProcedureGroupDto.fromJson(JsonMap json)
    : id = readInt(json['id']),
      name = readString(json['name']),
      description = readString(json['description']),
      audit = AuditDto.fromJson(json);

  final int id;
  final String name;
  final String description;
  final AuditDto audit;

  SpaProcedureGroup toDomain() => SpaProcedureGroup(
    id: id,
    name: name,
    description: description,
    audit: audit.toDomain(),
  );
}

class FavoriteGroupDto {
  FavoriteGroupDto.fromJson(JsonMap json)
    : id = readInt(json['id']),
      title = readString(json['title']),
      procedures = (json['procedures'] as List? ?? const [])
          .map((item) => FavoriteProcedureDto.fromJson(readMap(item)))
          .toList(),
      createdAt = readDate(json['createdAt']),
      updatedAt = readDate(json['updatedAt']);

  final int id;
  final String title;
  final List<FavoriteProcedureDto> procedures;
  final DateTime createdAt;
  final DateTime updatedAt;

  ApiFavoriteGroup toDomain() => ApiFavoriteGroup(
    id: id,
    title: title,
    procedures: procedures.map((item) => item.toDomain()).toList(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

class AppointmentDto {
  AppointmentDto.fromJson(JsonMap json)
    : id = readInt(json['id']),
      employeeIds = readIntList(json['employeeIds']),
      clientId = readInt(json['clientId']),
      spaProcedureId = readInt(json['spaProcedureId']),
      startAt = readDate(json['startAt']),
      endAt = readDate(json['endAt']),
      status = readString(json['status']),
      cabinet = readNullableString(json['cabinet']),
      comment = readNullableString(json['comment']),
      audit = AuditDto.fromJson(json);

  final int id;
  final List<int> employeeIds;
  final int clientId;
  final int spaProcedureId;
  final DateTime startAt;
  final DateTime endAt;
  final String status;
  final String? cabinet;
  final String? comment;
  final AuditDto audit;

  Appointment toDomain() => Appointment(
    id: id,
    employeeIds: employeeIds,
    clientId: clientId,
    spaProcedureId: spaProcedureId,
    startAt: startAt,
    endAt: endAt,
    status: status,
    cabinet: cabinet,
    comment: comment,
    audit: audit.toDomain(),
  );
}

class AuthResponseDto {
  AuthResponseDto.fromJson(JsonMap json)
    : accessToken = readString(json['accessToken']),
      refreshToken = readString(json['refreshToken']),
      user = UserDto.fromJson(readMap(json['user']));

  final String accessToken;
  final String refreshToken;
  final UserDto user;

  AuthSession toDomain() => AuthSession(
    accessToken: accessToken,
    refreshToken: refreshToken,
    user: user.toDomain(),
  );
}

class StoredFileDto {
  StoredFileDto.fromJson(JsonMap json)
    : id = readInt(json['id']),
      originalName = readString(json['originalName']),
      mimeType = readString(json['mimeType']),
      size = readInt(json['size']),
      uploadedByUserId = readInt(json['uploadedByUserId']),
      createdAt = readDate(json['createdAt']),
      url = readString(json['url']);

  final int id;
  final String originalName;
  final String mimeType;
  final int size;
  final int uploadedByUserId;
  final DateTime createdAt;
  final String url;

  StoredFile toDomain() => StoredFile(
    id: id,
    originalName: originalName,
    mimeType: mimeType,
    size: size,
    uploadedByUserId: uploadedByUserId,
    createdAt: createdAt,
    url: url,
  );
}

class SpaChatMessageDto {
  SpaChatMessageDto.fromJson(JsonMap json)
    : id = readInt(json['id']),
      chatId = readInt(json['chatId']),
      author = readMap(json['author']),
      text = readString(json['text']),
      createdAt = readDate(json['createdAt']),
      attachments = (json['attachments'] as List? ?? const [])
          .map((item) => readMap(item))
          .toList();

  final int id;
  final int chatId;
  final JsonMap author;
  final String text;
  final DateTime createdAt;
  final List<JsonMap> attachments;

  SpaChatMessage toDomain() => SpaChatMessage(
    id: id.toString(),
    authorId: readInt(author['id']).toString(),
    text: text,
    createdAt: createdAt,
    attachments: attachments.map(_attachmentToDomain).toList(),
    chatId: chatId,
  );

  static SpaChatAttachment _attachmentToDomain(JsonMap json) {
    final id = readInt(json['id']).toString();
    return switch (readString(json['type'])) {
      'file' => _fileAttachment(id, readMap(json['file'])),
      'spaProcedure' => _procedureAttachment(id, readMap(json['spaProcedure'])),
      'favoriteGroup' => _favoriteGroupAttachment(
        id,
        readMap(json['favoriteGroup']),
      ),
      _ => SpaChatAttachment(
        id: id,
        type: SpaChatAttachmentType.image,
        title: 'Вложение',
      ),
    };
  }

  static SpaChatAttachment _fileAttachment(String id, JsonMap file) {
    return SpaChatAttachment(
      id: id,
      type: SpaChatAttachmentType.image,
      title: readString(file['originalName'], 'Файл'),
      subtitle: readString(file['mimeType']),
      fileId: readInt(file['id']),
      imageUrl: readString(file['url']),
    );
  }

  static SpaChatAttachment _procedureAttachment(String id, JsonMap procedure) {
    final duration = readInt(procedure['duration']);
    final price = readDouble(procedure['price']);
    return SpaChatAttachment(
      id: id,
      type: SpaChatAttachmentType.procedure,
      title: readString(procedure['name']),
      subtitle: '$duration мин · ${price.toStringAsFixed(0)} ₽',
      procedureId:
          readNullableString(procedure['slug']) ??
          readInt(procedure['id']).toString(),
      spaProcedureId: readInt(procedure['id']),
    );
  }

  static SpaChatAttachment _favoriteGroupAttachment(String id, JsonMap group) {
    final groupId = readInt(group['id']);
    return SpaChatAttachment(
      id: id,
      type: SpaChatAttachmentType.favoriteGroup,
      title: readString(group['title']),
      favoriteGroupId: groupId.toString(),
      favoriteGroupApiId: groupId,
    );
  }
}

class SpaChatDto {
  SpaChatDto.fromJson(JsonMap json)
    : id = readInt(json['id']),
      status = readString(json['status']),
      participants = (json['participants'] as List? ?? const [])
          .map((item) => readMap(item))
          .toList(),
      unreadCount = readInt(json['unreadCount']),
      createdAt = readDate(json['createdAt']),
      updatedAt = readDate(json['updatedAt']),
      lastMessageAt = readNullableDate(json['lastMessageAt']),
      lastMessage = json['lastMessage'] == null
          ? null
          : SpaChatMessageDto.fromJson(readMap(json['lastMessage']));

  final int id;
  final String status;
  final List<JsonMap> participants;
  final int unreadCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastMessageAt;
  final SpaChatMessageDto? lastMessage;

  SpaChat toDomain() => SpaChat(
    id: id,
    status: status,
    participants: participants.map((participant) {
      final role = readString(participant['role']);
      return SpaChatParticipant(
        id: readInt(participant['id']).toString(),
        name: readString(participant['name']),
        role: role == 'guest'
            ? SpaChatParticipantRole.client
            : SpaChatParticipantRole.admin,
      );
    }).toList(),
    unreadCount: unreadCount,
    createdAt: createdAt,
    updatedAt: updatedAt,
    lastMessageAt: lastMessageAt,
    lastMessage: lastMessage?.toDomain(),
  );
}

class PageDto<T> {
  const PageDto({required this.total, required this.items});

  final int total;
  final List<T> items;
}
