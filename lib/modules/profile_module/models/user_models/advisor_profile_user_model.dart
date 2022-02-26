import 'abstract_profile_user_model.dart';

class AdvisorProfileUserModel extends BaseProfileUserModel {
  late String name;
  late String instituteId;
  late String? instituteLogo;
  late String? instituteName;
  late String? designation;
  late String? linkedInlink;
  late String? email;
  late String? phone;
  late String? mailingCity;
  late String? mailingCountry;
  late String? mailingState;
  late String? mailingStreet;
  late String? mailingPostalCode;
  late String? facebookLink;
  late String? whatsappLink;
  late String? instagramLink;
  late String? websiteLink;
  late String? websiteTitle;
  late String? githubLink;
  late String id;
  late String? profilePicture;
  late String firebaseUuid;

  AdvisorProfileUserModel(
      {required this.name,
      required this.instituteName,
      required this.instituteLogo,
      required this.instituteId,
      required this.phone,
      required this.email,
      this.designation,
      this.mailingCity,
      this.mailingCountry,
      this.mailingState,
      this.mailingStreet,
      this.mailingPostalCode,
      this.facebookLink,
      this.whatsappLink,
      this.linkedInlink,
      this.instagramLink,
      this.websiteLink,
      this.websiteTitle,
      this.githubLink,
      required this.id,
      required this.profilePicture,
      required this.firebaseUuid});

  AdvisorProfileUserModel.empty();

  @override
  BaseProfileUserModel fromJson({required Map<String, dynamic> json}) {
    return AdvisorProfileUserModel(
        name: json['name'],
        phone: json['phone'],
        linkedInlink: json["linkedin_link"],
        instituteId: json["instituteId"],
        email: json['email'],
        instituteName: json['institute_name'],
        designation: json['designation'],
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
        id: json['Id'],
        firebaseUuid: json['firebase_uuid'],
        profilePicture: json['profilePicture'],
        instituteLogo: json['instituteLogo']);
  }

  @override
  Map<String, dynamic> toMap({required BaseProfileUserModel model}) {
    final Map<String, dynamic> data = {};
    data['name'] = this.name;
    data['institute_name'] = this.instituteName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['designamtion'] = this.designation;
    data['mailingCity'] = this.mailingCity;
    data['mailingCountry'] = this.mailingCountry;
    data['mailingState'] = this.mailingState;
    data['mailingStreet'] = this.mailingStreet;
    data["linkedin_link"] = this.linkedInlink;
    data['mailingPostalCode'] = this.mailingPostalCode;
    data['facebook_link'] = this.facebookLink;
    data['whatsapp_link'] = this.whatsappLink;
    data['instagram_link'] = this.instagramLink;
    data['website_link'] = this.websiteLink;
    data['website_Title'] = this.websiteTitle;
    data['github_link'] = this.githubLink;
    data['instituteId'] = this.instituteId;
    data['Id'] = this.id;
    data['firebase_uuid'] = this.firebaseUuid;
    data['profilePicture'] = this.profilePicture;
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
