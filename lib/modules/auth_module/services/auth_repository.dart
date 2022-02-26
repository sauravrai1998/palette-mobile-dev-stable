import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:palette/modules/auth_module/models/login_model.dart';
import 'package:palette/modules/auth_module/models/pre_register_response.dart';
import 'package:palette/modules/auth_module/models/uid_sfid_mapping_request.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preference_app_group/shared_preference_app_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/helpers.dart';

class AuthRepository {
  static String? accessToken;
  static String? refreshToken;
  static String? role;
  static String? sfuuid;
  AuthRepository._privateConstructor();
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static final AuthRepository instance = AuthRepository._privateConstructor();

  Future loginUser(LoginModel loginData) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };

    try {
      String body = convert.jsonEncode(loginData.toMap());
      var loginUri = Uri.parse(current_uri + '/auth/login');
      final resp = await http.post(
        loginUri,
        headers: headers,
        body: body,
      );

      Map<String, dynamic> responseDecoded = convert.jsonDecode(resp.body);
      print(
          'Login Response statusCode: ${resp.statusCode} and ${resp.body} and $loginUri');

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        role = responseDecoded['role'];
        accessToken = responseDecoded['data']['accessToken'];
        refreshToken = responseDecoded['data']['refreshToken'];
        sfuuid = responseDecoded['uuid'];
        print("sfuuid $sfuuid");
        if (responseDecoded.containsKey('userId')) {}

        final prefs = await _prefs;
        if (role == "Administrator") {
          await prefs.setString('role', "Admin");
        } else {
          await prefs.setString('role', role!);
        }
        await prefs.setString('accessToken', accessToken!);

       if (Platform.isIOS){
          await SharedPreferenceAppGroup.setAppGroup(iOSAppGroupId);
          await SharedPreferenceAppGroup.setString('accessToken', accessToken!);
          await SharedPreferenceAppGroup.setString('role', role!);
       }

        await prefs.setString('refreshToken', refreshToken!);
        await prefs.setString(saleforceUUIDConstant, sfuuid!);
      } else if (resp.statusCode == 404) {
        throw CustomException('User Not Found');
      } else if (resp.statusCode == 406) {
        throw CustomException('The password entered is incorrect');
      } else if (resp.statusCode == 400) {
        throw CustomException('The password entered is incorrect');
      } else if (resp.statusCode == 401) {
        if (responseDecoded.containsKey('message')) {
          throw CustomException(responseDecoded['message']);
        }
        throw CustomException(
            'Unauthorized Access. User not registered on Palette.');
      } else {
        throw CustomException('Something went wrong, try again later.');
      }
    } on SocketException {
      throw CustomException('No Internet connection');
    } on HttpException {
      throw CustomException('Something went wrong, try again later.');
    } on FormatException {
      throw CustomException('Bad request');
    }
  }

  Future<PreRegisterResponse> preRegister(LoginModel loginData) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };

    try {
      final map = loginData.toMap();
      final prefs = await SharedPreferences.getInstance();
      print(prefs.getString(roleFromUserExistAPIKey));
      map['role'] = prefs.getString(roleFromUserExistAPIKey);
      map['ferpa'] = true;
      final body = convert.jsonEncode(map);
      final resp = await http.post(
        Uri.parse(current_uri + '/auth/preregister'),
        headers: headers,
        body: body,
      );
      print('resp as following: ' + resp.body);
      print(resp.body);
      // if (convert.jsonDecode(resp.body).containsKey('message')) {
      //   throw CustomException(convert.jsonDecode(resp.body)['message']);
      // }
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        return PreRegisterResponse.fromJson(convert.jsonDecode(resp.body));
      } else if (resp.statusCode == 404) {
        throw CustomException(
            'We don\'t have your account details, please contact your Palette coordinator at your organization');
      } else if (resp.statusCode == 401) {
        throw CustomException(
            'Please login with your credentials or use the forgot password option to reset your password');
      } else if (resp.statusCode == 400) {
        throw CustomException('Something went wrong!');
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
      throw CustomException(e.toString());
    }
  }

  Future<void> forgotPassword(String email) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };

    try {
      String body = convert.jsonEncode({"email": email});
      final resp = await http.post(
        Uri.parse(current_uri + '/auth/forgotpassword'),
        headers: headers,
        body: body,
      );

      if (resp.statusCode == 201 || resp.statusCode == 200) {
        ///
      } else if (resp.statusCode == 401) {
        throw CustomException(
            'Unauthorized Access. User not registered on Palette.');
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
      throw CustomException(e.toString());
    }
  }

  Future<void> checkUserExist(String email) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };

    try {
      String body = convert.jsonEncode({"email": email});
      final resp = await http.post(
        Uri.parse(current_uri + '/auth/authenticate'),
        headers: headers,
        body: body,
      );
      Map responseDecoded = convert.jsonDecode(resp.body);
      print(responseDecoded);
      print(resp.statusCode);
      if (responseDecoded.containsKey('message')) {
        if (responseDecoded['message'] == 'User registered on palette') {
          throw CustomException(
              'Your email address has already been used to register. Please login with your credentials or use a different email');
        }
      }
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        ///Success
        final json = convert.jsonDecode(resp.body) as Map<String, dynamic>;
        final data = json['data'] as Map<String, dynamic>;
        final prefs = await SharedPreferences.getInstance();
        print(data['role']!);
        prefs.setString(roleFromUserExistAPIKey,
            data['role'] == 'Administrator' ? 'Admin' : data['role']!);
      } else if (resp.statusCode == 404) {
        throw CustomException(
            'Your account details were not found, please contact your Palette coordinator from your organisation.');
      } else if (resp.statusCode == 401) {
        throw CustomException(
            'Unauthorized Access. User not registered on Palette.');
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
      throw CustomException(e.toString());
    }
  }

  Future<void> postFirebaseUidMapping(
      UidSFidMappingRequest uidSFidMappingRequest) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };

    try {
      String body = convert.jsonEncode(uidSFidMappingRequest.toJson());
      final resp = await http.post(
        Uri.parse(current_uri + '/firebase/uuid'),
        headers: headers,
        body: body,
      );

      Map responseDecoded = convert.jsonDecode(resp.body);
      print('postFirebaseUidMapping: $responseDecoded');
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        ///Success
      } else if (resp.statusCode == 400) {
        throw CustomException('User already exists');
      } else if (resp.statusCode == 401) {
        throw CustomException('Unauthorized Access');
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
      throw CustomException(e.toString());
    }
  }
}
