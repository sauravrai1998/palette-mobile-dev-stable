import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:intl/intl.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/chat_module/models/chat_contact_list.dart';
import 'package:palette/modules/chat_module/models/message_model.dart';
import 'package:palette/modules/chat_module/screens/chat_message_screen.dart';
import 'package:palette/modules/chat_module/services/chat_pendo_repo.dart';
import 'package:palette/modules/chat_module/services/chat_repository.dart';
import 'package:palette/utils/helpers.dart';

class DirectChatListView extends StatefulWidget {
  const DirectChatListView({Key? key}) : super(key: key);

  @override
  _DirectChatListViewState createState() => _DirectChatListViewState();
}

class _DirectChatListViewState extends State<DirectChatListView> {
  Map chatRoleRoomIdMapping = {};

  List<ChatContact> chatContacts = [];
  String selfFirebaseUid = FirebaseChatCore.instance.firebaseUser!.uid;
  var trackedGroupChatHistoryScreen = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
      builder: (context, pendoState) {
        if (pendoState is PendoMetaDataState) {
          if (trackedGroupChatHistoryScreen == false) {
            ChatPendoRepo.trackDirectChatHistoryScreenVisit(pendoState);
            trackedGroupChatHistoryScreen = true;
          }
        }
        return StreamBuilder<List<Room>>(
            stream: FirebaseChatCore.instance.rooms(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _getLoadingIndicator();
              } else if (snapshot.hasError) {
                return Center(child: Text('Error occurred'));
              }
              final rooms = snapshot.data as List<Room>;

              final directRooms =
                  rooms.where((room) => room.type == RoomType.direct).toList();
              if (directRooms.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      "No Chats to display. Create one to start a conversation",
                      style: kalamTextStyleSmall.copyWith(fontSize: 18),
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                child: ListView.builder(
                  itemCount: directRooms.length,
                  itemBuilder: (context, index) {
                    return _chatHistoryItem(
                        index: index, directRooms: directRooms);
                  },
                ),
              );
            });
      },
    );
  }

  Widget _chatHistoryItem(
      {required int index, required List<Room> directRooms}) {
    var no = index + 1;
    final usersInRoom = directRooms[index]
        .users
        .where((user) => user.id != selfFirebaseUid)
        .toList();

    final otherUid = usersInRoom.first.id;
    final role = ChatRepository.instance.getRole(otherUid);
    return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
        builder: (context, pendoState) {
      return TextScaleFactorClamper(
        child: Container(
          margin:
              index != 0 ? EdgeInsets.all(4) : EdgeInsets.fromLTRB(4, 16, 4, 4),
          decoration: BoxDecoration(
            border: Border.all(
              color: defaultDark.withOpacity(0.15),
            ),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          //height: 80,
          child: Center(
              child: Stack(
            children: [
              Semantics(
                label: "Chat $no",
                child: ListTile(
                  // trailing: Text('unread'),
                  leading: ExcludeSemantics(
                    child: CircleAvatar(
                      backgroundColor: Colors.indigoAccent,
                      radius: 26,
                      child: directRooms[index].imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: directRooms[index].imageUrl ?? '',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child:
                                      Container() //CircularProgressIndicator()
                                  ),
                              errorWidget: (context, url, error) => Center(
                                child: Text(
                                  Helper.getInitials(
                                    directRooms[index].name ?? 'Empty',
                                  ),
                                  style: robotoTextStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                Helper.getInitials(
                                  directRooms[index].name ?? 'Empty',
                                ),
                                style: robotoTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                    ),
                  ),
                  title: Container(
                    margin: EdgeInsets.only(bottom: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              directRooms[index].name ?? 'No name',
                              style: robotoTextStyle.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            // StreamBuilder<QuerySnapshot>(
                            //   stream: FirebaseFirestore.instance
                            //       .collection('rooms')
                            //       .doc(directRooms[index].id)
                            //       .collection('messages')
                            //       .snapshots(),
                            //   builder: (context, snapshot) {
                            //     return _getTimeWidget(snapshot);
                            //   },
                            // )
                          ],
                        ),
                        SizedBox(height: 2),
                        FutureBuilder(
                            future: role,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  '${snapshot.data}',
                                  style: kalamLight.copyWith(
                                    color: defaultPurple,
                                    fontSize: 12,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  'User',
                                  style: kalamLight.copyWith(
                                    color: defaultPurple,
                                    fontSize: 12,
                                  ),
                                );
                              } else {
                                return Text(
                                  'User',
                                  style: kalamLight.copyWith(
                                    color: defaultPurple,
                                    fontSize: 12,
                                  ),
                                );
                              }
                            }),
                        Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: Row(
                            children: [
                              Flexible(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('rooms')
                                      .doc(directRooms[index].id)
                                      .collection('messages')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return _buildUnreadIndicator(
                                        snapshot: snapshot);
                                  },
                                ),
                              ),
                              SizedBox(width: 3),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('rooms')
                                    .doc(directRooms[index].id)
                                    .collection('messages')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  return _getTimeWidget(snapshot);
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    ChatPendoRepo.trackDirectChatMessageDetailScreenVisit(
                      otherUserUid: otherUid,
                      pendoState: pendoState,
                    );
                    final route = MaterialPageRoute(
                      builder: (_) => ChatMessageScreen(
                        room: directRooms[index],
                      ),
                    );
                    Navigator.push(context, route);
                  },
                ),
              ),
            ],
          )),
        ),
      );
    });
  }

  Widget _getTimeWidget(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    if (!snapshot.hasData) {
      return _emptySizedBox();
    }

    final messageSnapshots = snapshot.data!.docs;
    if (messageSnapshots.isEmpty) return _emptySizedBox();

    final messageModels = messageSnapshots.map((messageSnapshot) {
      final json = messageSnapshot.data() as Map<String, dynamic>;
      return MessageModel.fromJson(json: json);
    }).toList();

    /// Sorting according to message times.
    messageModels.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

    final reversed = messageModels.reversed.toList();
    final latestTimeStamp = reversed.first.dateTime;
    if (latestTimeStamp == null) return _emptySizedBox();

    return Builder(builder: (context) {
      final time =
          DateFormat.jm(null).format(DateTime.fromMillisecondsSinceEpoch(
        (latestTimeStamp.millisecondsSinceEpoch / 1000).floor() * 1000,
      ));

      return Text(
        '$time',
        style: kalamLight.copyWith(
          color: defaultDark.withOpacity(0.7),
          fontSize: 10,
        ),
      );
    });
  }

  Widget _buildUnreadIndicator({
    required AsyncSnapshot<QuerySnapshot> snapshot,
  }) {
    if (snapshot.hasData) {
      final messageSnapshots = snapshot.data!.docs;

      if (messageSnapshots.isEmpty)
        return Icon(
          Icons.circle,
          color: Colors.transparent,
          size: 20,
        );

      final messageModels = messageSnapshots.map((messageSnapshot) {
        final json = messageSnapshot.data() as Map<String, dynamic>;
        return MessageModel.fromJson(json: json);
      }).toList();

      /// Sorting according to message times.
      messageModels.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

      final reversed = messageModels.reversed.toList();
      final lastMessage = _getLastMessage(messageModels: reversed);

      var counter = 0;

      /// Counting unread messages.
      for (var messageModel in reversed) {
        if (messageModel.status == 'read') {
          break;
        } else {
          if (messageModel.authorId != selfFirebaseUid) counter++;
        }
      }

      final message = messageModels.last;
      final selfUid = FirebaseChatCore.instance.firebaseUser!.uid;

      /// If message is not seen and author id is not self then show Unread indicator
      Widget? unreadCounterIcon;

      if (message.status != 'read' && message.authorId != selfUid) {
        unreadCounterIcon = Container(
          decoration: BoxDecoration(
            color: defaultPurple,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: defaultDark),
          ),
          height: 23,
          width: 23,
          child: Center(
            child: Text(
              '$counter',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          lastMessage.isNotEmpty
              ? Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kalamLight.copyWith(
                        color: defaultDark.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              : _emptySizedBox(),
          unreadCounterIcon ?? _emptySizedBox(),
        ],
      );
    }

    return _emptySizedBox();
  }

  String _getLastMessage({required List<MessageModel> messageModels}) {
    var lastMessage = '';
    if (messageModels.isEmpty) return lastMessage;
    if (messageModels.first.type == 'text')
      return messageModels.first.text ?? '';
    if (messageModels.first.type.toLowerCase() == 'image') return 'Image';
    return 'File';
  }

  Widget _getLoadingIndicator() {
    return Center(
      child: Container(height: 38, width: 50, child: CustomPaletteLoader()),
    );
  }

  Widget _emptySizedBox() {
    return SizedBox(
      height: 0,
      width: 0,
    );
  }
}
