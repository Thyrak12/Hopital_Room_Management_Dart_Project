import 'dart:io';
import 'package:test/test.dart';
import '../lib/data/repo.dart';
import '../lib/domain/new.dart';

void main() {

  group('DepartmentRepository', () {
    late DepartmentRepository repo;
    late String path;

    setUp(() {
      path = 'test_departments.json';
      if (File(path).existsSync()) File(path).deleteSync();
      repo = DepartmentRepository(path);
    });

    test('Save and load department', () {
      var d = Department("Cardiology");
      repo.departments.add(d);
      repo.save();

      var repo2 = DepartmentRepository(path)..load();
      expect(repo2.departments.length, 1);
      expect(repo2.departments.first.name, "Cardiology");
    });
  });

  group('PatientRepository', () {
    late PatientRepository repo;
    late String path;

    setUp(() {
      path = 'test_patients.json';
      if (File(path).existsSync()) File(path).deleteSync();
      repo = PatientRepository(path);
    });

    test('Add + save patient', () {
      var p = Patient("Anna", 22);
      repo.add(p);

      var repo2 = PatientRepository(path)..load();
      expect(repo2.patients.length, 1);
      expect(repo2.patients.first.name, "Anna");
    });

    test('Remove patient', () {
      var p = Patient("Bill", 30);
      repo.add(p);
      repo.remove(p);
      expect(repo.patients.isEmpty, true);
    });
  });

  group('RoomRepository', () {
    late RoomRepository repo;
    late String path;

    setUp(() {
      path = 'test_rooms.json';
      if (File(path).existsSync()) File(path).deleteSync();
      repo = RoomRepository(path);
    });

    test('Save + load rooms', () {
      var r = Room("101", RoomType.WARD);
      repo.rooms.add(r);
      repo.save();

      var repo2 = RoomRepository(path)..load();
      expect(repo2.rooms.length, 1);
      expect(repo2.rooms.first.roomNO, "101");
    });
  });

  group('BedRepository', () {
    late BedRepository repo;
    late String path;

    setUp(() {
      path = 'test_beds.json';
      if (File(path).existsSync()) File(path).deleteSync();
      repo = BedRepository(path);
    });

    test('Save + load beds', () {
      var b = Bed(bedNumber: "B1");
      repo.beds.add(b);
      repo.save();

      var repo2 = BedRepository(path)..load();
      expect(repo2.beds.length, 1);
      expect(repo2.beds.first.bedNumber, "B1");
    });
  });

}
