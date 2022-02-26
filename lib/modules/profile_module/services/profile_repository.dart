import 'dart:async';
import 'dart:convert' as convert;
import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart' as http;
import 'package:palette/modules/profile_module/models/user_models/abstract_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/admin_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/advisor_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/observer_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/parent_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/student_profile_user_model.dart';
import 'package:palette/modules/student_dashboard_module/models/class_data.dart';
import 'package:palette/modules/student_dashboard_module/models/education_data_model.dart';
import 'package:palette/modules/student_dashboard_module/models/online_courses_data_model.dart';
import 'package:palette/modules/student_dashboard_module/models/tutoring_data_model.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  ProfileRepository._privateConstructor();
  static final ProfileRepository instance =
      ProfileRepository._privateConstructor();

  Future<BaseProfileUserModel> getProfileUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String role = prefs.getString('role').toString();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };

    try {
      final resp = await http.get(
        Uri.parse(current_uri + _getPathForRegister(role)),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('role : $role');
      log('User Profile: $decodedBody');
      if (resp.statusCode == 200) {
        return _getProfileUser(json: decodedBody, role: role);
      } else if (decodedBody.containsKey('message')) {
        throw CustomException(decodedBody['message']);
      } else {
        throw CustomException('Something went wrong');
      }
    } on SocketException {
      throw CustomException('No Internet connection');
    } on HttpException {
      throw CustomException('Something went wrong');
    } on FormatException {
      throw CustomException('Bad request');
    }
  }

  Future<List<EducationData>> educationPageData() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };

    final response = await http.get(
      Uri.parse('$current_uri/student/allcourse'),
      headers: headers,
    );

    /// Follow pattern as done in other api calls @amar
    if (response.statusCode == 200) {
      final classData = convert.jsonDecode(response.body)['Class'] as List;
      final onlineData = convert.jsonDecode(response.body)['Online'];
      final tutoringData = convert.jsonDecode(response.body)['Tutoring'];
      EducationData data = EducationData(
          classDataModel:
              classData.map((map) => ClassData.fromMap(map)).toList(),
          tutoringModel: tutoringData
              .map((map) => TutoringDataModel.fromMap(map))
              .toList(),
          onlineCoursesModel: onlineData
              .map((map) => OnlineCoursesDataModel.fromMap(map))
              .toList());
      return [data];
    } else if (response.statusCode == 400) {
      return [];
    } else {
      return [];
    }
  }

  Future<bool> sendLinkData({title, value, webTitle}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    String role = prefs.getString('role').toString();
    if (role == 'Faculty/Staff') role = 'advisor';
    print(role);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };
    Map<String, String> body = {};

    if (title == "Website") {
      body = {"website_link": value, "website_Title": webTitle.toString()};
    } else if (title == instagramTitle) {
      body = {
        "instagram_link": value,
      };
    } else if (title == whatsappTitle) {
      body = {
        "whatsapp_link": value,
      };
    } else if (title == facebookTitle) {
      body = {
        "facebook_link": value,
      };
    } else if (title == gitHubTitle) {
      body = {
        "github_link": value,
      };
    } else if (title == linkedInTitle) {
      body = {
        "linkedin_link": value,
      };
    }

    print("calling api");
    final response = await http.patch(
        Uri.parse(current_uri + '/${role.toLowerCase()}'),
        headers: headers,
        body: convert.jsonEncode(body));

    print("done");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));

      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      return false;
    }
  }

  Future<void> skillInterestActivites({data}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    try {
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      };

      final response = await http.patch(Uri.parse(current_uri + '/student'),
          headers: headers, body: convert.jsonEncode(data));

      final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print(json);

      if (response.statusCode == 200) {
        /// success
      } else if (response.statusCode == 400) {
        if (json.containsKey('message')) {
          throw CustomException(json['message']);
        } else {
          throw CustomException(
              'Something went wrong, Our team is looking into it.');
        }
      } else {
        throw CustomException(
            'Something went wrong, Our team is looking into it.');
      }
    } on SocketException {
      throw CustomException('No Internet connection');
    } on HttpException {
      throw CustomException('Something went wrong, try again later.');
    } on FormatException {
      throw CustomException('Bad request');
    }
  }

  Future<bool> postProfileImageUrl({url}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };

    Map<String, String> body = {"url": url};
    print('Uploading to Backend');

    final response = await http.post(
        Uri.parse(current_uri + '/auth/profilepicture'),
        headers: headers,
        body: convert.jsonEncode(body));

    print(response.body);

    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      return false;
    }
  }

  Future<bool> addImageUrlToUsersCollectionFirestore(String uri) async {
    String uid = FirebaseChatCore.instance.firebaseUser!.uid;
    print(uid);
    final json =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final jsonData = json.data();
    print('here');
    print(jsonData);
    if (jsonData == null) return false;
    jsonData.update('avatarUrl', (value) => uri);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(jsonData, SetOptions(merge: false));
    return true;
  }

  String _getPathForRegister(String role) {
    /// Returns role based on the role we get from backend. Not yet dynamic
    /// eg: In case of parent it will be -  return '/parent';
    /// Right now it is hardcoded for student.
    if (role == "Student") {
      return '/student';
    } else if (role == "Observer") {
      return '/observer';
    } else if (role == "Advisor" || role.toLowerCase() == "faculty/staff") {
      return '/advisor';
    } else if (role == "Admin") {
      return '/admin';
    } else {
      return '/parent';
    }
  }

  BaseProfileUserModel _getProfileUser(
      {required Map<String, dynamic> json, required String role}) {
    /// Returns user model based on the role of the user. Not yet dynamic
    /// Right now it is hardcoded for student.
    if (role == "Student") {
      print('profileJson : $json');
      return StudentProfileUserModel.empty().fromJson(json: json);
    } else if (role == "Observer") {
      return ObserverProfileUserModel.empty().fromJson(json: json);
    } else if (role == "Advisor" || role.toLowerCase() == "faculty/staff") {
      return AdvisorProfileUserModel.empty().fromJson(json: json);
    } else if (role == "Admin") {
      return AdminProfileUserModel.empty().fromJson(json: json);
    } else {
      return ParentProfileUserModel.empty().fromJson(json: json);
    }
  }
}
