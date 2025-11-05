enum Gender{male, female}
enum RoomType{ACU, VIP, WARD}

class Department{
  final String id;
  final String name;
  final List<Room> rooms = [];

  Department(this.id, this.name);

  List<Room> listRooms(){
    return rooms;
  }

  void addRoom(Room room){
    rooms.add(room);
  }

  void removeRoom(Room room){
    rooms.remove(room);
  }
}

class Patient{
  final String id;
  final String name;
  final int age;
  final Gender gender;
  final List<Admission> admissions = [];

  Patient(this.id, this.name, this.age, this.gender);

  List<Admission> viewAdmissionHistory(){
    return admissions;
  }
}

class Bed{
  final String id;
  final String bedNumber;
  bool isFree;

  Bed({required this.id, required this.bedNumber, this.isFree = true});

}

class Room{
  final String id;
  final String roomNO;
  final RoomType type;
  final List<Bed> beds = [];

  Room(this.id, this.roomNO, this.type);

  List<Bed> availableBeds(){
    return beds;
  }
  List<Bed> allBeds(){
    return beds;
  }
}

class Admission{
  final String id;
  final DateTime admissionDate;
  DateTime? dischargeDate;

  Patient? patient;
  Bed? bed;

  Admission({
    required this.id,
    required this.admissionDate,
    this.dischargeDate,
  });

  void assignBed(Bed bed, Patient patient){

    if(this.bed != null){
      this.bed!.isFree = true;
    }

    this.bed = bed;
    this.patient = patient;

    bed.isFree = false;

    if(!patient.admissions.contains(this)){
      patient.admissions.add(this);
    }
  }

  void discharge(){
    if(bed != null){
      bed!.isFree = true;
    }
    dischargeDate = DateTime.now();
  }

  void transferBed(Bed newBed){
    if(bed != null){
      bed!.isFree = true;
    }
    bed = newBed;
    newBed.isFree = false;
  }
}


