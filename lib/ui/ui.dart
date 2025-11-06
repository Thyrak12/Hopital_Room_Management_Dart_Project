import 'dart:io';
import '../domain/new.dart';
import '../data/repo.dart';

class HospitalUI {
  final DepartmentRepository depRepo;
  final RoomRepository roomRepo;
  final BedRepository bedRepo;
  final PatientRepository patRepo;

  HospitalUI({
    required this.depRepo,
    required this.roomRepo,
    required this.bedRepo,
    required this.patRepo,
  }) {
    depRepo.load();
    roomRepo.load();
    bedRepo.load();
    patRepo.load();
  }

  void start() {
    while (true) {
      print("\n=== Hospital Management System ===");
      print("1. Add Department");
      print("2. Add Room");
      print("3. Remove Room");
      print("4. Add Bed");
      print("5. Remove Bed");
      print("6. Create Patient");
      print("7. Assign Bed to Patient");
      print("8. Discharge Patient");
      print("9. Transfer Patient");
      print("10. List Departments / Rooms / Beds");
      print("11. List Patients");
      print("0. Exit");
      stdout.write("> ");
      var input = stdin.readLineSync();

      switch (input) {
        case "1":
          addDepartmentUI();
          break;
        case "2":
          addRoomUI();
          break;
        case "3":
          removeRoomUI();
          break;
        case "4":
          addBedUI();
          break;
        case "5":
          removeBedUI();
          break;
        case "6":
          createPatientUI();
          break;
        case "7":
          assignBedUI();
          break;
        case "8":
          dischargePatientUI();
          break;
        case "9":
          transferPatientUI();
          break;
        case "10":
          listStructure();
          break;
        case "11":
          listPatients();
          break;
        case "0":
          return;
        default:
          print("Invalid option");
      }
    }
  }

  // ===== Helpers: pick by number =====
  Department? pickDepartment() {
    if (depRepo.departments.isEmpty) {
      print("No departments found.");
      return null;
    }
    print("Departments:");
    for (int i = 0; i < depRepo.departments.length; i++) {
      print("${i + 1}. ${depRepo.departments[i].name}");
    }
    stdout.write("Select department number: ");
    var choice = int.tryParse(stdin.readLineSync() ?? '');
    if (choice == null || choice < 1 || choice > depRepo.departments.length) {
      print("Invalid choice");
      return null;
    }
    return depRepo.departments[choice - 1];
  }

  Room? pickRoom(Department dep) {
    if (dep.rooms.isEmpty) {
      print("No rooms in ${dep.name}");
      return null;
    }
    print("Rooms in ${dep.name}:");
    for (int i = 0; i < dep.rooms.length; i++) {
      print("${i + 1}. ${dep.rooms[i].roomNO} (${dep.rooms[i].type})");
    }
    stdout.write("Select room number: ");
    var choice = int.tryParse(stdin.readLineSync() ?? '');
    if (choice == null || choice < 1 || choice > dep.rooms.length) {
      print("Invalid choice");
      return null;
    }
    return dep.rooms[choice - 1];
  }

  Bed? pickBed(Room room, {bool onlyFree = true}) {
    var beds = onlyFree ? room.availableBeds() : room.beds;
    if (beds.isEmpty) {
      print("No beds found.");
      return null;
    }
    print("Beds in room ${room.roomNO}:");
    for (int i = 0; i < beds.length; i++) {
      print(
          "${i + 1}. ${beds[i].bedNumber} (${beds[i].isFree ? 'free' : 'occupied'})");
    }
    stdout.write("Select bed number: ");
    var choice = int.tryParse(stdin.readLineSync() ?? '');
    if (choice == null || choice < 1 || choice > beds.length) {
      print("Invalid choice");
      return null;
    }
    return beds[choice - 1];
  }

  Patient? pickPatient() {
    if (patRepo.patients.isEmpty) {
      print("No patients found.");
      return null;
    }
    print("Patients:");
    for (int i = 0; i < patRepo.patients.length; i++) {
      print("${i + 1}. ${patRepo.patients[i].name}");
    }
    stdout.write("Select patient number: ");
    var choice = int.tryParse(stdin.readLineSync() ?? '');
    if (choice == null || choice < 1 || choice > patRepo.patients.length) {
      print("Invalid choice");
      return null;
    }
    return patRepo.patients[choice - 1];
  }

  // ===== UI Actions =====
  void addDepartmentUI() {
    stdout.write("Department name: ");
    var name = stdin.readLineSync()!;
    var dep = Department(name);
    depRepo.departments.add(dep);
    depRepo.save();
    print("Department '$name' added ✅");
  }

  void addRoomUI() {
    var dep = pickDepartment();
    if (dep == null) return;

    stdout.write("Room number: ");
    var rn = stdin.readLineSync()!;
    stdout.write("Room type (ACU/VIP/WARD): ");
    var tp = stdin.readLineSync()!.toUpperCase();
    try {
      var type = RoomType.values.firstWhere((t) => t.name == tp);
      var room = Room(rn, type);
      dep.addRoom(room);
      roomRepo.rooms.add(room);
      depRepo.save();
      roomRepo.save();
      print("Room added ✅");
    } catch (_) {
      print("Invalid room type");
    }
  }

  void removeRoomUI() {
    var dep = pickDepartment();
    if (dep == null) return;

    var room = pickRoom(dep);
    if (room == null) return;

    dep.removeRoom(room);
    roomRepo.rooms.removeWhere((r) => r.id == room.id);
    depRepo.save();
    roomRepo.save();
    print("Room removed ✅");
  }

  void addBedUI() {
    var dep = pickDepartment();
    if (dep == null) return;
    var room = pickRoom(dep);
    if (room == null) return;

    stdout.write("Bed number: ");
    var bn = stdin.readLineSync()!;
    var bed = Bed(bedNumber: bn);
    // room.beds.add(bed);
    room.addBed(bed);
    bedRepo.beds.add(bed);
    bedRepo.save();
    roomRepo.save();
    print("Bed added ✅");
  }


// ===== UI Actions: Remove Bed =====
  void removeBedUI() {
    var dep = pickDepartment();
    if (dep == null) return;
    var room = pickRoom(dep);
    if (room == null) return;

    var bed = pickBed(room, onlyFree: false); // allow picking any bed
    if (bed == null) return;

    room.removeBed(bed.id);
    bedRepo.beds.removeWhere((b) => b.id == bed.id);

    bedRepo.save();
    roomRepo.save();

    print("Bed '${bed.bedNumber}' removed from room ${room.roomNO} ✅");
  }

  void createPatientUI() {
    stdout.write("Patient name: ");
    var name = stdin.readLineSync()!;
    stdout.write("Patient age: ");
    var age = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
    var patient = Patient(name, age);
    patRepo.patients.add(patient);
    patRepo.save();
    print("Patient created ✅");
  }

  void assignBedUI() {
    var patient = pickPatient();
    if (patient == null) return;
    var dep = pickDepartment();
    if (dep == null) return;
    var room = pickRoom(dep);
    if (room == null) return;
    var bed = pickBed(room);
    if (bed == null) return;

    patient.assignBed(bed);
    patRepo.save();
    bedRepo.save();
    print("Bed assigned ✅");
  }

  void dischargePatientUI() {
    var patient = pickPatient();
    if (patient == null) return;

    var bed = bedRepo.beds.firstWhere(
      (b) => b.id == patient.currentBedId,
      orElse: () => null as Bed,
    );
    patient.discharge(bed);
    patRepo.save();
    bedRepo.save();
    print("Patient discharged ✅");
  }

  void transferPatientUI() {
    var patient = pickPatient();
    if (patient == null) return;

    var oldBed = bedRepo.beds.firstWhere(
      (b) => b.id == patient.currentBedId,
      orElse: () => null as Bed,
    );

    var dep = pickDepartment();
    if (dep == null) return;
    var newRoom = pickRoom(dep);
    if (newRoom == null) return;
    var newBed = pickBed(newRoom);
    if (newBed == null) return;

    patient.transferBed(newBed, oldBed);
    patRepo.save();
    bedRepo.save();
    print("Patient transferred ✅");
  }

  void listStructure() {
    print("\n=== Hospital Structure ===");
    for (var dep in depRepo.departments) {
      print("Department: ${dep.name}");
      for (var r in dep.rooms) {
        print("  Room ${r.roomNO} (${r.type})");
        for (var b in r.beds) {
          print("    Bed ${b.bedNumber}: ${b.isFree ? 'free' : 'occupied'}");
        }
      }
    }
  }

  void listPatients() {
    print("\n=== Patients ===");
    for (var p in patRepo.patients) {
      print("${p.name} (${p.currentBedId ?? 'no bed'})");
    }
  }
}
