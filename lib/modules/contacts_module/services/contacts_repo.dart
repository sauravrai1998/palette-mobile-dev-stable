
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'dart:convert' as convert;
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsRepo {
ContactsRepo._privateConstructor();
  static final instance = ContactsRepo._privateConstructor();


  Future<ContactsResponse> getContacts() async {

    String path = '/opportunities/contactsList';

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('Access Token: $accessToken');

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    final request = http.Request('GET', Uri.parse(uriV2 + path));
    print('url for contactList: ${uriV2 + path}');
    request.headers.addAll(headers);

    try {
      var streamedResponse = await request.send();
      var resp = await http.Response.fromStream(streamedResponse);
      final Map<String, dynamic> decodedBody = convert.jsonDecode(resp.body);
      print(resp.statusCode);
      if (resp.statusCode == 200) {
        log(decodedBody.toString());
        return ContactsResponse.fromJson(decodedBody);
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

}