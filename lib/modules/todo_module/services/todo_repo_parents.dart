import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:palette/modules/todo_module/models/createtodo_response_model.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_model.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common_blocs/pendo_meta_data_bloc.dart';

class TodoRepoParents {
  TodoRepoParents._privateConstructor();
  static final instance = TodoRepoParents._privateConstructor();

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
      if (resp.statusCode == 200) {
        log('todoResp for parent: ${resp.body}');
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

  Future<ResponseDataAfterCreateTodo> createTodoParent({
    required TodoModel todoModel,
    required List<String> asigneeList,
    required bool isSendToProgramSelectedFlag,
    required BuildContext context,
    required String selfSfId,
  }) async {
    print('CreateTodoParentRepo');
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
      "assignee": asigneeList,
      "instituteId": instituteId,
      "reminderAt": todoModel.reminderAt
      // "approved_status": todoModel.approvalStatus.value,
    };
    print('create todo body: $body');
    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/student/todo/create'),
        body: jsonEncode(body),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
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

  Future<ResponseDataAfterCreateTodo> saveTodoParent({
    required TodoModel todoModel,
    required List<String> asigneeList,
    required bool isSendToProgramSelectedFlag,
    required String selfSfId,
    required BuildContext context,
  }) async {
    print('CreateTodoParentRepo');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final instituteId = isSendToProgramSelectedFlag ? BlocProvider.of<PendoMetaDataBloc>(context).state.instituteId : "";

    final body = {
      "name": todoModel.name,
      "description": todoModel.description,
      "status": todoModel.status,
      "type": todoModel.type,
      "venue": todoModel.venue,
      "eventAt": todoModel.eventAt,
      "completeBy": todoModel.completedBy,
      "listedBy": selfSfId,
      "assignee": asigneeList,
      "instituteId": instituteId,
      // "approved_status": todoModel.approvalStatus.value,
    };
    print('save todo body: $body');
    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/student/todo/draft'),
        body: jsonEncode(body),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      print(decodedBody);
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
      "reminderAt": todoModel.reminderAt
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

  Future saveResourcesTodo({
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
