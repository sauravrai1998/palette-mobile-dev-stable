import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:palette/modules/explore_module/models/student_list_response.dart';
import 'package:palette/modules/explore_module/models/submit_response.dart';
import 'package:palette/modules/comment_module/model/comment_list_response_model.dart';
import 'package:palette/modules/student_recommendation_module/models/user_models/recommendation_model.dart';
import 'package:palette/modules/student_recommendation_module/models/user_models/user_share_list_response.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecommendRepository {
  RecommendRepository._privateConstructor();
  static final RecommendRepository instance =
      RecommendRepository._privateConstructor();

  Future<Recommendation> getRecommendation() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final String role = prefs.getString('role').toString();
    // print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };
    String path = _getPathForRegister(role) + '/event/recommend';
    print(current_uri + path);
    try {
      final resp = await http.get(
        Uri.parse(current_uri + path),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        Recommendation r = Recommendation.fromJson(decodedBody);
        print(r);
        return r;
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

  Future<bool> rejectRecommendation({required List<String> id}) async {
    print(id);
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    // print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };
    var body = {"considerations": id};
    print(uriV2 + '/opportunities/dismiss');
    print(body);
    try {
      final resp = await http.post(Uri.parse(uriV2 + '/opportunities/dismiss'),
          headers: headers, body: convert.jsonEncode(body));

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print(resp.statusCode);
      print('Response: $decodedBody');
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return true;
      } else if (decodedBody.containsKey('message')) {
        return false;
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

  Future<bool> acceptRecommendation({required List<String> Ids}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    // print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };

    var body = {"considerations": Ids};
    print(body);
    print(uriV2 + '/opportunities/add/todo/');
    try {
      final resp = await http.post(
          Uri.parse(uriV2 + '/opportunities/add/todo/'),
          headers: headers,
          body: convert.jsonEncode(body));

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print(resp.body);
      if (resp.statusCode == 201) {
        return true;
      } else if (decodedBody.containsKey('message')) {
        return false;
        // throw CustomException(decodedBody['message']);
      } else {
        return false;
        // throw CustomException('Something went wrong');
      }
    } on SocketException {
      throw CustomException('No Internet connection');
    } on HttpException {
      throw CustomException('Something went wrong');
    } on FormatException {
      throw CustomException('Bad request');
    }
  }

  Future addTodoBulk({
    required List<String?> todoIds,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final body = {"considerations": todoIds};

    log('considerations $body ');
    try {
      print('bulk adding');
      final resp = await http.post(
        Uri.parse(uriV2 + '/opportunities/add/todo'),
        body: jsonEncode(body),
        headers: headers,
      );
      print('bulk adding');
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      log('bulk to todo ${resp.body}');
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

  Future dismissBulk({
    required List<String?> todoIds,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final body = {"considerations": todoIds};

    print(body);
    try {
      print('bulk dismissing');
      final resp = await http.post(
        Uri.parse(uriV2 + '/opportunities/dismiss'),
        body: jsonEncode(body),
        headers: headers,
      );
      print('bulk dismissing');
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      print(resp.statusCode);
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        /// Success
        print("done ${resp.body}");
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

  Future<ShareUserListModel> getUserListToShare(
      {required String eventId}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };

    print(eventId);
    final body = {"opportunityId": eventId};

    var path1 = uriV2 + '/opportunities/share/recipients/' + eventId;

    try {
      final resp = await http.get(
        Uri.parse(path1),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('!Student List: $decodedBody');
      if (decodedBody['message'] == 'Not Authorised To share'){
        throw CustomException('Not Authorised To share');
      }
      if (resp.statusCode == 200) {
        return ShareUserListModel.fromJson(decodedBody);
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

  Future<ShareUserListModel> getUserListToShareBulkConsideration() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token bulk : $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };

    var path1 = uriV2 + '/opportunities/recipients';

    try {
      final resp = await http.get(
        Uri.parse(path1),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('Student List: $decodedBody');
      if (resp.statusCode == 200) {
        return ShareUserListModel.fromJson(decodedBody);
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

  Future<SubmitResponse> recommendedEventsToUsers(
      Map<String, dynamic> map) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');
    String body = convert.jsonEncode(map);
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };
    print(body);
    try {
      final resp = await http.post(Uri.parse(uriV2 + '/opportunities/share'),
          headers: headers, body: body);

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

  Future<CommentListModel> getCommentsList({required String eventId}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };

    print(eventId);

    var path1 = uriV2 + '/opportunities/comments/' + eventId;
    print(path1);
    try {
      final resp = await http.get(
        Uri.parse(path1),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('Comments List: $decodedBody');
      if (resp.statusCode == 200) {
        print(resp.statusCode);
        return CommentListModel.fromJson(decodedBody);
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

  Future<SubmitResponse> sendComment(Map<String, dynamic> map) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');
    Map<String, dynamic> map1 = {'commentsDto': map};
    String body = convert.jsonEncode(map1);
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };
    print(body);
    try {
      final resp = await http.post(Uri.parse(uriV2 + '/opportunities/comment/'),
          headers: headers, body: body);
      print(resp.statusCode);
      print(resp.body);
      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('Send Resp: $decodedBody');
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        print('posted comment');
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
