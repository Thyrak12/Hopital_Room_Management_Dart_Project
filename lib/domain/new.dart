import 'package:uuid/uuid.dart';

var uuid = Uuid();

enum RoomType { ACU, VIP, WARD }

class Department {
  final String id = uuid.v4();
  final String name;
  final List<Room> rooms = [];

  Department(this.name);

  List<Room> listRooms() => rooms;

  void addRoom(Room room) => rooms.add(room);

  void removeRoom(Room room) => rooms.remove(room);
}

class Patient {
  final String id = uuid.v4();
  final String name;
  final int age;

  Bed? currentBed;
  DateTime? admissionDate;
  DateTime? dischargeDate;

  Patient(this.name, this.age);

  void assignBed(Bed bed) {
    if (bed.isFree == false) {
      throw Exception('Bed is occupied, please choose another');
    }
    currentBed = bed;
    bed.isFree = false;
    admissionDate = DateTime.now();
  }

  void discharge() {
    if (currentBed != null) {
      currentBed!.isFree = true;
      currentBed = null;
      dischargeDate = DateTime.now();
    }
  }

  void transferBed(Bed newBed) {
    if (currentBed != null) {
      currentBed!.isFree = true;
    }
    currentBed = newBed;
    newBed.isFree = false;
  }
}

class Bed {
  final String id = uuid.v4();
  final String bedNumber;
  bool isFree;

  Bed({required this.bedNumber, this.isFree = true});
}

class Room {
  final String id = uuid.v4();
  final String roomNO;
  final RoomType type;
  final List<Bed> beds = [];

  Room(this.roomNO, this.type);

  List<Bed> availableBeds() => beds.where((b) => b.isFree).toList();

  List<Bed> allBeds() => beds;
}
