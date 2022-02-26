import 'dart:async';
import 'dart:convert' as convert;
import 'dart:core';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:palette/modules/observer_dashboard_module/models/user_models/observer_student_mentors_model.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ObserverRepository {
  ObserverRepository._privateConstructor();
  static final ObserverRepository instance =
      ObserverRepository._privateConstructor();

  Future<ObserverStudent> getStudentData() async {
    final prefs = await SharedPreferences.getInstance();
    final String role = prefs.getString('role').toString();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };

    try {
      final resp = await http.get(
        Uri.parse(current_uri + _getPathForRegister(role) + '/details'),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('Student List: $decodedBody');
      if (resp.statusCode == 200) {
        return ObserverStudent.fromJson(decodedBody);
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
}
