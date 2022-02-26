import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart' as http;

import '../../../utils/konstants.dart';

class NotificationRepo {
  NotificationRepo._privateConstructor();
  static final NotificationRepo instance =
      NotificationRepo._privateConstructor();

  List<String> otherUserFcmTokens = [];
  Map<String, dynamic>? globalChatNotifData;

  Future addFcmToFirestore() async {
    // await FirebaseMessaging.instance.requestPermission();
    /// Notif permission
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    ///Foreground messages
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('fcmToken: $fcmToken');

    if (FirebaseChatCore.instance.firebaseUser == null) {
      print('FirebaseChatCore.instance.firebaseUser is null');
      return;
    }

    final uid = FirebaseChatCore.instance.firebaseUser!.uid;
    final json =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final jsonData = json.data();

    if (jsonData == null) return;

    if (jsonData.containsKey('fcmTokens')) {
      final fcmTokens = jsonData['fcmTokens'] as List;
      if (fcmTokens.contains(fcmToken)) {
        return;
      }
      fcmTokens.add(fcmToken);
      jsonData.update('fcmTokens', (value) => fcmTokens);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(jsonData, SetOptions(merge: false));
    } else {
      jsonData['fcmTokens'] = [fcmToken];
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(jsonData, SetOptions(merge: false));
    }
  }

  Future removeFcmFromFirestore() async {
    if (FirebaseChatCore.instance.firebaseUser == null) {
      print('FirebaseChatCore.instance.firebaseUser is null');
      return;
    }

    final uid = FirebaseChatCore.instance.firebaseUser!.uid;
    final json =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final jsonData = json.data();

    if (jsonData == null) return;

    if (jsonData.containsKey('fcmTokens')) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final fcmTokens = jsonData['fcmTokens'] as List;
      if (fcmTokens.contains(fcmToken)) {
        fcmTokens.remove(fcmToken);
        jsonData.update('fcmTokens', (value) => fcmTokens);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(jsonData, SetOptions(merge: false));
      }
    }
  }

  Future<List<String>> fetchFcmTokensFor({required List<String> uids}) async {
    List<String> fcmTokens = [];
    for (int i = 0; i < uids.length; i++) {
      final uid = uids[i];

      final json =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final jsonData = json.data();
      print(jsonData);

      if (jsonData == null) return [];

      if (jsonData.containsKey('fcmTokens')) {
        final tokenList = jsonData['fcmTokens'] as List;
        final tokens = tokenList.map<String>((e) => e.toString()).toList();
        fcmTokens.addAll(tokens);
      }
    }
    return fcmTokens;
  }

  Future sendChatPushNotifTo({
    required String title,
    required String body,
    bool isFromGroupChat = false,
    Room? room,
  }) async {
    print(otherUserFcmTokens);
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    var payload = _getPayload(
        isFromGroupChat: isFromGroupChat, title: title, body: body, room: room);

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$firebaseNotifKey' // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: jsonEncode(payload),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    print('fcm Response: ${response.body}');

    if (response.statusCode == 200) {
      /// Success
    } else {
      /// Failed
    }
  }

  Map _getPayload({
    required isFromGroupChat,
    Room? room,
    required String title,
    required String body,
  }) {
    if (isFromGroupChat) {
      if (room == null) return {};
      List<Map<String, dynamic>> users = [];

      users = room.users.map<Map<String, dynamic>>((user) {
        return {
          'id': user.id,
          'first_name': user.firstName,
          'last_name': user.lastName,
        };
      }).toList();

      return {
        'registration_ids': otherUserFcmTokens,
        'collapse_key': 'type_a',
        'data': {
          'room_type': 'group',
          'group_room': {
            'id': room.id,
            'name': room.name,
            'users': users,
          },
        },
        'notification': {
          'title': title,
          'body': body,
          'content_available': true,
        }
      };
    } else {
      return {
        'registration_ids': otherUserFcmTokens,
        'collapse_key': 'type_a',
        'data': {
          'room_type': 'direct',
          'senderUid': FirebaseChatCore.instance.firebaseUser?.uid,
        },
        'notification': {
          'title': title,
          'body': body,
          'content_available': true,
        }
      };
    }
  }
}
