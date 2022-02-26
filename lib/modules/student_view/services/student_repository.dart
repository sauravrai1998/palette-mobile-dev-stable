import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:palette/modules/student_dashboard_module/models/class_data.dart';
import 'package:palette/modules/student_dashboard_module/models/college_application_list_model.dart';
import 'package:palette/modules/student_dashboard_module/models/education_data_model.dart';
import 'package:palette/modules/student_dashboard_module/models/event_list_model.dart';
import 'package:palette/modules/student_dashboard_module/models/job_application_list_model.dart';
import 'package:palette/modules/student_dashboard_module/models/online_courses_data_model.dart';
import 'package:palette/modules/student_dashboard_module/models/tutoring_data_model.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentRepository {
  static String? token;
  // String uri = 'http://localhost:9000';
  StudentRepository._privateConstructor();

  static final StudentRepository instance =
      StudentRepository._privateConstructor();

  Future<List<EducationData>> educationPageData() async {
    print('called');
    token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjAwMzRDMDAwMDBQOXN1alFBQiIsIlJlY29yZFR5cGVJZCI6IjAxMjR4MDAwMDAwbFp1S0FBVSIsIkZpcnN0TmFtZSI6InJhbWEiLCJMYXN0TmFtZSI6ImtyaXNobmEiLCJFbWFpbCI6ImFuaWxzYWkyNTBAZ21haWwuY29tIiwiUGhvbmUiOiIrOTE3MDEzMjU4MTgwIiwiVVRfSURfX2MiOiIwMDM0QzAwMDAwUDlzdWoiLCJJc1JlZ2lzdGVyZWRPblBhbGV0dGVfX2MiOmZhbHNlLCJpYXQiOjE2MTg5MDg0ODMsImV4cCI6MTYxOTc3MjQ4M30.wk1uYRFvAvZY1fJUe86FMZu9LtVeJuPsq0j9hG4OW20";
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    print("calling api");
    final response = await http.get(
      Uri.parse(current_uri + '/salesforce/AllCourse'),
      headers: headers,
    );
    print("done");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));

      final classData = convert.jsonDecode(response.body)['Class'] as List;
      final onlineData = convert.jsonDecode(response.body)['Online'];
      final tutoringData = convert.jsonDecode(response.body)['Tutoring'];
      print(tutoringData);
      print(onlineData);
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

  Future<bool> sendLinkData({title, value}) async {
    print('called');
    token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjAwMzRDMDAwMDBQOXN1alFBQiIsIlJlY29yZFR5cGVJZCI6IjAxMjR4MDAwMDAwbFp1S0FBVSIsIkZpcnN0TmFtZSI6InJhbWEiLCJMYXN0TmFtZSI6ImtyaXNobmEiLCJFbWFpbCI6ImFuaWxzYWkyNTBAZ21haWwuY29tIiwiUGhvbmUiOiIrOTE3MDEzMjU4MTgwIiwiVVRfSURfX2MiOiIwMDM0QzAwMDAwUDlzdWoiLCJJc1JlZ2lzdGVyZWRPblBhbGV0dGVfX2MiOmZhbHNlLCJpYXQiOjE2MTg5MDg0ODMsImV4cCI6MTYxOTc3MjQ4M30.wk1uYRFvAvZY1fJUe86FMZu9LtVeJuPsq0j9hG4OW20";
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };

    Map<String, String> body = {"linkedIn": "instagram.com/amardeep"};

    print("calling api");
    final response = await http.patch(Uri.parse(current_uri + '/student'),
        headers: headers, body: convert.jsonEncode(body));

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

  Future<CollegeApplicationList> getCollegeApplicationList(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };

    String path =
        id != '' ? '/student/collegeapp/$id' : '/student/token/collegeapp';

    try {
      final response = await http.get(
        Uri.parse(current_uri + path),
        headers: headers,
      );
      var resp = convert.jsonDecode(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('college application data: ${convert.jsonDecode(response.body)}');
        return CollegeApplicationList.fromJson(resp);
      } else if (response.statusCode == 400) {
        throw CustomException('Something went wrong');
      } else if (resp.containsKey('message')) {
        throw CustomException(resp['message']);
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

  Future<JobApplicationListModel> getJobApplicationList(String id) async {
    print('called');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };

    String path =
        id != '' ? '/student/jobsapplied/$id' : '/student/token/jobsapplied';

    try {
      print("calling api");
      final response = await http.get(
        Uri.parse(current_uri + path),
        headers: headers,
      );
      var resp = convert.jsonDecode(response.body);

      print(response.statusCode);
      if (response.statusCode == 200) {
        // print('job application data: ${convert.jsonDecode(response.body)}');
        return JobApplicationListModel.fromJson(resp);
      } else if (response.statusCode == 400) {
        throw CustomException('Something went wrong');
      } else if (resp.containsKey('message')) {
        throw CustomException(resp['message']);
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

  Future<EventList> getEventListApplicationList(String id) async {
    print('called');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };

    String path = id != ''
        ? '/student/activities/all/$id'
        : '/student/token/activities/all';

    try {
      final response = await http.get(
        Uri.parse(current_uri + path),
        headers: headers,
      );
      var resp = convert.jsonDecode(response.body);
      print("done");
      print(response.statusCode);
      if (response.statusCode == 200) {
        // print('event application data: ${convert.jsonDecode(response.body)}');

        return EventList.fromJson(resp);
      } else if (response.statusCode == 400) {
        throw CustomException('Something went wrong');
      } else if (resp.containsKey('message')) {
        throw CustomException(resp['message']);
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
}
