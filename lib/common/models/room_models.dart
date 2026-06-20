import 'common_models.dart';

class Room {
  const Room({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.bedCount,
    required this.price,
    required this.audit,
    this.description,
  });

  final int id;
  final String name;
  final String type;
  final int capacity;
  final int bedCount;
  final double price;
  final String? description;
  final AuditData audit;
}

class CreateRoom {
  const CreateRoom({
    required this.name,
    required this.type,
    required this.capacity,
    required this.bedCount,
    required this.price,
    this.description,
  });

  final String name;
  final String type;
  final int capacity;
  final int bedCount;
  final double price;
  final String? description;
}

class UpdateRoom {
  const UpdateRoom({
    this.name,
    this.type,
    this.capacity,
    this.bedCount,
    this.price,
    this.description,
  });

  final String? name;
  final String? type;
  final int? capacity;
  final int? bedCount;
  final double? price;
  final String? description;
}
