import 'dart:convert';
import 'dart:io';
import './data/repo.dart';
import './ui/ui.dart';

void main() {
  var depRepo = DepartmentRepository('lib/data/json/department.json');
  var patRepo = PatientRepository('lib/data/json/patient.json');
  var roomRepo = RoomRepository('lib/data/json/room.json');
  var bedRepo = BedRepository('lib/data/json/bed.json');
  var app = HospitalUI(depRepo: depRepo, patRepo: patRepo, roomRepo: roomRepo, bedRepo: bedRepo);
  app.start();
}
