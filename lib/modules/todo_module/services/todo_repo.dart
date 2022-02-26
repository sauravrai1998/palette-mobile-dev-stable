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

class TodoRepo {
  TodoRepo._privateConstructor();
  static final instance = TodoRepo._privateConstructor();

  Map<String, dynamic>? globalTodoNotifData;

  Future<TodoListResponse> fetchTodoList(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Student id: nm');
    print('Student id: $studentId');
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    try {
      // String path =
      // studentId != '' ? '/student/task/$studentId' : '/student/todo';
      // final uri = current_uri + path;
      final String uri;
      if (studentId.isNotEmpty) {
        uri = uriV2 + '/student/task/$studentId';
      } else {
        uri = uriV2 + '/student/todo';
      }

      print(uri);
      final resp = await http.get(
        Uri.parse(uri),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        log('todo response: ${resp.body}');
        return TodoListResponse.fromJson(decodedBody);
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

  Future updateTodoStatus({
    required String taskId,
    required String status,
    required String note
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    // final body = {
    //   "taskId": taskId,
    //   "status": status,
    // };
    final body = {"status": status};
    print('updateTodoStatus: $body');
    final path = uriV2 + '/student/todo/update/status/$taskId';
    print(path);

    try {
      final resp = await http.post(
        Uri.parse(path),
        body: jsonEncode(body),
        headers: headers,
      );
      log("Response for updating todo status is:${resp.body}");

      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        /// Success
        print("done");
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
      print('Err ${e.toString()}');
      throw CustomException(e.toString());
    }
  }

  Future<bool>? updateTodoStatusBulk({
    required List<String> todoIds,
    required String status,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final body = {"todoIds": todoIds, "status": status};
    log('bodyofbulkedittodo: ${jsonEncode(body)}');
    log('urlofbulkedittodo: ${uriV2 + '/student/todo/update/bulk/status'}');

    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/student/todo/update/bulk/status'),
        body: jsonEncode(body),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      log('responseofbulkedittodo: $decodedBody');
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        /// Success
        return true;
      } else if (decodedBody.containsKey('message')) {
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

  Future updateTodoArchiveStatus({
    required String taskId,
    required bool archived,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final body = {
      "taskId": taskId,
      "archived": archived,
    };

    try {
      final resp = await http.patch(
        Uri.parse(current_uri + '/student/archivetodo'),
        body: jsonEncode(body),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);

      print('message $decodedBody');
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

  Future<ResponseDataAfterCreateTodo> createTodo({
    required TodoModel todoModel,
    required String selfSfId,
    required bool isSendToProgramSelectedFlag,
    required List<String> asigneeList,
    required BuildContext context,
  }) async {
    print('todoModel: ${todoModel.type}');
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
      print('decodedBody: $decodedBody');
      if (resp.statusCode == 201) {
        /// Success
        print("done");
        print('success $decodedBody');
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
      print('error' + e.toString());
      throw CustomException(e.toString());
    }
  }

  Future<ResponseDataAfterCreateTodo> saveTodo({
    required TodoModel todoModel,
    required String selfSfId,
    required bool isSendToProgramSelectedFlag,
    required List<String> asigneeList,
    required BuildContext context,
  }) async {
    print(isSendToProgramSelectedFlag);
    print('todoModel: ${todoModel.type}');
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
      print('decodedBody: $decodedBody');
      if (resp.statusCode == 201) {
        /// Success
        print("done");
        print('success $decodedBody');
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
      print('error' + e.toString());
      throw CustomException(e.toString());
    }
  }

  Future updateTodo({
    required List<String> ids,
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
      "Id": ids,
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
      "archived": todoModel.isArchive,
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
      print('response: $decodedBody');
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
    required List<String> ids,
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
      "todoId": ids,
      "resources": responseSend,
    };
    print('body: $body');
    try {
      final resp = await http.post(
        Uri.parse(current_uri + '/student/todoresources'),
        body: jsonEncode(body),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      print('response: $decodedBody');
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

  Future publishDraftTodo({required String id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final body = {
      "Id": id,
    };
    print(body);
    try {
      final resp = await http.patch(
        Uri.parse(uriV2 + '/student/todo/publish/draft'),
        headers: headers,
        body: jsonEncode(body),
      );

      print(resp.statusCode);
      print(resp);
      print(resp.body);
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("accept todo success");
        print('success $decodedBody');
      } else if (decodedBody.containsKey('message')) {
        throw CustomException(decodedBody['message']);
      }
      else {
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

  Future acceptTodo({required String id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/student/todo/requested/accept/$id'),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      print('accept todo: $decodedBody');
      print("$uriV2" + "/student/todo/requested/accept/$id");
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("accept todo success");
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

  Future rejectTodo({required String id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/student/todo/requested/reject/$id'),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      print('reject todo: $decodedBody');
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("reject todo success");
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

  Future bulkAcceptTodo({required List<String> todoIds}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final body = {"todoIds": todoIds};

    try {
      print(uriV2 + '/student/todo/requested/accept');
      final resp = await http.post(
        Uri.parse(uriV2 + '/student/todo/requested/bulk/accept'),
        body: jsonEncode(body),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      print('accept todo bulk: $decodedBody');
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("accept todo bulk success: $decodedBody");
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

  Future bulkRejectTodo({required List<String> todoIds}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final body = {"todoIds": todoIds};

    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/student/todo/requested/bulk/reject'),
        body: jsonEncode(body),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      print('reject todo bulk: $decodedBody');
      if (resp.statusCode == 201 || resp.statusCode == 200) {
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
}
