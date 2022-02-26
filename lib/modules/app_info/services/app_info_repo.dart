import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/app_info/models/app_info_model.dart';
import 'package:palette/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInfoRepo {
  static String accessToken = "";
  static String name = "";

  static setAccessToken() async {
    if (accessToken != "") {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken') ?? '';
  }

  static Future<void> contactUs(ContactUsModel contactUsModel) async {
    await setAccessToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json"
    };

    try {
      String body = convert.jsonEncode(contactUsModel.toMap());
      final resp = await http.post(
        Uri.parse(current_uri + '/contact-us'),
        headers: headers,
        body: body,
      );
      Map<String, dynamic> responseDecoded = convert.jsonDecode(resp.body);

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        print('success $responseDecoded');
      } else if (responseDecoded.containsKey('message')) {
        throw CustomException(responseDecoded['message']);
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

  static Future<void> sendFeeback(FeedbackModel feedbackModel) async {
    await setAccessToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json"
    };

    try {
      String body = convert.jsonEncode(feedbackModel.toMap());
      print(body);
      final resp = await http.post(
        Uri.parse(current_uri + '/feedback'),
        headers: headers,
        body: body,
      );
      Map<String, dynamic> responseDecoded = convert.jsonDecode(resp.body);

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        print('success $responseDecoded');
      } else if (responseDecoded.containsKey('message')) {
        throw CustomException(responseDecoded['message']);
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

  static Future<void> reportBug(ReportBugModel reportBugModel) async {
    await setAccessToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json"
    };

    try {
      String body = convert.jsonEncode(reportBugModel.toMap());
      print(body);
      final resp = await http.post(
        Uri.parse(current_uri + '/reportissue'),
        headers: headers,
        body: body,
      );
      Map<String, dynamic> responseDecoded = convert.jsonDecode(resp.body);
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        print('success $responseDecoded');
      } else if (responseDecoded.containsKey('message')) {
        throw CustomException(responseDecoded['message']);
      } else {
        print('$responseDecoded');
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

  static Future<List<ResourceCenterGuides>> getResourceCenterList() async {
    await setAccessToken();

    print("accessToken: $accessToken");
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json"
    };

    try {
      final resp = await http.get(
        Uri.parse(current_uri + '/guides'),
        headers: headers,
      );
      Map<String, dynamic> responseDecoded = convert.jsonDecode(resp.body);

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final resourceCenterJsonArray = responseDecoded['data'] as List;
        print(resourceCenterJsonArray);
        final r = resourceCenterJsonArray
            .map((json) => ResourceCenterGuides.fromMap(json))
            .toList();
        return r;
      } else if (responseDecoded.containsKey('message')) {
        throw CustomException(responseDecoded['message']);
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
}
