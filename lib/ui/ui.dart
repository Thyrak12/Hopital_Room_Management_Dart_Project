import 'dart:io';
import '../domain/new.dart';
import '../data/data.dart';

class HospitalUI {
  final List<Patient> patients = PatientData.mockPatients;
  final List<Department> departments = DepartmentData.mockDepartments;

  void start() {
    while (true) {
      print("\n=== Hospital Room Management ===");
      print("1. Add Room");
      print("2. Remove Room");
      print("3. Add Bed to Room");
      print("4. Assign Bed to Patient");
      print("5. Discharge Patient");
      print("6. Transfer Patient to Another Bed");
      print("7. List Departments / Rooms / Beds");
      print("8. List Patients");
      print("0. Exit");
      stdout.write("> ");
      var input = stdin.readLineSync();

      switch (input) {
        case "1": addRoomUI(); break;
        case "2": removeRoomUI(); break;
        case "3": addBedUI(); break;
        case "4": assignBedUI(); break;
        case "5": dischargePatientUI(); break;
        case "6": transferPatientUI(); break;
        case "7": listStructure(); break;
        case "8": listPatients(); break;
        case "0": return;
        default: print("Invalid option");
      }
    }
  }

  // ----- Helpers -----
  Department? pickDepartment() {
    print("Departments: ${departments.map((d) => d.name).join(", ")}");
    stdout.write("Enter department name: ");
    var depName = stdin.readLineSync()!;
    try {
      return departments.firstWhere(
          (d) => d.name.toLowerCase() == depName.toLowerCase());
    } catch (_) {
      print("Department not found");
      return null;
    }
  }

  Room? pickRoom(Department dep) {
    if (dep.rooms.isEmpty) {
      print("No rooms in ${dep.name}");
      return null;
    }
    print("Rooms in ${dep.name}: ${dep.rooms.map((r) => r.roomNO).join(", ")}");
    stdout.write("Enter room number: ");
    var rn = stdin.readLineSync()!;
    try {
      return dep.rooms.firstWhere((r) => r.roomNO == rn);
    } catch (_) {
      print("Room not found");
      return null;
    }
  }

  Bed? pickBed(Room room) {
    var freeBeds = room.availableBeds();
    if (freeBeds.isEmpty) {
      print("No free beds in this room");
      return null;
    }
    print("Free beds: ${freeBeds.map((b) => b.bedNumber).join(", ")}");
    stdout.write("Enter bed number: ");
    var bn = stdin.readLineSync()!;
    try {
      return freeBeds.firstWhere((b) => b.bedNumber == bn);
    } catch (_) {
      print("Bed not found");
      return null;
    }
  }

  Patient? pickPatient() {
    print("Patients: ${patients.map((p) => p.name).join(", ")}");
    stdout.write("Enter patient name: ");
    var n = stdin.readLineSync()!;
    try {
      return patients.firstWhere(
          (p) => p.name.toLowerCase() == n.toLowerCase());
    } catch (_) {
      print("Patient not found");
      return null;
    }
  }

  // ----- UI Actions -----
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
    print("Room removed ✅");
  }

  void addBedUI() {
    var dep = pickDepartment();
    if (dep == null) return;

    var room = pickRoom(dep);
    if (room == null) return;

    stdout.write("Bed number: ");
    var bn = stdin.readLineSync()!;
    room.beds.add(Bed(bedNumber: bn));
    print("Bed added ✅");
  }

  void assignBedUI() {
    var p = pickPatient();
    if (p == null) return;

    var dep = pickDepartment();
    if (dep == null) return;

    var room = pickRoom(dep);
    if (room == null) return;

    var bed = pickBed(room);
    if (bed == null) return;

    p.assignBed(bed);
    print("Bed assigned ✅");
  }

  void dischargePatientUI() {
    var p = pickPatient();
    if (p == null) return;

    p.discharge();
    print("Patient discharged ✅");
  }

  void transferPatientUI() {
    var p = pickPatient();
    if (p == null) return;

    print("Select the new department and room for the patient:");
    var dep = pickDepartment();
    if (dep == null) return;

    var room = pickRoom(dep);
    if (room == null) return;

    var bed = pickBed(room);
    if (bed == null) return;

    p.transferBed(bed);
    print("Patient transferred to bed ${bed.bedNumber} in room ${room.roomNO} ✅");
  }

  void listStructure() {
    for (var dep in departments) {
      print("\nDepartment: ${dep.name}");
      for (var r in dep.rooms) {
        print("  Room ${r.roomNO} (${r.type})");
        for (var b in r.beds) {
          print("    Bed ${b.bedNumber}: ${b.isFree ? 'free' : 'occupied'}");
        }
      }
    }
  }

  void listPatients() {
    print("\nPatients:");
    for (var p in patients) {
      print("${p.name} (${p.currentBed?.bedNumber ?? 'no bed'})");
    }
  }
}
