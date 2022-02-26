import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/explore_module/models/create_opportunity_model.dart';
import 'package:palette/modules/explore_module/models/modification_request_model.dart';
import 'package:palette/modules/explore_module/models/opp_created_by_me_response.dart';
import 'package:palette/modules/explore_module/models/recipients_response.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpportunityRepository {
  static OpportunityRepository instance = OpportunityRepository();

  Future opportunityBulkAddToTodo(List<String> ids) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final role = prefs.getString('role').toString();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final body = {"opportunities": ids};
    final path = role.toLowerCase() == 'student'
        ? '/opportunities/bulk/edit/student'
        : '/opportunities/bulk/todo';
    try {
      final resp = await http.post(
        Uri.parse(current_uri + path),
        body: jsonEncode(body),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        print('Opportunity Bulk added to Todo $decodedBody');
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

  Future addOpportunitiesToTodo(
      {required List<String> oppIds,
      required List<String> assigneesIds,
      required bool instituteId,
      required BuildContext context}) async {
    print('addOpportunitiesToTodo body');
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final body = instituteId
        ? {
            "opportunityTodoDto": {
              "opportunityIds": oppIds,
              "assigneesIds": assigneesIds,
              "instituteId": pendoState.instituteId
            }
          }
        : {
            "opportunityTodoDto": {
              "opportunityIds": oppIds,
              "assigneesIds": assigneesIds
            }
          };
    final path = '/opportunities/bulk/opp/todo';
    log('addOpportunitiesToTodo body $body');
    try {
      final resp = await http.post(
        Uri.parse(uriV2 + path),
        body: jsonEncode(body),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      log('Resp Opportunities Bulk added to Todo ${resp.body}');
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
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

  Future opportunityBulkShare(
    List<String> oppIds,
    List<String> userIds,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final body = {
      "opportunityIds": oppIds,
      "assigneesIds": userIds,
    };
    final path = uriV2 + '/opportunities/share';
    print("pathtoshare: $path");

    try {
      final resp = await http.post(
        Uri.parse(path),
        body: jsonEncode(body),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        log('Opportunity Bulk saring $decodedBody');
        // if the Opportunity is already shared with the user
        if (decodedBody['data'] != null) {
          const String _message = 'Already Recommended';
          List<dynamic> data = decodedBody['data'];
          data.forEach((element) {
            if (element['Message'] == _message) {
              throw CustomException(
                  'You\'ve already shared with some of the recipients');
            }
          });
        }
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

  Future opportunityBulkConsiderations(List<String> ids) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final sfid = prefs.getString(sfidConstant);
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final body = {"opportunities": ids};
    final path = '/opportunities/bulk/save';
    try {
      final resp = await http.post(
        Uri.parse(uriV2 + path),
        body: jsonEncode(body),
        headers: headers,
      );
      log('Opportunities Bulk Considerations $body');
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        print('Opportunity Bulk added to considerations ${resp.body}');
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

  Future createOpportunitybyStudent(
      {required OpportunitiesModel opportunitiesInfoDto}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final sfid = prefs.getString(sfidConstant);
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final body = {
      "opportunitiesInfoDto": {
        "eventTitle": opportunitiesInfoDto.eventTitle,
        "description": opportunitiesInfoDto.description,
        "eventDateTime": opportunitiesInfoDto.eventDateTime?.toUtc().toString(),
        "expirationDateTime":
            opportunitiesInfoDto.expirationDateTime.toString(),
        "phone": opportunitiesInfoDto.phone,
        "website": opportunitiesInfoDto.website,
        "venue": opportunitiesInfoDto.venue,
        "eventType": opportunitiesInfoDto.eventType,
      },
      "assignees": ["$sfid"],
      "InstituteId": ""
    };
    print('create opporunity for student body: $body');
    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/opportunities/add'),
        body: jsonEncode(body),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        print('success $decodedBody');
        //return ResponseDataAfterCreateTodo.fromJson(decodedBody['data']);
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
      print('error ' + e.toString());
      throw CustomException(e.toString());
    }
  }

  Future createOpportunityForAllRoles({
    required OpportunitiesModel opportunitiesInfoDto,
    required List<String> assginesId,
    required bool isGlobal,
    required BuildContext context,
  }) async {
    print('todoModel: ${opportunitiesInfoDto.description}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    // "InstituteId": "0014x00000D76KHAAZ"
    final body = isGlobal
        ? {
            "opportunitiesInfoDto": {
              "eventTitle": opportunitiesInfoDto.eventTitle,
              "description": opportunitiesInfoDto.description,
              "eventDateTime":
                  opportunitiesInfoDto.eventDateTime?.toUtc().toString(),
              "expirationDateTime":
                  opportunitiesInfoDto.expirationDateTime.toString(),
              "phone": opportunitiesInfoDto.phone,
              "website": opportunitiesInfoDto.website,
              "venue": opportunitiesInfoDto.venue,
              "eventType": opportunitiesInfoDto.eventType,
            },
            "assignees": [],
            "InstituteId": pendoState.instituteId,
          }
        : {
            "opportunitiesInfoDto": {
              "eventTitle": opportunitiesInfoDto.eventTitle,
              "description": opportunitiesInfoDto.description,
              "eventDateTime":
                  opportunitiesInfoDto.eventDateTime?.toUtc().toString(),
              "expirationDateTime":
                  opportunitiesInfoDto.expirationDateTime.toString(),
              "phone": opportunitiesInfoDto.phone,
              "website": opportunitiesInfoDto.website,
              "venue": opportunitiesInfoDto.venue,
              "eventType": opportunitiesInfoDto.eventType,
            },
            "assignees": assginesId,
            "InstituteId": ""
          };

    print('create opporunity body: $body');

    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/opportunities/add'),
        body: jsonEncode(body),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        print('success $decodedBody');
        //return ResponseDataAfterCreateTodo.fromJson(decodedBody['data']);
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

  Future editOpportunityforDiscrete(
      {required OpportunitiesModel opportunitiesInfoDto,
      required List<String> recipientIds,
      required String opportunityId}) async {
    print('opportunityModel: ${opportunitiesInfoDto.description}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final sfid = prefs.getString(sfidConstant);
    final role = prefs.getString('role');
    bool isStudent = role?.toLowerCase() == 'student';
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final body = {
      "opportunitiesInfoDto": {
        "eventTitle": opportunitiesInfoDto.eventTitle,
        "description": opportunitiesInfoDto.description,
        "eventDateTime": opportunitiesInfoDto.eventDateTime?.toIso8601String(),
        "expirationDateTime":
            opportunitiesInfoDto.expirationDateTime?.toIso8601String(),
        "phone": opportunitiesInfoDto.phone,
        "website": opportunitiesInfoDto.website,
        "venue": opportunitiesInfoDto.venue,
        "eventType": opportunitiesInfoDto.eventType,
      },
      "opportunityId": opportunityId,
      "recipientIds": isStudent ? [sfid] : recipientIds
    };
    print('Update opporunity for other discrete body: $body');
    try {
      final resp = await http.patch(
        Uri.parse(uriV2 + '/opportunities/edit/discrete'),
        body: jsonEncode(body),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      log('resp.body ${resp.body}');
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        log('success ${resp.body}');
        //return ResponseDataAfterCreateTodo.fromJson(decodedBody['data']);
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

  Future editOpportunitybyOtherGlobal(
      {required OpportunitiesModel opportunitiesInfoDto,
      required String opportunityId}) async {
    print('todoModel: ${opportunitiesInfoDto.description}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final body = {
      "opportunitiesInfoDto": {
        "eventTitle": opportunitiesInfoDto.eventTitle,
        "description": opportunitiesInfoDto.description,
        "eventDateTime": opportunitiesInfoDto.eventDateTime?.toIso8601String(),
        "expirationDateTime":
            opportunitiesInfoDto.expirationDateTime?.toIso8601String(),
        "phone": opportunitiesInfoDto.phone,
        "website": opportunitiesInfoDto.website,
        "venue": opportunitiesInfoDto.venue,
        "eventType": opportunitiesInfoDto.eventType
      },
      "opportunityId": opportunityId
    };
    print('Update opporunity for other global body: $body');
     print("////////////////////////Edit Check");
    print("Globla called");
    print("////////////////////////Edit Check");
    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/opportunities/edit/global'),
        body: jsonEncode(body),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        print('success $decodedBody');
        //return ResponseDataAfterCreateTodo.fromJson(decodedBody['data']);
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

  Future editDraftOpportunityToLive(
      {required OpportunitiesModel opportunitiesInfoDto,
      required List<String> recipientIds,
        required bool isGlobal,
        required BuildContext context,
      required String opportunityId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;

    final body = isGlobal
        ? {
      "opportunityId": opportunityId,
      "opportunitiesInfoDto": {
        "eventTitle": opportunitiesInfoDto.eventTitle,
        "description": opportunitiesInfoDto.description,
        "eventDateTime": opportunitiesInfoDto.eventDateTime.toString(),
        "expirationDateTime":
        opportunitiesInfoDto.expirationDateTime.toString(),
        "phone": opportunitiesInfoDto.phone,
        "website": opportunitiesInfoDto.website,
        "venue": opportunitiesInfoDto.venue,
        "eventType": opportunitiesInfoDto.eventType,
      },
      "assignees": pendoState.role.toLowerCase() == 'student'?[pendoState.accountId]:recipientIds,
      "InstituteId": pendoState.instituteId
    }
        : {
      "opportunityId": opportunityId,
      "opportunitiesInfoDto": {
        "eventTitle": opportunitiesInfoDto.eventTitle,
        "description": opportunitiesInfoDto.description,
        "eventDateTime": opportunitiesInfoDto.eventDateTime.toString(),
        "expirationDateTime":
        opportunitiesInfoDto.expirationDateTime.toString(),
        "phone": opportunitiesInfoDto.phone,
        "website": opportunitiesInfoDto.website,
        "venue": opportunitiesInfoDto.venue,
        "eventType": opportunitiesInfoDto.eventType,
      },
      "assignees": pendoState.role.toLowerCase() == 'student'?[pendoState.accountId]:recipientIds,
      "InstituteId": ""
    };

    print('Update draft opporunity to live body: $body');
    try {
      final resp = await http.patch(
        Uri.parse(uriV2 + '/opportunities/draft/live'),
        body: jsonEncode(body),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        print('success $decodedBody');
        //return ResponseDataAfterCreateTodo.fromJson(decodedBody['data']);
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

  Future saveOpportunitybyStudent(
      {required OpportunitiesModel opportunitiesInfoDto}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    //final sfid = prefs.getString(sfidConstant);
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final body = {
      "opportunitiesInfoDto": {
        "eventTitle": opportunitiesInfoDto.eventTitle,
        "description": opportunitiesInfoDto.description,
        "eventDateTime": opportunitiesInfoDto.eventDateTime.toString(),
        "expirationDateTime":
            opportunitiesInfoDto.expirationDateTime.toString(),
        "phone": opportunitiesInfoDto.phone,
        "website": opportunitiesInfoDto.website,
        "venue": opportunitiesInfoDto.venue,
        "eventType": opportunitiesInfoDto.eventType,
      },
     // "assignees": ['$sfid'],
      "assignees": [],
      "InstituteId": ""
    };
    print('save opporunity for student body: $body');
    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/opportunities/draft'),
        body: jsonEncode(body),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        print('success $decodedBody');
        //return ResponseDataAfterCreateTodo.fromJson(decodedBody['data']);
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

  Future saveOpportunitybyOthersRole(
      {required OpportunitiesModel opportunitiesInfoDto,
      required List<String> assginesId,
      required bool isGlobal,
      required BuildContext context}) async {
    print('todoModel: ${opportunitiesInfoDto.description}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;

    // TAWS "InstituteId": "0014x00000D76KHAAZ"
    // NPSP "InstituteId": "0014x00000rHnmiAAC"

    final body = isGlobal
        ? {
            "opportunitiesInfoDto": {
              "eventTitle": opportunitiesInfoDto.eventTitle,
              "description": opportunitiesInfoDto.description,
              "eventDateTime": opportunitiesInfoDto.eventDateTime.toString(),
              "expirationDateTime":
                  opportunitiesInfoDto.expirationDateTime.toString(),
              "phone": opportunitiesInfoDto.phone,
              "website": opportunitiesInfoDto.website,
              "venue": opportunitiesInfoDto.venue,
              "eventType": opportunitiesInfoDto.eventType,
            },
            "assignees": assginesId,
            "InstituteId": pendoState.instituteId
          }
        : {
            "opportunitiesInfoDto": {
              "eventTitle": opportunitiesInfoDto.eventTitle,
              "description": opportunitiesInfoDto.description,
              "eventDateTime": opportunitiesInfoDto.eventDateTime.toString(),
              "expirationDateTime":
                  opportunitiesInfoDto.expirationDateTime.toString(),
              "phone": opportunitiesInfoDto.phone,
              "website": opportunitiesInfoDto.website,
              "venue": opportunitiesInfoDto.venue,
              "eventType": opportunitiesInfoDto.eventType,
            },
            "assignees": assginesId,
            "InstituteId": ""
          };
    print('save opporunity body: $body');
    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/opportunities/draft'),
        body: jsonEncode(body),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      print(decodedBody);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        print('success $decodedBody');
        //return ResponseDataAfterCreateTodo.fromJson(decodedBody['data']);
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

  Future saveEditedOpportunity(
      {required OpportunitiesModel opportunitiesInfoDto,
      required List<String> assginesId,
      required bool isGlobal,
      required BuildContext context,
      required String opportunityId}) async {
    print('todoModel: ${opportunitiesInfoDto.description}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;

    // TAWS "InstituteId": "0014x00000D76KHAAZ"
    // NPSP "InstituteId": "0014x00000rHnmiAAC"

    final body = isGlobal
        ? {
            "opportunityId": opportunityId,
            "opportunitiesInfoDto": {
              "eventTitle": opportunitiesInfoDto.eventTitle,
              "description": opportunitiesInfoDto.description,
              "eventDateTime": opportunitiesInfoDto.eventDateTime.toString(),
              "expirationDateTime":
                  opportunitiesInfoDto.expirationDateTime.toString(),
              "phone": opportunitiesInfoDto.phone,
              "website": opportunitiesInfoDto.website,
              "venue": opportunitiesInfoDto.venue,
              "eventType": opportunitiesInfoDto.eventType,
            },
            "assignees": pendoState.role.toLowerCase() == 'student'?[pendoState.accountId]:assginesId,
            "InstituteId": pendoState.instituteId
          }
        : {
             "opportunityId": opportunityId,
            "opportunitiesInfoDto": {
              "eventTitle": opportunitiesInfoDto.eventTitle,
              "description": opportunitiesInfoDto.description,
              "eventDateTime": opportunitiesInfoDto.eventDateTime.toString(),
              "expirationDateTime":
                  opportunitiesInfoDto.expirationDateTime.toString(),
              "phone": opportunitiesInfoDto.phone,
              "website": opportunitiesInfoDto.website,
              "venue": opportunitiesInfoDto.venue,
              "eventType": opportunitiesInfoDto.eventType,
            },
            "assignees": pendoState.role.toLowerCase() == 'student'?[pendoState.accountId]:assginesId,
            "InstituteId": ""
          };
    print('save draft opporunity body: $body');
    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/opportunities/edit/draft'),
        body: jsonEncode(body),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      print(decodedBody);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        print('success $decodedBody');
        //return ResponseDataAfterCreateTodo.fromJson(decodedBody['data']);
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

  Future<RecipientsResponse> getAllRecipients() async {
    String path;
    final prefs = await SharedPreferences.getInstance();
    // final String role = prefs.getString('role').toString();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    path = '/opportunities/recipients';

    final request = http.Request('GET', Uri.parse(uriV2 + path));
    print('url: : ${uriV2 + path}');

    request.headers.addAll(headers);

    try {
      var streamedResponse = await request.send();
      var resp = await http.Response.fromStream(streamedResponse);

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('some thing $decodedBody');
      if (resp.statusCode == 200) {
        return RecipientsResponse.fromJson(decodedBody);
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

  Future setOpportunityVisibility(
      {required OpportunityVisibility visibilty,
      required String opporunityId,
      String? message}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };
    final body = {
      "visibilityDto": {
        "opportunityId": opporunityId,
        "message": message ?? "Optional message",
        "visibility": visibilty.name
      }
    };
    print('set opporunity\'s visibilty body: $body');
    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/opportunities/visibility'),
        body: jsonEncode(body),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        log('success $decodedBody');
        //return ResponseDataAfterCreateTodo.fromJson(decodedBody['data']);
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
      print('error ' + e.toString());
      throw CustomException(e.toString());
    }
  }

  Future setBulkOpportunityVisibility(
      {required OpportunityVisibility visibilty,
      required List<String> opporunityIds,
      String? message}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };
    print(visibilty.name);
    final body = {
      "opportunityIds": opporunityIds,
      "hidingStatus": visibilty.name
    };
    print('set bulk opporunity\'s visibilty body: $body');
    try {
      final resp = await http.patch(
        Uri.parse(uriV2 + '/opportunities/visibility'),
        body: jsonEncode(body),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        log('success $decodedBody');
        //return ResponseDataAfterCreateTodo.fromJson(decodedBody['data']);
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
      print('error ' + e.toString());
      throw CustomException(e.toString());
    }
  }

  Future deleteBulkOpportunities(
      {required List<String> opportunityIds, String? message}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };
    final body = {
      "opportunityIds": opportunityIds,
      "message": message ?? "Optional message"
    };
    print('set bulk opporunity\'s visibilty body: $body');
    try {
      final resp = await http.patch(
        Uri.parse(uriV2 + '/opportunities/delete'),
        body: jsonEncode(body),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        log('success $decodedBody');
        //return ResponseDataAfterCreateTodo.fromJson(decodedBody['data']);
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
      print('error ' + e.toString());
      throw CustomException(e.toString());
    }
  }

  Future<ModificationRequestResponse> getModificationDetail(
      {required String modificationId}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken ');
    final role = prefs.getString('role')!;
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };
    try {
      final resp = await http.get(
        Uri.parse(uriV2 + '/opportunities/modification/$modificationId'),
        headers: headers,
      );

      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print('Modification details: $decodedBody');
      if (resp.statusCode == 200) {
        print(resp.statusCode);
        return ModificationRequestResponse.fromJson(decodedBody);
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

  Future cancelModificationRequest(
      {required String opportunityId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final sfid = prefs.getString(sfidConstant);
    final role = prefs.getString('role');
    bool isStudent = role?.toLowerCase() == 'student';
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };
    print(uriV2 + '/opportunities/modification/cancel/$opportunityId');
    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/opportunities/modification/cancel/$opportunityId'),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      log('resp.body ${resp.body}');
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        log('success ${resp.body}');
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
  Future cancelRemovalRequest(
      {required String opportunityId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final sfid = prefs.getString(sfidConstant);
    final role = prefs.getString('role');
    bool isStudent = role?.toLowerCase() == 'student';
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json",
    };

    try {
      final resp = await http.post(
        Uri.parse(uriV2 + '/opportunities/removal/cancel/$opportunityId'),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      log('resp.body ${resp.body}');
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        /// Success
        print("done");
        log('success ${resp.body}');
        //return ResponseDataAfterCreateTodo.fromJson(decodedBody['data']);
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
}
