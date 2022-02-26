class ProfileEducationModel {
  String? instituteName;
  String? course;
  String? rollNo;
  String? instituteId;
  String? instituteLogo;

  ProfileEducationModel({
    required this.instituteName,
    required this.course,
    required this.rollNo,
    required this.instituteId,
    required this.instituteLogo
  });

  factory ProfileEducationModel.fromJson(Map<String, dynamic> json) {
    return ProfileEducationModel(
      instituteName: json['institute_name'],
      course: json['course'],
      rollNo: json['roll_no'],
      instituteId: json['instituteId'],
      instituteLogo: json['instituteLogo']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['institute_name'] = this.instituteName;
    data['course'] = this.course;
    data['roll_no'] = this.rollNo;
    data['instituteId'] = this.instituteId;
    data['instituteLogo'] = this.instituteLogo;
    return data;
  }
}
