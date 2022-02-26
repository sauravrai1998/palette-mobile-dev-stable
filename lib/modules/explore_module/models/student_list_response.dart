class StudentListModel {
  StudentListModel({
    this.statusCode,
    this.modelList,
  });

  int? statusCode;
  List<StudentByInstitute>? modelList;

  factory StudentListModel.fromJson(Map<String, dynamic> json) =>
      StudentListModel(
        statusCode: json["statusCode"],
        modelList: List<StudentByInstitute>.from(
            json["data"].map((x) => StudentByInstitute.fromJson(x))),
      );
}

class StudentByInstitute {
  StudentByInstitute(
      {this.name,
      this.id,
      this.instituteName,
      this.instituteId,
      this.status,
      this.profilePicture,
      this.role});

  String? name;
  String? id;
  String? instituteName;
  String? instituteId;
  String? profilePicture;
  String? status;
  String? role;
  bool? isSelected = false;

  factory StudentByInstitute.fromJson(Map<String, dynamic> json) =>
      StudentByInstitute(
        name: json["name"],
        id: json["Id"],
        instituteId: json['instituteId'],
        instituteName: json['instituteName'],
        status: json['status'],
        profilePicture:
            json['profilePicture'] == null ? null : json['profilePicture'],
        role: json['role'],
      );
}
