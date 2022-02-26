class ShareUserListModel {
  ShareUserListModel({
    this.statusCode,
    this.modelList,
  });

  int? statusCode;
  List<ShareUserByInstitute>? modelList;

  factory ShareUserListModel.fromJson(Map<String, dynamic> json) =>
      ShareUserListModel(
        statusCode: json["statusCode"],
        modelList: List<ShareUserByInstitute>.from(
            json["data"].map((x) => ShareUserByInstitute.fromJson(x))),
      );
}

class ShareUserByInstitute {
  ShareUserByInstitute(
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

  factory ShareUserByInstitute.fromJson(Map<String, dynamic> json) =>
      ShareUserByInstitute(
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
