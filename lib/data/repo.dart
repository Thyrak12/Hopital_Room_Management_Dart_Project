import 'dart:convert';
import 'dart:io';
import '../domain/new.dart';


class DepartmentRepository {
  final String filePath;
  List<Department> departments = [];

  DepartmentRepository(this.filePath);

  void load() {
    if (!File(filePath).existsSync()) return;
    var jsonString = File(filePath).readAsStringSync();
    var list = json.decode(jsonString) as List;
    departments = list.map((d) => Department.fromJson(d)).toList();
  }

  void save() {
    File(filePath).writeAsStringSync(
      json.encode(departments.map((d) => d.toJson()).toList()),
    );
  }
}

class PatientRepository {
  final String filePath;
  List<Patient> patients = [];

  PatientRepository(this.filePath);

  void load() {
    if (!File(filePath).existsSync()) {
      patients = [];
      return;
    }
    var jsonData = File(filePath).readAsStringSync();
    var list = json.decode(jsonData) as List;
    patients = list.map((p) => Patient.fromJson(p)).toList();
  }

  void save() {
    var jsonData = json.encode(patients.map((p) => p.toJson()).toList());
    File(filePath).writeAsStringSync(jsonData);
  }

  void add(Patient patient) {
    patients.add(patient);
    save();
  }

  void remove(Patient patient) {
    patients.removeWhere((p) => p.id == patient.id);
    save();
  }
}

class RoomRepository {
  final String filePath;
  List<Room> rooms = [];

  RoomRepository(this.filePath);

  void load() {
    final file = File(filePath);
    if (!file.existsSync()) {
      rooms = [];
      return;
    }
    final jsonStr = file.readAsStringSync();
    final jsonData = json.decode(jsonStr) as List;
    rooms = jsonData.map((r) => Room.fromJson(r)).toList();
  }

  void save() {
    final jsonStr = json.encode(rooms.map((r) => r.toJson()).toList());
    File(filePath).writeAsStringSync(jsonStr);
  }
}

class BedRepository {
  final String filePath;
  List<Bed> beds = [];

  BedRepository(this.filePath);

  void load() {
    final file = File(filePath);
    if (!file.existsSync()) {
      beds = [];
      return;
    }
    final jsonStr = file.readAsStringSync();
    final jsonData = json.decode(jsonStr) as List;
    beds = jsonData.map((b) => Bed.fromJson(b)).toList();
  }

  void save() {
    final jsonStr = json.encode(beds.map((b) => b.toJson()).toList());
    File(filePath).writeAsStringSync(jsonStr);
  }
}

