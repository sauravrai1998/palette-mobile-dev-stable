import 'abstract_profile_user_model.dart';

class ObserverProfileUserModel extends BaseProfileUserModel {
  late String name;

  late String? mailingCity;
  late String? phone;
  late String? email;

  late String? mailingCountry;
  late String? mailingState;
  late String? mailingStreet;
  late String? mailingPostalCode;
  late String? facebookLink;
  late String? whatsappLink;
  late String? instagramLink;
  late String? websiteLink;
  late String? linkedInlink;
  late String? websiteTitle;
  late String? githubLink;
  late List<InstituteDetail>? instituteList;
  late String id;
  late String? profilePicture;
  late String? firebaseUuid;

  ObserverProfileUserModel(
      {required this.name,
      required this.email,
      required this.linkedInlink,
      required this.phone,
      required this.mailingCity,
      required this.mailingCountry,
      required this.mailingState,
      required this.mailingStreet,
      required this.mailingPostalCode,
      required this.facebookLink,
      required this.whatsappLink,
      required this.instagramLink,
      required this.websiteLink,
      required this.websiteTitle,
      required this.githubLink,
      required this.instituteList,
      required this.id,
      required this.profilePicture,
      required this.firebaseUuid});

  ObserverProfileUserModel.empty();

  @override
  BaseProfileUserModel fromJson({required Map<String, dynamic> json}) {
    // final List<ProfileEducationModel> educationList = [];
    // json['education'].forEach((v) {
    //   educationList.add(ProfileEducationModel.fromJson(v));
    // });

    final List<InstituteDetail> instituteTempList = [];

    json['institutes'].forEach((v) {
      instituteTempList.add(InstituteDetail.fromJson(v));
      print(instituteTempList);
    });

    return ObserverProfileUserModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      linkedInlink: json["linkedin_link"],
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
      instituteList: instituteTempList,
      id: json['Id'],
      firebaseUuid: json['firebase_uuid'],
      profilePicture: json['profilePicture'],
    );
  }

  @override
  Map<String, dynamic> toMap({required BaseProfileUserModel model}) {
    final Map<String, dynamic> data = {};
    data['name'] = this.name;
    data['mailingCity'] = this.mailingCity;
    data['mailingCountry'] = this.mailingCountry;
    data['mailingState'] = this.mailingState;
    data['mailingStreet'] = this.mailingStreet;
    data["linkedin_link"] = this.linkedInlink;
    data['mailingPostalCode'] = this.mailingPostalCode;
    data['facebook_link'] = this.facebookLink;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['whatsapp_link'] = this.whatsappLink;
    data['instagram_link'] = this.instagramLink;
    data['website_link'] = this.websiteLink;
    data['website_Title'] = this.websiteTitle;
    data['github_link'] = this.githubLink;
    data['institutes'] = this.instituteList;
    data['Id'] = this.id;
    data['firebase_uuid'] = this.firebaseUuid;
    data['profilePicture'] = this.profilePicture;
    return data;
  }
}

class InstituteDetail {
  String? instituteId;
  String? instituteName;
  String? designation;
  String? instituteLogo;

  InstituteDetail(
      {required this.instituteId,
      required this.instituteName,
      required this.designation,
      required this.instituteLogo});

  factory InstituteDetail.fromJson(Map<String, dynamic> json) {
    return InstituteDetail(
        instituteId: json['institute_id'],
        instituteName: json['institute_name'],
        designation: json['designation'],
        instituteLogo: json['instituteLogo']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['institute_id'] = this.instituteId;
    data['institute_name'] = this.instituteName;
    data['designation'] = this.designation;
    data['instituteLogo'] = this.instituteLogo;
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
