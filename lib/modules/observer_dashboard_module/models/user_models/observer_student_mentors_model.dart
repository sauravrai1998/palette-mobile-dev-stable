class ObserverStudent {
  ObserverStudent({
    required this.statusCode,
    required this.data,
  });
  int statusCode;
  Data data;
  factory ObserverStudent.fromJson(
    Map<String, dynamic> json,
  ) =>
      ObserverStudent(
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
  });
  List<Student> students;
  List<Mentor> mentors;
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        students: List<Student>.from(
            json["students"].map((x) => Student.fromJson(x))),
        mentors:
            List<Mentor>.from(json["mentors"].map((x) => Mentor.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "students": List<dynamic>.from(students.map((x) => x.toJson())),
        "mentors": List<dynamic>.from(mentors.map((x) => x.toJson())),
      };
}

class Mentor {
  Mentor({
    required this.id,
    required this.name,
    this.designation,
    this.institute,
    this.profilePicture,
  });
  String id;
  String name;
  String? designation;
  String? institute;
  String? profilePicture;
  factory Mentor.fromJson(Map<String, dynamic> json) => Mentor(
        id: json["Id"],
        name: json["name"],
        designation: json["designation"],
        institute: json["institute"],
    profilePicture: json["profilePicture"],
      );
  Map<String, dynamic> toJson() => {
        "Id": id,
        "name": name,
        "designation": designation,
        "institute": institute,
    "profilePicture": profilePicture,
      };
}

class Student {
  Student({
    required this.id,
    required this.name,
    this.grade,
    this.profilePicture,
  });
  String id;
  String name;
  String? grade;
  String? profilePicture;
  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["Id"],
        name: json["name"],
        grade: json["grade"] == null ? null : json["grade"],
    profilePicture: json["profilePicture"] == null ? null : json["profilePicture"],
      );
  Map<String, dynamic> toJson() => {
        "Id": id,
        "name": name,
        "grade": grade,
    "profilePicture": profilePicture,
      };
}
