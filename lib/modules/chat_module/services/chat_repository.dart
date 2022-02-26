import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart' as http;
import 'package:ntp/ntp.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/chat_module/models/chat_contact_list.dart';
import 'package:palette/modules/chat_module/models/message_model.dart';
import 'package:palette/utils/helpers.dart';
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  ChatRepository._privateConstructor();

  static final ChatRepository instance = ChatRepository._privateConstructor();

  static Map<String, String> usersUidMap = {};

  static saveUsersMappingToSharedPrefs(List<types.User> users) async {
    Map<String, String> userListJson = {};

    userListJson.addEntries(
      users.map((e) {
        if (e.firstName == null) {
          print('empty map entry');
          return MapEntry('', '');
        }
        final firstName = e.firstName ?? '';
        final lastName = e.lastName ?? '';
        final name = firstName + ' ' + lastName;
        return MapEntry(e.id, name);
      }),
    );

    print('saved: $userListJson');

    final _prefs = prefs;
    final encodedData = jsonEncode(userListJson);
    await _prefs.setString(userMappingKeyForUidNameMapping, encodedData);
    retrieveAndSetUsersMappingFromSharedPrefs();
  }

  static retrieveAndSetUsersMappingFromSharedPrefs() {
    final _prefs = prefs as SharedPreferences;
    final _usersUidMap = _prefs.getString(userMappingKeyForUidNameMapping);
    if (_usersUidMap == null) return {};
    usersUidMap = Map.from(jsonDecode(_usersUidMap));
    print('retrieved: $usersUidMap');
  }

  Future<List<ChatContact>> getChatContactList() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };
    try {
      final resp = await http.get(
        Uri.parse(uriV1 + '/firebase/uuid'),
        headers: headers,
      );
      final Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        final chatContactList = ChatContactList.fromJson(decodedBody);

        /// Filtering if uuid is not present in firebase
        // final json = await FirebaseFirestore.instance.collection('users').get();
        // List<String> allUids = [];
        // json.docs.forEach((element) {
        //   allUids.add(element.id);
        // });
        //
        // return chatContactList.chatContactList
        //     .where((element) => allUids.contains(element.uuid))
        //     .toList();
        return chatContactList.chatContactList;
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

  Future setUnreadMessagesStatusToReadForDirectChat(
      {required String roomId}) async {
    final json = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .get();

    final jsonDocs = json.docs;
    if (jsonDocs.isEmpty) return;

    /// Sorting according to message times.
    jsonDocs.sort((a, b) {
      final firstJson = a.data();
      final secondJson = b.data();
      final Timestamp timeForFirst = firstJson['timestamp'];
      final Timestamp timeForSecond = secondJson['timestamp'];
      final dateForFirst = DateTime.fromMicrosecondsSinceEpoch(
          timeForFirst.microsecondsSinceEpoch);
      final dateForSecond = DateTime.fromMicrosecondsSinceEpoch(
          timeForSecond.microsecondsSinceEpoch);
      return dateForFirst.compareTo(dateForSecond);
    });

    final reversed = jsonDocs.reversed.toList();

    /// Traversing over each message that is unread to make it read.
    for (var i = 0; i < reversed.length; i++) {
      final json = reversed[i];
      final jsonData = json.data();

      final messageId = json.id;
      final message = MessageModel.fromJson(json: jsonData);

      /// We get first read message we step out of the loop.
      if (message.status == 'read') break;

      final selfUid = FirebaseChatCore.instance.firebaseUser!.uid;
      if (message.authorId != selfUid) {
        jsonData.update('status', (value) => 'read');
      }

      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .doc(messageId)
          .set(jsonData, SetOptions(merge: false));
    }
  }

  Future setUnreadMessagesStatusToReadForGroupChat({String? roomId}) async {
    final json = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .get();

    final jsonDocs = json.docs;
    if (jsonDocs.isEmpty) return;

    /// Sorting according to message times.
    jsonDocs.sort((a, b) {
      final firstJson = a.data();
      final secondJson = b.data();
      final Timestamp timeForFirst = firstJson['timestamp'];
      final Timestamp timeForSecond = secondJson['timestamp'];
      final dateForFirst = DateTime.fromMicrosecondsSinceEpoch(
          timeForFirst.microsecondsSinceEpoch);
      final dateForSecond = DateTime.fromMicrosecondsSinceEpoch(
          timeForSecond.microsecondsSinceEpoch);
      return dateForFirst.compareTo(dateForSecond);
    });

    final reversed = jsonDocs.reversed.toList();

    /// Traversing over each message that is unread to make it read.
    for (var i = 0; i < reversed.length; i++) {
      final selfUid = FirebaseChatCore.instance.firebaseUser!.uid;
      final json = reversed[i];
      final jsonData = json.data();

      final messageId = json.id;
      final message = MessageModel.fromJson(json: jsonData);

      if (message.groupStatus == null) break;
      final groupStatus = message.groupStatus!;

      /// We get first read message we step out of the loop.
      if (groupStatus[selfUid] == 'read') break;
      groupStatus[selfUid] = 'read';

      if (message.authorId != selfUid) {
        jsonData.update('groupStatus', (value) => groupStatus);
      }

      /// Read receipts
      var seenByAll = true;
      message.groupStatus!.forEach((key, value) {
        if (key != message.authorId && value != 'read') seenByAll = false;
      });

      if (seenByAll == true) jsonData.update('status', (value) => 'read');

      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .doc(messageId)
          .set(jsonData, SetOptions(merge: false));
    }
  }

  Future postLatestMessageStatusToReadForDirectChat({
    required String messageId,
    required String roomId,
  }) async {
    final selfUid = FirebaseChatCore.instance.firebaseUser!.uid;

    final json = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(messageId)
        .get();

    final messageJsonData = json.data();
    if (messageJsonData == null) return;

    if (messageJsonData['status'] != 'read' &&
        messageJsonData['authorId'] != selfUid) {
      messageJsonData.update('status', (value) => 'read');
    }

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(messageId)
        .set(messageJsonData, SetOptions(merge: false));
  }

  Future postLatestMessageStatusToReadForGroupChat({
    required String messageId,
    required String roomId,
  }) async {
    final selfUid = FirebaseChatCore.instance.firebaseUser!.uid;

    final json = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(messageId)
        .get();

    final messageJsonData = json.data();
    if (messageJsonData == null) return;

    Map<String, dynamic> groupStatusMap = messageJsonData['groupStatus'];

    if (groupStatusMap[selfUid] != 'read' &&
        messageJsonData['authorId'] != selfUid) {
      groupStatusMap.update(selfUid, (value) => 'read');
    }

    messageJsonData['groupStatus'] = groupStatusMap;

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(messageId)
        .set(messageJsonData, SetOptions(merge: false));
  }

  Future<String> uploadToFirebase(types.Room room, File _image) async {
    final jsonId =
        FirebaseFirestore.instance.collection('rooms').doc(room.id).id;
    final jsonDataId = jsonId;

    final file = File(_image.path);
    final reference =
        FirebaseStorage.instance.ref().child('group_chat_pictures/$jsonDataId');
    await reference.putFile(file);
    final uri = await reference.getDownloadURL();
    print(uri);

    final json =
        await FirebaseFirestore.instance.collection('rooms').doc(room.id).get();
    final jsonData = json.data();
    print(jsonData);
    if (jsonData == null) return '';
    jsonData.update('imageUrl', (value) => uri);

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(room.id)
        .set(jsonData, SetOptions(merge: false));
    return uri;
  }

  Future<String> updateFirebaseStorage(types.Room room, File _image) async {
    final jsonId =
        FirebaseFirestore.instance.collection('rooms').doc(room.id).id;
    final jsonDataId = jsonId;

    final file = File(_image.path);
    final reference =
        FirebaseStorage.instance.ref().child('group_chat_pictures/$jsonDataId');
    await reference.putFile(file);
    final uri = await reference.getDownloadURL();
    print(uri);
    return uri;
  }

  Future<bool> updateFirestore(types.Room room, String uri) async {
    final json =
        await FirebaseFirestore.instance.collection('rooms').doc(room.id).get();
    final jsonData = json.data();
    if (jsonData == null) return false;
    jsonData.update('imageUrl', (value) => uri);

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(room.id)
        .set(jsonData, SetOptions(merge: false));
    return true;
  }

  Future<bool> deleteImage(types.Room room, String imageFileUrl) async {
    try {
      var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
          .replaceAll(new RegExp(r'(\?alt).*'), '');
      final firebaseStorageRef = FirebaseStorage.instance.ref().child(fileUrl);
      await firebaseStorageRef.delete();
      bool result = await updateFirestore(room, 'null');
      if (result)
        return true;
      else
        return false;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future updateLatestTimeStampOnFirebase({
    required String roomId,
  }) async {
    final json =
        await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();

    final roomJsonData = json.data();
    if (roomJsonData == null) return;

    final date = await NTP.now();
    roomJsonData['lastUpdated'] = Timestamp.fromDate(date);

    print(roomJsonData);

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .set(roomJsonData);
  }

  Future<String?> getRole(String firebaseUID) async {
    final json = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUID)
        .get();
    final jsonData = json.data();
    if (jsonData == null) return null;
    if (jsonData.containsKey('role')) {
      return jsonData['role'];
    } else {
      return null;
    }
  }

  Future<void> removeUserProfileImageFromUserCollectionFirestore(
      String firebaseUID) async {
    final json = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUID)
        .get();
    final jsonData = json.data();
    if (jsonData == null) return null;
    jsonData.update('avatarUrl', (value) => null);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUID)
        .set(jsonData);
  }

  Future<String?> getUserProfileImageFromUserCollectionFirestore(
      String firebaseUID) async {
    final json = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUID)
        .get();
    final jsonData = json.data();
    return (jsonData?['avatarUrl']);
    // if (jsonData == null) return null;
    // jsonData.update('avatarUrl', (value) => null);
    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(firebaseUID)
    //     .set(jsonData);
  }

  Future<void> assignGroupAdmin(
      {required String roomId, required String selfSfid}) async {
    log('assignGroupAdmin before get room');
    try {
      final date = await NTP.now();
      await FirebaseFirestore.instance.collection('rooms').doc(roomId).set({
        'groupAdmin': [selfSfid],
        'creator': selfSfid,
        'createdAt': Timestamp.fromDate(date)
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      log('assignGroupAdmin error $e');
    }
  }

  Future<List<String>?> getGroupAdmin({required String roomId}) async {
    final json =
        await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();
    final jsonData = json.data();
    if (jsonData == null) return null;
    if (jsonData.containsKey('groupAdmin')) {
      List<dynamic> list = jsonData['groupAdmin'];
      List<String> stringList = list.map((e) => e as String).toList();
      return stringList;
    } else {
      return null;
    }
  }

  Future<void> deleteRoomFromFirestore(String roomId) async {
    try {
      await FirebaseFirestore.instance.collection('rooms').doc(roomId).delete();
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
