import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/todo_module/models/createtodo_response_model.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_model.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoRepoAdmins {
  TodoRepoAdmins._privateConstructor();
  static final instance = TodoRepoAdmins._privateConstructor();

  Future<TodoListResponse> fetchTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    try {
      String path = '/student/todo';
      final resp = await http.get(
        Uri.parse(uriV2 + path),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      log("todo resp: ${resp.body}");
      if (resp.statusCode == 200) {
        TodoListResponse tlr = TodoListResponse.fromJson(decodedBody);
        return tlr;
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

  Future<ResponseDataAfterCreateTodo> createTodoAdmin({
    required TodoModel todoModel,
    required List<String> asigneeId,
    required bool isSendToProgramSelectedFlag,
    required String selfSfId,
    required BuildContext context,
  }) async {
    print('CreateTodoAdminRepo');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final instituteId = isSendToProgramSelectedFlag
        ? BlocProvider.of<PendoMetaDataBloc>(context).state.instituteId
        : "";

    final body = {
      "name": todoModel.name,
      "description": todoModel.description,
      "status": todoModel.status,
      "type": todoModel.type,
      "venue": todoModel.venue,
      "eventAt": todoModel.eventAt,
      "completeBy": todoModel.completedBy,
      "listedBy": selfSfId,
      "assignee": asigneeId,
      "instituteId": instituteId,
      "reminderAt": todoModel.reminderAt
      // "approved_status": todoModel.approvalStatus.value,
    };
    log("Create todo body: $body");

    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/student/todo/create'),
        body: jsonEncode(body),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      print('createtodoresponse: ${resp.body}');
      if (resp.statusCode == 201) {
        /// Success
        return ResponseDataAfterCreateTodo.fromJson(decodedBody);
      } else if (decodedBody.containsKey('message')) {
        print(decodedBody['message']);
        throw CustomException(decodedBody['message'].toString());
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

  Future updateTodo({
    required List<String> taskId,
    required TodoModel todoModel,
    required List<Resources> newResources,
    required List<String> deletedResources,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };
    List<Map> newResorceSend = [];
    newResources.forEach((element) {
      newResorceSend.add(element.toJson());
    });
    final body = {
      "Id": taskId,
      "name": todoModel.name,
      "Description": todoModel.description,
      "status": todoModel.status,
      "type": todoModel.type,
      "venue": todoModel.venue,
      "eventAt": todoModel.eventAt,
      "completeBy": todoModel.completedBy == "9998-12-31T00:18:00.000Z"
          ? ""
          : todoModel.completedBy,
      "deletedResources": deletedResources,
      "newResources": newResorceSend,
    };
    print(body);
    try {
      final resp = await http.patch(
        Uri.parse(current_uri + '/student/updatetodo'),
        body: jsonEncode(body),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        /// Success
        print("done");
        print('success $decodedBody');
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

  Future<ResponseDataAfterCreateTodo> saveTodoAdmin(
      {required TodoModel todoModel,
      required List<String> asigneeId,
      required bool isSendToProgramSelectedFlag,
      required String selfSfId,
      required BuildContext context}) async {
    print('SaveTodoAdminRepo');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final instituteId = isSendToProgramSelectedFlag ? BlocProvider.of<PendoMetaDataBloc>(context).state.instituteId  : "";

    final body = {
      "name": todoModel.name,
      "description": todoModel.description,
      "status": todoModel.status,
      "type": todoModel.type,
      "venue": todoModel.venue,
      "eventAt": todoModel.eventAt,
      "completeBy": todoModel.completedBy,
      "listedBy": selfSfId,
      "assignee": asigneeId,
      "instituteId": instituteId,
      // "approved_status": todoModel.approvalStatus.value,
    };
    log("Save todo body: $body");

    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/student/todo/draft'),
        body: jsonEncode(body),
        headers: headers,
      );
      print('Save todo body: $body');

      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      print('savetodoresponse: ${resp.body}');
      if (resp.statusCode == 201) {
        /// Success
        return ResponseDataAfterCreateTodo.fromJson(decodedBody);
      } else if (decodedBody.containsKey('message')) {
        print(decodedBody['message']);
        throw CustomException(decodedBody['message'].toString());
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

  Future createResourcesTodo({
    required List<String> todoId,
    required List<Resources> resources,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final List<Map> responseSend = [];
    resources.forEach((element) {
      responseSend.add(element.toJson());
    });

    final body = {
      "todoId": todoId,
      "resources": responseSend,
    };

    try {
      final resp = await http.post(
        Uri.parse(current_uri + '/student/todoresources'),
        body: jsonEncode(body),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 201) {
        /// Success
        print("done");
        print('success $decodedBody');
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
}
