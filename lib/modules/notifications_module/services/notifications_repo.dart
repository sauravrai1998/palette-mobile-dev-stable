import 'dart:async';
import 'dart:convert' as convert;
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:palette/modules/explore_module/models/explore_list_model.dart';
import 'package:palette/modules/notifications_module/models/approval_notification_detail_model.dart';
import 'package:palette/modules/notifications_module/models/notification_item_model.dart';
import 'package:palette/modules/notifications_module/models/todo_approval_detail_model.dart';
import 'package:palette/modules/student_recommendation_module/models/user_models/user_share_list_response.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsRepository {
  NotificationsRepository._privateConstructor();
  static final NotificationsRepository instance =
      NotificationsRepository._privateConstructor();

  Future<NotificationListModel> fetchAllNotifications() async {
    print('fetching notifs');
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    // print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };

    try {
      final resp = await http.get(
        Uri.parse(uriV2 + '/notification'),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);

      if (resp.statusCode == 200) {
        print(decodedBody);
        return NotificationListModel.fromJson(decodedBody);
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
      throw e.toString();
    }
  }

  Future<bool> readNotifications({required String id}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    // print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };
    var body = {"notificationId": id};
    try {
      final resp = await http.get(Uri.parse(uriV2 + '/notification/read/' + id),
          headers: headers);

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('Response: $decodedBody');
      if (resp.statusCode == 200) {
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

  Future<bool> readAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    // print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };

    try {
      final resp = await http.get(
        Uri.parse(uriV2 + '/notification/readall'),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('Response: $decodedBody');
      if (resp.statusCode == 200) {
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

  Future<ApproveNotificationDetailList> getApprovalDetails(
      {required String eventId,required String notificationId, required bool isTodo}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');
    final role = prefs.getString('role')!;
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };
    var path;
    var body;
    print(eventId);
    print(isTodo);
    var adminPath = uriV2 + '/admin/approvals/' + notificationId;
    var advisorPath = uriV1 + '/advisor/opportunity/approvals/' + notificationId;
    var adminTodoPath = uriV2 + '/admin/todo/approvals/' + notificationId;
    if(role.toLowerCase() == 'admin'){
      if(isTodo){
        path = adminTodoPath;
      }
      else {
        path = adminPath;
      }
    }
    else{
      path = advisorPath;
    }
    print(path);
    try {
      final resp = await http.get(
        Uri.parse(path),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('Approval details: $decodedBody');
      if (resp.statusCode == 200) {
        print(resp.statusCode);
        return ApproveNotificationDetailList.fromJson(decodedBody);
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


  Future<TodoNotificationDetailList> getTodoApprovalDetails(
      {required String eventId,required String notificationId}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');
    final role = prefs.getString('role')!;
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };

    var body;
    print(eventId);
    var path = uriV2 + '/admin/todo/approvals/' + notificationId;

    print(path);
    try {
      final resp = await http.get(
        Uri.parse(path),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('Approval details: $decodedBody');
      if (resp.statusCode == 200) {
        print(resp.statusCode);
        return TodoNotificationDetailList.fromJson(decodedBody);
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

  Future<bool> approveDismissRequest(
      {required String status, required String eventId, required String notificationId, required String notificationType}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final role = prefs.getString('role')!;
    // print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };
    var path;
    var body;
    var adminbody = {
      "eventStatusDto": {
        "eventId": eventId,
        "status": status,
        "type": notificationType
      }
    };

    var advisorbody = {
        "status": status,
    };

    final adminPath = uriV2 + '/admin/status';
    final advisorPath = uriV1 + '/advisor/opportunity/approvals/$eventId';

    if(role.toLowerCase() == 'admin'){
      path = adminPath;
      body = adminbody;
    }
    else{
      path = advisorPath;
      body = advisorbody;
    }
    print(path);
    print(body);
    try {
      final resp = await http.post(
          Uri.parse(path),
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

  Future<bool> approveDismissTodoRequest(
      {required String status, required String eventId, required String notificationId, required String notificationType}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final role = prefs.getString('role')!;
    // print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };
    var path;

    final approvePath = uriV2 + '/admin/todo/approve/' + eventId;
    final dismissPath = uriV2 + '/admin/todo/reject/' + eventId;

    if(status == 'Accept'){
      path = approvePath;
    }
    else{
      path = dismissPath;
    }
    print(path);
    try {
      final resp = await http.get(
          Uri.parse(path),
          headers: headers);

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print(resp.body);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
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
}
