class AdminStudent {
  AdminStudent({
    required this.statusCode,
    required this.data,
  });

  int statusCode;
  Data data;

  factory AdminStudent.fromJson(Map<String, dynamic> json) => AdminStudent(
        statusCode: json["statusCode"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.students,
    required this.mentors,
    required this.parents,
  });

  List<Student> students;
  List<Mentor> mentors;
  List<Parent> parents;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        students: List<Student>.from(
            json["students"].map((x) => Student.fromJson(x))),
        mentors:
            List<Mentor>.from(json["mentors"].map((x) => Mentor.fromJson(x))),
        parents:
            List<Parent>.from(json["parents"].map((x) => Parent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "students": List<dynamic>.from(students.map((x) => x.toJson())),
        "mentors": List<dynamic>.from(mentors.map((x) => x.toJson())),
        "parents": List<dynamic>.from(parents.map((x) => x.toJson())),
      };
}

class Mentor {
  Mentor(
      {required this.id,
      required this.name,
      required this.instituteName,
      required this.designation,
      this.profilePicture});

  String id;
  String name;
  String instituteName;
  String? designation;
  String? profilePicture;

  factory Mentor.fromJson(Map<String, dynamic> json) => Mentor(
        id: json["Id"],
        name: json["name"],
        instituteName: json["instituteName"],
        designation: json["designation"] == null ? '' : json["designation"],
        profilePicture:
            json["profilePicture"] == null ? '' : json["profilePicture"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "name": name,
        "instituteName": instituteName,
        "designation": designation,
        "profilePicture": profilePicture,
      };
}

class Parent {
  Parent({
    required this.id,
    required this.name,
    required this.instituteName,
  });

  String id;
  String name;
  String instituteName;

  factory Parent.fromJson(Map<String, dynamic> json) => Parent(
        id: json["Id"],
        name: json["name"],
        instituteName: json["instituteName"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "name": name,
        "instituteName": instituteName,
      };
}

class Student {
  Student({
    required this.id,
    required this.name,
    required this.institute,
    required this.grade,
    this.profilePicture,
  });

  String id;
  String name;
  String institute;
  String? grade;
  String? profilePicture;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["Id"],
        name: json["name"],
        institute: json["institute"],
        grade: json["grade"] == null ? null : json["grade"],
        profilePicture:
            json["profilePicture"] == null ? null : json["profilePicture"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "name": name,
        "institute": institute,
        "grade": grade,
        "profilePicture": profilePicture,
      };
}
class CommonStudentMentor {
  CommonStudentMentor({
    required this.id,
    required this.name,
    required this.institute,
    this.grade,
    this.profilePicture,
    this.designation,
    this.role
  });

  String id;
  String name;
  String institute;
  String? grade;
  String? profilePicture;
  String? designation;
  String? role;
}
