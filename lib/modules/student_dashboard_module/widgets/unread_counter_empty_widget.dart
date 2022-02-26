import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:palette/modules/chat_module/models/message_model.dart';

var unreadMessageCountMapStreamController =
    StreamController<Map<String, int>>.broadcast();

class UnreadCounterEmptyWidget extends StatelessWidget {
  UnreadCounterEmptyWidget({Key? key}) : super(key: key);
  final selfUid = FirebaseChatCore.instance.firebaseUser != null
      ? FirebaseChatCore.instance.firebaseUser!.uid
      : "";

  @override
  Widget build(BuildContext context) {
    Map<String, int> roomIdToCounter = {};

    return Align(
      alignment: Alignment.center,
      child: StreamBuilder<List<Room>>(
        stream: FirebaseChatCore.instance.rooms(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(height: 0, width: 0);
          } else if (snapshot.hasError) {
            return Text('error');
          }

          final rooms = snapshot.data!;
          // .where((room) => room.type == RoomType.direct)
          // .toList();
          var localCounter = 0;
          return Container(
            height: 0,
            width: 0,
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (c, index) {
                localCounter = 0;
                return SizedBox(
                  height: 0,
                  width: 0,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('rooms')
                          .doc(rooms[index].id)
                          .collection('messages')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final messageSnapshots = snapshot.data!.docs;

                          final messageModels = messageSnapshots.map(
                            (messageSnapshot) {
                              final json = messageSnapshot.data()
                                  as Map<String, dynamic>;
                              final model = MessageModel.fromJson(json: json);
                              return model;
                            },
                          ).toList();

                          /// Sorting according to message times.
                          messageModels.sort(
                            (a, b) => a.dateTime!.compareTo(b.dateTime!),
                          );
                          final reversed = messageModels.reversed.toList();

                          localCounter = 0;
                          for (var messageModel in reversed) {
                            if (messageModel.groupStatus != null &&
                                messageModel.groupStatus!.isNotEmpty) {
                              /// Group Room
                              if (messageModel.groupStatus![selfUid] ==
                                  'read') {
                                break;
                              } else {
                                if (messageModel.authorId != selfUid)
                                  localCounter++;
                              }
                            } else {
                              /// Direct Room
                              if (messageModel.status == 'read') {
                                break;
                              } else {
                                if (messageModel.authorId != selfUid)
                                  localCounter++;
                              }
                            }
                          }
                          roomIdToCounter[rooms[index].id] = localCounter;
                          unreadMessageCountMapStreamController
                              .add(roomIdToCounter);
                        }

                        return SizedBox(height: 0, width: 0);
                      }),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
