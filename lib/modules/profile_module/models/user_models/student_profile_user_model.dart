import 'package:palette/modules/profile_module/models/user_models/profile_education_model.dart';

import 'abstract_profile_user_model.dart';

class StudentProfileUserModel extends BaseProfileUserModel {
  late String id;
  late String name;
  late String? dOB;
  late String? gender;
  late String? phone;
  late String? email;
  late List<ProfileEducationModel>? educationList;
  late List<StudentWorkExp>? workExperience;
  late List<String>? interests;
  late String? mailingCity;
  late String? mailingCountry;
  late String? mailingState;
  late String? mailingStreet;
  late String? mailingPostalCode;
  late String? facebookLink;
  late String? whatsappLink;
  late String? linkedInlink;
  late String? instagramLink;
  late String? websiteLink;
  late String? websiteTitle;
  late String? githubLink;
  late List<String>? skills;
  late List<String>? projects;
  late List<String>? activities;
  late String Id;
  late String? profilePicture;
  late String? firebaseUuid;

  StudentProfileUserModel(
      {required this.name,
      required this.id,
      required this.dOB,
      required this.gender,
      required this.educationList,
      required this.workExperience,
      required this.interests,
      required this.mailingCity,
      required this.mailingCountry,
      required this.mailingState,
      required this.mailingStreet,
      required this.linkedInlink,
      required this.mailingPostalCode,
      required this.facebookLink,
      required this.whatsappLink,
      required this.instagramLink,
      required this.websiteLink,
      required this.websiteTitle,
      required this.githubLink,
      required this.skills,
      required this.projects,
      required this.activities,
      required this.phone,
      required this.email,
      required this.Id,
      required this.profilePicture,
      required this.firebaseUuid});

  StudentProfileUserModel.empty();

  @override
  BaseProfileUserModel fromJson({required Map<String, dynamic> json}) {
    final List<ProfileEducationModel> educationList = [];
    json['education'].forEach((v) {
      educationList.add(ProfileEducationModel.fromJson(v));
    });

    return StudentProfileUserModel(
      id: json['Id'],
      firebaseUuid: json['firebase_uuid'],
      email: json['email'],
      phone: json['phone'],
      linkedInlink: json["linkedin_link"],
      name: json['name'],
      dOB: json['DOB'],
      gender: json['gender'],
      educationList: educationList,
      workExperience: json['work_experience'].isNotEmpty
          ? json['work_experience'].map<StudentWorkExp>((v) {
              return StudentWorkExp.fromJson(v);
            }).toList()
          : [],
      mailingCity: json['mailingCity'],
      mailingCountry: json['mailingCountry'],
      mailingState: json['mailingState'],
      mailingStreet: json['mailingStreet'],
      mailingPostalCode: json['mailingPostalCode'],
      facebookLink: json['facebook_link'],
      whatsappLink: json['whatsapp_link'],
      instagramLink: json['instagram_link'],
      websiteLink: json['website_link'],
      websiteTitle: json['website_Title'],
      githubLink: json['github_link'],
      interests: (json['interests'] != null && json['interests'].isNotEmpty)
          ? json['interests'].map<String>((v) {
              return v as String;
            }).toList()
          : [],
      skills: (json['skills'] != null && json['skills'].isNotEmpty)
          ? json['skills'].map<String>((v) {
              return v as String;
            }).toList()
          : [],
      projects: (json['projects'] != null && json['projects'].isNotEmpty)
          ? json['projects'].map<String>((v) {
              return v as String;
            }).toList()
          : [],
      activities: (json['activities'] != null && json['activities'].isNotEmpty)
          ? json['activities'].map<String>((v) {
              return v as String;
            }).toList()
          : [],
      Id: json['Id'],
      profilePicture: json['profilePicture'],
    );
  }

  @override
  Map<String, dynamic> toMap({required BaseProfileUserModel model}) {
    final Map<String, dynamic> data = {};
    data['name'] = this.name;
    data['Id'] = this.id;
    data['DOB'] = this.dOB;
    data['gender'] = this.gender;
    data["linkedin_link"] = this.linkedInlink;
    data['education'] = educationList != null
        ? this.educationList!.map((v) => v.toJson()).toList()
        : [];
    data['work_experience'] = workExperience != null
        ? this.workExperience!.map((e) => e.toJson()).toList()
        : [];
    data['interests'] = this.interests;
    data['mailingCity'] = this.mailingCity;
    data['mailingCountry'] = this.mailingCountry;
    data['mailingState'] = this.mailingState;
    data['mailingStreet'] = this.mailingStreet;
    data['mailingPostalCode'] = this.mailingPostalCode;
    data['facebook_link'] = this.facebookLink;
    data['whatsapp_link'] = this.whatsappLink;
    data['instagram_link'] = this.instagramLink;
    data['website_link'] = this.websiteLink;
    data['website_Title'] = this.websiteTitle;
    data['github_link'] = this.githubLink;
    data['skills'] = this.skills;
    data['projects'] = this.projects;
    data['activities'] = this.activities;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['Id'] = this.Id;
    data['firebase_uuid'] = this.firebaseUuid;
    data['profilePicture'] = this.profilePicture;
    return data;
  }
}

class StudentWorkExp {
  final String? organizationName;
  final String? role;
  final String? startDate;
  final String? endDate;

  StudentWorkExp({
    required this.organizationName,
    required this.role,
    required this.startDate,
    required this.endDate,
  });

  factory StudentWorkExp.fromJson(Map<String, dynamic> json) {
    return StudentWorkExp(
      organizationName: json['organizationName'],
      role: json['role'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['organizationName'] = this.organizationName;
    data['role'] = this.role;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }
}

// class ProfileEducationModel {
//   String instituteName;
//   String course;
//   String rollNo;
//
//   ProfileEducationModel({
//     required this.instituteName,
//     required this.course,
//     required this.rollNo,
//   });
//
//   factory ProfileEducationModel.fromJson(Map<String, dynamic> json) {
//     return ProfileEducationModel(
//       instituteName: json['institute_name'],
//       course: json['course'],
//       rollNo: json['roll_no'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['institute_name'] = this.instituteName;
//     data['course'] = this.course;
//     data['roll_no'] = this.rollNo;
//     return data;
//   }
// }
