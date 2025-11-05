import '../domain/new.dart';

class PatientData {
  static List<Patient> mockPatients = [
    Patient("John", 23),
    Patient("Lisa", 30),
    Patient("Michael", 18),
    Patient("Sara", 25),
    Patient("David", 50),
  ];
}

class DepartmentData {
  static List<Department> mockDepartments = [
    Department("Heart"),
    Department("Ear"),
    Department("Brain"),
    Department("Lung"),
    Department("Kidney"),
  ];
}
