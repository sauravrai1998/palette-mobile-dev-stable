import 'package:palette/modules/profile_module/models/user_models/abstract_profile_user_model.dart';

class ParentProfileUserModel extends BaseProfileUserModel {
  late String name;
  late String? instituteName;
  late String? instituteLogo;
  late String instituteId;
  late String email;
  late String? phone;
  late List<Pupil> pupils;
  late String id;
  late String firebaseUuid;
  late String? profilePicture;
  ParentProfileUserModel(
      {required this.name,
        required this.instituteName,
        required this.instituteLogo,
        required this.instituteId,
      required this.email,
      required this.phone,
      required this.pupils,
      required this.id,
      required this.profilePicture,
      required this.firebaseUuid});

  ParentProfileUserModel.empty();

  @override
  BaseProfileUserModel fromJson({required Map<String, dynamic> json}) {
    final pupils = (json['pupils'] != null && json['pupils'].isNotEmpty)
        ? json['pupils'].map<Pupil>((v) {
            return Pupil.fromJson(v);
          }).toList()
        : <Pupil>[];

    return ParentProfileUserModel(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      pupils: pupils,
      id: json['Id'],
      firebaseUuid: json['firebase_uuid'],
      profilePicture: json['profilePicture'],
        instituteLogo: json['instituteLogo'],
      instituteName: json['institute_name'],
      instituteId: json['instituteId'],
    );
  }

  @override
  Map<String, dynamic> toMap({required BaseProfileUserModel model}) {
    final Map<String, dynamic> data = {};
    data['name'] = this.name;
    data['pupils'] = [];
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['Id'] = this.id;
    data['profilePicture'] = this.profilePicture;
    data['institute_name'] = this.instituteName;
    data['instituteId'] = this.instituteId;
    data['instituteLogo'] = this.instituteLogo;
    data['firebase_uuid'] = this.firebaseUuid;
    return data;
  }
}

class Pupil {
  final String id;
  final String name;
  final String? profilePicture;

  Pupil({required this.id, required this.name, this.profilePicture});

  factory Pupil.fromJson(Map<String, dynamic> json) {
    return Pupil(
        id: json['Id'],
        name: json['Name'],
        profilePicture: json['profilePicture']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['profilePicture'] = this.profilePicture;
    return data;
  }
}
