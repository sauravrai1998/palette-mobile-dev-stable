import 'dart:async';
import 'dart:convert' as convert;
import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:palette/modules/explore_module/models/explore_list_model.dart';
import 'package:palette/modules/explore_module/models/institute_list.dart';
import 'package:palette/modules/explore_module/models/opp_created_by_me_response.dart';
import 'package:palette/modules/explore_module/models/student_list_response.dart';
import 'package:palette/modules/explore_module/models/submit_response.dart';
import 'package:palette/modules/student_recommendation_module/models/user_models/user_share_list_response.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExploreRepository {
  ExploreRepository._privateConstructor();
  static final ExploreRepository instance =
      ExploreRepository._privateConstructor();

  Future<ExploreListModel> getExploreData() async {
    String path;
    final prefs = await SharedPreferences.getInstance();
    final String role = prefs.getString('role').toString();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    if (role == 'Advisor' ||
        role == 'Faculty/Staff' ||
        role == 'Guardian' ||
        role == 'Admin')
      path = '/student/explore/activities';
    else
      path = '/student/activities/institute';

    final request = http.Request('GET', Uri.parse(current_uri + path));
    print('url: : ${current_uri + path}');

    request.headers.addAll(headers);

    try {
      var streamedResponse = await request.send();
      var resp = await http.Response.fromStream(streamedResponse);

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      log('some thing $decodedBody');
      if (resp.statusCode == 200) {
        return ExploreListModel.fromJson(decodedBody);
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

  Future<InstituteListModel> getInstituteListByParents() async {
    final prefs = await SharedPreferences.getInstance();
    final String role = prefs.getString('role').toString();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };

    try {
      final resp = await http.get(
        Uri.parse(current_uri + _getPathForRegister(role) + '/institutes'),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('Student List: $decodedBody');
      if (resp.statusCode == 200) {
        return InstituteListModel.fromJson(decodedBody);
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

  Future<StudentListModel> getUsersToShareOpportunity(
      {required String eventId}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };
    print(eventId);
    try {
      final resp = await http.get(
        Uri.parse(uriV2 + '/opportunities/share/recipients/$eventId'),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('Student List: $decodedBody');
      if (resp.statusCode == 200) {
        return StudentListModel.fromJson(decodedBody);
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

  Future<ExploreListModel> getActivityListByParents(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');

    Map<String, String> map = {"instituteId": id};
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    final request = http.Request(
        'GET', Uri.parse(current_uri + '/student/explore/institute'));
    request.headers.addAll(headers);
    request.body = convert.jsonEncode(map);

    try {
      var streamedResponse = await request.send();
      var resp = await http.Response.fromStream(streamedResponse);

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('Student List: $decodedBody');
      if (resp.statusCode == 200) {
        return ExploreListModel.fromJson(decodedBody);
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

  Future<ExploreListModel> getAllActivitiesData() async {
    String path;
    final prefs = await SharedPreferences.getInstance();
    final String role = prefs.getString('role').toString();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    path = '/student/explore/activities';

    final request = http.Request('GET', Uri.parse(current_uri + path));
    request.headers.addAll(headers);

    try {
      var streamedResponse = await request.send();
      var resp = await http.Response.fromStream(streamedResponse);

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print(decodedBody);
      if (resp.statusCode == 200) {
        return ExploreListModel.fromJson(decodedBody);
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

  Future<SubmitResponse> saveTodo(String eventId, String listedBy) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');
    Map<String, String> postData = {"eventId": eventId, "listedBy": listedBy};
    String body = convert.jsonEncode(postData);
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };
    final apiUri = Uri.parse(current_uri + '/student/todo/event/');
    try {
      final resp = await http.post(apiUri, headers: headers, body: body);

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('Student List: $decodedBody');
      if (resp.statusCode == 200) {
        return SubmitResponse.fromJson(decodedBody);
      } else if (resp.statusCode == 400) {
        throw CustomException('User already accepted the event recommendation');
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

  Future enroll(Map<String, dynamic> map) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    String body = convert.jsonEncode(map);
    log('maps $body');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/opportunities/single/add/todo'),
        headers: headers,
        body: body,
      );

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('resp.body of enroll: ${resp.statusCode}');
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        /// Success
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
    } catch (e) {
      print(e.toString());
      throw CustomException(e.toString());
    }
  }

  Future wishlist(Map<String, dynamic> map) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final rawMap = {
      "wishListDto": map,
    };

    String body = convert.jsonEncode(rawMap);
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };
    print('body sent: $body');

    try {
      final resp = await http.post(
          Uri.parse(current_uri + '/student/event/wishlist'),
          headers: headers,
          body: body);

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print(resp.body);
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        /// Success
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

  Future<SubmitResponse> shareOpportunity(Map<String, dynamic> map) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken');

    log('Body of ShareOpp: $map , url : ${uriV2 + '/opportunities/share'}');
    String body = convert.jsonEncode(map);

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    try {
      final resp = await http.post(Uri.parse(uriV2 + '/opportunities/share'),
          headers: headers, body: body);

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      log('Resp of ShareOpp: $decodedBody');
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return SubmitResponse.fromJson(decodedBody);
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

  /// Deprecated
  Future<SubmitResponse> recommendedEventsByParent(
      Map<String, dynamic> map) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');
    String body = convert.jsonEncode(map);
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    try {
      final resp = await http.post(
          Uri.parse(current_uri + '/student/event/recommend'),
          headers: headers,
          body: body);

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('Student List: $decodedBody');
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return SubmitResponse.fromJson(decodedBody);
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

  Future<OppCreatedByMeResponse> getOppCreatedByMe() async {
    String path;
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    path = '/opportunities/user/';

    final request = http.Request('GET', Uri.parse(uriV2 + path));
    request.headers.addAll(headers);

    try {
      var streamedResponse = await request.send();
      var resp = await http.Response.fromStream(streamedResponse);
      log('createdbyme response: ${resp.body}');

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print(decodedBody);
      if (resp.statusCode == 200) {
        return OppCreatedByMeResponse.fromJson(decodedBody);
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
    } catch (e) {
      print(e.toString());
      throw CustomException(e.toString());
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
