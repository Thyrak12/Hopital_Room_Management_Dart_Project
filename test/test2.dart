import 'package:test/test.dart';
import '../lib/domain/new.dart';
import 'dart:convert';

void main() {
  late Department dep;
  late Room room1;
  late Room room2;
  late Bed bed1;
  late Bed bed2;
  late Patient patient;

  setUp(() {
    dep = Department("Cardiology");
    room1 = Room("101", RoomType.WARD);
    room2 = Room("102", RoomType.ACU);
    bed1 = Bed(bedNumber: "B1");
    bed2 = Bed(bedNumber: "B2");
    room1.addBed(bed1);
    room2.addBed(bed2);
    dep.addRoom(room1);
    dep.addRoom(room2);
    patient = Patient("Bob", 30);
  });

  test('Add Room into Department', () {
    var d = Department("Surgery");
    var r = Room("201", RoomType.VIP);
    d.addRoom(r);
    expect(d.rooms.length, 1);
    expect(d.rooms.first.roomNO, "201");
  });

  test('Remove Room in Department by id', () {
    var d = Department("ICU");
    var r1 = Room("301", RoomType.ACU);
    var r2 = Room("302", RoomType.WARD);

    d.addRoom(r1);
    d.addRoom(r2);

    d.removeRoom(r1); // remove by object (you compare id inside)

    expect(d.rooms.length, 1);
    expect(d.rooms.first.roomNO, "302");
  });

  test('Add bed to room', () {
    room1.addBed(bed1);
    expect(room1.beds.contains(bed1), true);
    expect(room1.allBeds().length, 1);
  });

  test('Remove bed from room', () {
    room1.addBed(bed1);
    room1.addBed(bed2);
    room1.removeBed(bed1.id);
    expect(room1.beds.contains(bed1), false);
    expect(room1.beds.contains(bed2), true);
    expect(room1.allBeds().length, 1);
  });

  test('Available beds', () {
    room1.addBed(bed1);
    room1.addBed(bed2);

    // Mark bed2 as occupied
    bed2.isFree = false;

    var freeBeds = room1.availableBeds();
    expect(freeBeds.contains(bed1), true);
    expect(freeBeds.contains(bed2), false);
    expect(freeBeds.length, 1);
  });

  test('All beds in room', () {
    room1.addBed(bed1);
    room1.addBed(bed2);
    var allBeds = room1.allBeds();
    expect(allBeds.length, 2);
    expect(allBeds.contains(bed1), true);
    expect(allBeds.contains(bed2), true);
  });

  test('Assign and free bed via patient', () {
    room1.addBed(bed1);
    var patient = Patient("Alice", 25);

    // Assign bed
    patient.assignBed(bed1);
    expect(bed1.isFree, false);
    expect(patient.currentBedId, bed1.id);

    // Discharge patient
    patient.discharge(bed1);
    expect(bed1.isFree, true);
    expect(patient.currentBedId, null);
  });

  test('Transfer patient between beds', () {
    // Assign initial bed
    patient.assignBed(bed1);
    expect(bed1.isFree, false);
    expect(patient.currentBedId, bed1.id);

    // Transfer to new bed
    patient.transferBed(bed2, bed1);
    expect(bed1.isFree, true);
    expect(bed2.isFree, false);
    expect(patient.currentBedId, bed2.id);
  });

  test('Multiple rooms in a department', () {
    expect(dep.rooms.length, 2);
    expect(dep.rooms.contains(room1), true);
    expect(dep.rooms.contains(room2), true);

    // Remove a room
    dep.removeRoom(room1);
    expect(dep.rooms.contains(room1), false);
    expect(dep.rooms.length, 1);
  });

}
