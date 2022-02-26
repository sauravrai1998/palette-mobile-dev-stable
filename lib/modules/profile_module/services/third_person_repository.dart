import 'dart:async';
import 'dart:convert' as convert;
import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/common_pendo_repo/dashboard_pendo_repo.dart';
import 'package:palette/modules/profile_module/models/user_models/abstract_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/admin_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/advisor_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/observer_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/parent_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/student_profile_user_model.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThirdPersonRepository {
  ThirdPersonRepository._privateConstructor();

  static final ThirdPersonRepository instance =
      ThirdPersonRepository._privateConstructor();

  Future<BaseProfileUserModel> getProfileUser(
      String studentId, String role,BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };
    var path = '/${_getRoleString(role: role)}/details/$studentId';
    print(path);
    try {
      final resp = await http.get(
        Uri.parse(current_uri + path),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      log('User Profile: $decodedBody');
      if (resp.statusCode == 200) {
        final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
        DashboardPendoRepo.trackOnTapStudentEvent(
            student: studentId, pendoState: pendoState);
        return _getProfileUser(json: decodedBody,role: role);
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

  String _getRoleString(
      {required String role}) {
    /// Returns user model based on the role of the user. Not yet dynamic
    /// Right now it is hardcoded for student.
    if (role == "Student") {
      return 'student';
    } else if (role == "Observer") {
      return 'observer';
    } else if (role == "Advisor" || role.toLowerCase() == "faculty/staff") {
      return 'advisor';
    } else if (role == "Admin" || role.toLowerCase() == "administrator") {
      return 'admin';
    } else {
      return 'parent';
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
    } else if (role == "Admin" || role.toLowerCase() == "administrator") {
      return AdminProfileUserModel.empty().fromJson(json: json);
    } else {
      return ParentProfileUserModel.empty().fromJson(json: json);
    }
  }

}
