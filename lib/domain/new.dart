import 'package:uuid/uuid.dart';

var uuid = Uuid();

enum RoomType { ACU, VIP, WARD }

class Bed {
  final String id;
  final String bedNumber;
  bool isFree;

  Bed({String? id, required this.bedNumber, this.isFree = true})
      : id = id ?? uuid.v4();

  factory Bed.fromJson(Map<String, dynamic> json) => Bed(
        id: json['id'],
        bedNumber: json['bedNumber'] ?? 'Unknown',
        isFree: json['isFree'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'bedNumber': bedNumber,
        'isFree': isFree,
      };
}

class Room {
  final String id;
  final String roomNO;
  final RoomType type;
  final List<Bed> beds;

  Room(this.roomNO, this.type, {String? id, List<Bed>? beds})
      : id = id ?? uuid.v4(),
        beds = beds ?? [];

  // Add a new bed to the room
  void addBed(Bed bed) {
    beds.add(bed);
  }

  // Remove a bed from the room
  void removeBed(String bedId) {
    beds.removeWhere((b) => b.id == bedId);
  }

  // Return all available (free) beds
  List<Bed> availableBeds() => beds.where((b) => b.isFree).toList();

  // Return all beds in the room
  List<Bed> allBeds() => List<Bed>.from(beds);

  // JSON serialization
  factory Room.fromJson(Map<String, dynamic> json) => Room(
        json['roomNO'] ?? 'Unknown',
        RoomType.values.firstWhere(
            (r) => r.name == (json['type'] ?? 'WARD'),
            orElse: () => RoomType.WARD),
        id: json['id'],
        beds: (json['beds'] as List?)
                ?.map((bJson) => Bed.fromJson(bJson))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'roomNO': roomNO,
        'type': type.name,
        'beds': beds.map((b) => b.toJson()).toList(),
      };
}


class Department {
  final String id;
  final String name;
  final List<Room> rooms;

  Department(this.name, {String? id, List<Room>? rooms})
      : id = id ?? uuid.v4(),
        rooms = rooms ?? [];

  void addRoom(Room room) => rooms.add(room);
  void removeRoom(Room room) => rooms.removeWhere((r) => r.id == room.id);

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        json['name'] ?? 'Unknown',
        id: json['id'],
        rooms: (json['rooms'] as List?)
                ?.map((rJson) => Room.fromJson(rJson))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rooms': rooms.map((r) => r.toJson()).toList(),
      };
}

class Patient {
  final String id;
  final String name;
  final int age;
  String? currentBedId;
  DateTime? admissionDate;
  DateTime? dischargeDate;

  Patient(this.name, this.age, {String? id}) : id = id ?? uuid.v4();

  void assignBed(Bed bed) {
    if (!bed.isFree) throw Exception('Bed is occupied');
    currentBedId = bed.id;
    bed.isFree = false;
    admissionDate = DateTime.now();
  }

  void discharge(Bed? bed) {
    if (bed != null) {
      bed.isFree = true;
      currentBedId = null;
      dischargeDate = DateTime.now();
    }
  }

  void transferBed(Bed newBed, Bed? oldBed) {
    if (oldBed != null) oldBed.isFree = true;
    newBed.isFree = false;
    currentBedId = newBed.id;
  }

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        json['name'] ?? 'Unknown',
        json['age'] ?? 0,
        id: json['id'],
      )
        ..currentBedId = json['currentBedId']
        ..admissionDate = json['admissionDate'] != null
            ? DateTime.tryParse(json['admissionDate'])
            : null
        ..dischargeDate = json['dischargeDate'] != null
            ? DateTime.tryParse(json['dischargeDate'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'currentBedId': currentBedId,
        'admissionDate': admissionDate?.toIso8601String(),
        'dischargeDate': dischargeDate?.toIso8601String(),
      };
}
