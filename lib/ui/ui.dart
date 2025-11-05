import 'dart:io';
import '../domain/new.dart';

class HospitalSystem {
  final List<Department> departments = [];
  final List<Patient> patients = [];

  void start() {
    while (true) {
      print('\n=== Hospital Bed Allocation System ===');
      print('1. Create Department');
      print('2. Create Room');
      print('3. Create Bed');
      print('4. Create Patient');
      print('5. Assign Bed to Patient');
      print('6. Discharge Patient');
      print('7. List Departments, Rooms & Beds');
      print('8. List Patients');
      print('0. Exit');
      stdout.write('Choose option: ');
      var input = stdin.readLineSync();

      switch (input) {
        case '1':
          createDepartment();
          break;
        case '2':
          createRoom();
          break;
        case '3':
          createBed();
          break;
        case '4':
          createPatient();
          break;
        case '5':
          assignBed();
          break;
        case '6':
          dischargePatient();
          break;
        case '7':
          listStructure();
          break;
        case '8':
          listPatients();
          break;
        case '0':
          print('Bye!');
          return;
        default:
          print('Invalid option');
      }
    }
  }

  void createDepartment() {
    stdout.write('Enter Department name: ');
    var name = stdin.readLineSync()!;
    departments.add(Department(name));
    print('Department created');
  }

  void createRoom() {
    if (departments.isEmpty) {
      print('No departments. Create department first.');
      return;
    }

    print('Select Department:');
    for (int i = 0; i < departments.length; i++) {
      print('$i. ${departments[i].name}');
    }
    stdout.write('index: ');
    var idx = int.parse(stdin.readLineSync()!);

    stdout.write('Enter room number: ');
    var roomNo = stdin.readLineSync()!;

    print('Select RoomType: 0.ACU 1.VIP 2.WARD');
    var typeIdx = int.parse(stdin.readLineSync()!);

    var room = Room(roomNo, RoomType.values[typeIdx]);
    departments[idx].addRoom(room);

    print('Room created ✅');
  }

  void createBed() {
    var room = pickRoom();
    if (room == null) return;

    stdout.write('Enter bed number: ');
    var bNo = stdin.readLineSync()!;

    room.beds.add(Bed(bedNumber: bNo));
    print('Bed created ✅');
  }

  void createPatient() {
    stdout.write('Enter patient name: ');
    var name = stdin.readLineSync()!;

    stdout.write('Enter patient age: ');
    var age = int.parse(stdin.readLineSync()!);

    patients.add(Patient(name, age));
    print('Patient created ✅');
  }

  void assignBed() {
    if (patients.isEmpty) {
      print('No patients.');
      return;
    }

    print('Select Patient to assign:');
    for (int i = 0; i < patients.length; i++) {
      var p = patients[i];
      print('$i. ${p.name} (Bed: ${p.currentBed?.bedNumber ?? "none"})');
    }
    stdout.write('index: ');
    var pIdx = int.parse(stdin.readLineSync()!);

    var room = pickRoom();
    if (room == null) return;

    var freeBeds = room.availableBeds();
    if (freeBeds.isEmpty) {
      print('No free beds in this room.');
      return;
    }

    print('Select Bed:');
    for (int i = 0; i < freeBeds.length; i++) {
      print('$i. Bed ${freeBeds[i].bedNumber}');
    }
    stdout.write('index: ');
    var bIdx = int.parse(stdin.readLineSync()!);

    patients[pIdx].assignBed(freeBeds[bIdx]);
    print('Bed assigned ✅');
  }

  void dischargePatient() {
    listPatients();
    stdout.write('Select patient index: ');
    var idx = int.parse(stdin.readLineSync()!);

    patients[idx].discharge();
    print('Patient discharged ✅');
  }

  void listStructure() {
    for (var d in departments) {
      print('Department: ${d.name}');
      for (var r in d.rooms) {
        print('  Room ${r.roomNO} (${r.type})');
        for (var b in r.beds) {
          print('    Bed ${b.bedNumber} - ${b.isFree ? "Free" : "Occupied"}');
        }
      }
    }
  }

  void listPatients() {
    for (int i = 0; i < patients.length; i++) {
      var p = patients[i];
      print('$i. ${p.name} (Bed: ${p.currentBed?.bedNumber ?? "none"})');
    }
  }

  Room? pickRoom() {
    if (departments.isEmpty) {
      print('No departments yet.');
      return null;
    }

    print('Select Department:');
    for (int i = 0; i < departments.length; i++) {
      print('$i. ${departments[i].name}');
    }
    stdout.write('index: ');
    var dIdx = int.parse(stdin.readLineSync()!);

    if (departments[dIdx].rooms.isEmpty) {
      print('No rooms in this department.');
      return null;
    }

    print('Select Room:');
    for (int i = 0; i < departments[dIdx].rooms.length; i++) {
      var r = departments[dIdx].rooms[i];
      print('$i. Room ${r.roomNO}');
    }
    stdout.write('index: ');
    var rIdx = int.parse(stdin.readLineSync()!);

    return departments[dIdx].rooms[rIdx];
  }
}
