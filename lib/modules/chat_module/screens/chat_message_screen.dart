import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:palette/modules/auth_module/services/notification_repository.dart';
import 'package:palette/modules/chat_module/screens/updated_group_details_holder.dart';
import 'package:palette/modules/chat_module/services/chat_pendo_repo.dart';
import 'package:palette/modules/chat_module/services/chat_repository.dart';
import 'package:palette/utils/konstants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_history_screen.dart';
import 'group_details_screen.dart';

class ChatMessageScreen extends StatefulWidget {
  const ChatMessageScreen(
      {Key? key,
      required this.room,
      this.invokedFromPushNotification = false,
      this.roomImage})
      : super(key: key);

  final types.Room room;
  final bool invokedFromPushNotification;
  final String? roomImage;

  @override
  _ChatMessageScreenState createState() => _ChatMessageScreenState(
      roomName: room.name ?? 'Chat', roomImage: roomImage ?? '');
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  _ChatMessageScreenState({required this.roomName, required this.roomImage});
  String roomName;
  List<String> otherUserUids = [];
  String? selfFullName;
  String roomImage;
  bool showAttachmentOptions = false;
  BuildContext? buildMethodContext;

  @override
  void initState() {
    super.initState();
    _fetchFcmTokensForOtherUser();
    _setSelfFullName();
    _setUnreadMessagesStatusToRead();
    print(roomImage);
  }

  Future _setUnreadMessagesStatusToRead() async {
    if (widget.room.type == types.RoomType.group) {
      ChatRepository.instance
          .setUnreadMessagesStatusToReadForGroupChat(roomId: widget.room.id);
    } else {
      ChatRepository.instance
          .setUnreadMessagesStatusToReadForDirectChat(roomId: widget.room.id);
    }
  }

  Future _setSelfFullName() async {
    final prefs = await SharedPreferences.getInstance();
    selfFullName = prefs.getString(fullNameConstant);
  }

  Future _fetchFcmTokensForOtherUser() async {
    final usersInRoom = widget.room.users
        .where((user) => user.id != FirebaseChatCore.instance.firebaseUser!.uid)
        .toList();

    otherUserUids = usersInRoom.map((u) => u.id).toList();
    NotificationRepo.instance.otherUserFcmTokens =
        await NotificationRepo.instance.fetchFcmTokensFor(uids: otherUserUids);
  }

  bool _isAttachmentUploading = false;

  @override
  Widget build(BuildContext context) {
    buildMethodContext = context;
    return SafeArea(
      child: Semantics(
        label:
            "Welcome to your chat page A tap on back button on the top left will navigate back to your chat history"
            "a tap on message edit box on the bottom helps you to send messages",
        child: WillPopScope(
          onWillPop: () {
            // if (widget.invokedFromPushNotification) {
            //   final route =
            //       MaterialPageRoute(builder: (_) => ChatHistoryScreen());
            //   Navigator.pushReplacement(context, route);
            // } else {
            //   Navigator.of(context).popUntil((route) {
            //     return route.settings.name == 'ChatHistoryPage';
            //   });
            // }
            //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ChatHistoryScreen()), (route) => false);
            return Future.value(true);
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                color: Colors.black,
                icon: RotatedBox(
                    quarterTurns: 1,
                    child: SvgPicture.asset(
                      'images/dropdown.svg',
                      color: defaultDark,
                      semanticsLabel:
                          "Button to navigate back to the chat history page",
                    )),
                onPressed: () {
                  //   if (widget.invokedFromPushNotification) {
                  //     final route =
                  //         MaterialPageRoute(builder: (_) => ChatHistoryScreen());
                  //     Navigator.pushReplacement(context, route);
                  //   } else {
                  //     Navigator.of(context).popUntil((route) {
                  //       return route.settings.name == 'ChatHistoryPage';
                  //     });
                  //   }
                  Navigator.pop(context);
                },
              ),
              elevation: 0,
              backgroundColor: white,
              title: GestureDetector(
                onTap: () async {
                  if (widget.room.type == types.RoomType.group) {
                    print(this.roomImage);
                    final route = MaterialPageRoute(
                      builder: (_) => GroupDetailsScreen(
                          room: widget.room,
                          roomName: this.roomName,
                          roomImage: this.roomImage),
                    );
                    UpdatedGroupRoomDetailsHolder updatedRoomDetailsHolder =
                        await Navigator.push(context, route);
                    setState(() {
                      this.roomName = updatedRoomDetailsHolder.updatedRoomName;
                      this.roomImage =
                          updatedRoomDetailsHolder.updatedGroupImageUrl;
                    });
                  }
                },
                child: Text(
                  roomName,
                  style: robotoTextStyle.copyWith(
                      color: Colors.black, fontSize: 20),
                ),
              ), systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            body: Stack(
              children: [
                StreamBuilder<List<types.Message>>(
                  stream: FirebaseChatCore.instance.messages(widget.room.id),
                  initialData: const [],
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      final data = snapshot.data!;
                      _postLatestMessageStatusToRead(data);
                    }
                    print('deviceTimeOffset: $deviceTimeOffset');
                    return Chat(
                      deviceTimeOffset: deviceTimeOffset,
                      isAttachmentUploading: _isAttachmentUploading,
                      messages: snapshot.data ?? [],
                      onAttachmentPressed: _handleAtachmentPress,
                      // onFilePressed: _openFile,
                      onMessageTap: _openFile,
                      onPreviewDataFetched: _onPreviewDataFetched,
                      onSendPressed: _onSendPressed,
                      // theme: DarkChatTheme(),
                      user: types.User(
                        id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                      ),
                      usersUidMap: widget.room.type == types.RoomType.group
                          ? ChatRepository.usersUidMap
                          : null,
                    );
                  },
                ),
                Positioned(
                  bottom: 68,
                  left: 4,
                  child: showAttachmentOptions
                      ? Container(
                          height: 249,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 29, 29, 33),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                  onTap: () {
                                    _showFilePicker();
                                    setState(() {
                                      showAttachmentOptions = false;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'images/files_chat.svg',
                                    color: white,
                                    semanticsLabel: "Files icon",
                                  )),
                              InkWell(
                                  onTap: () {
                                    _showImagePicker();
                                    setState(() {
                                      showAttachmentOptions = false;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'images/image_chat.svg',
                                    color: white,
                                    semanticsLabel: "Image icon",
                                  )),
                              InkWell(
                                  onTap: () {
                                    _showVideoPicker();
                                    setState(() {
                                      showAttachmentOptions = false;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'images/video_chat.svg',
                                    color: white,
                                    semanticsLabel: "Video icon",
                                  )),
                            ],
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _postLatestMessageStatusToRead(List<types.Message> messages) async {
    if (messages.isNotEmpty) {
      if (widget.room.type == types.RoomType.direct) {
        ChatRepository.instance.postLatestMessageStatusToReadForDirectChat(
          messageId: messages.first.id,
          roomId: widget.room.id,
        );
      } else {
        ChatRepository.instance.postLatestMessageStatusToReadForGroupChat(
          messageId: messages.first.id,
          roomId: widget.room.id,
        );
      }
    }
  }

  void _handleAtachmentPress() {
    setState(() {
      showAttachmentOptions = !showAttachmentOptions;
    });
  }
  // showModalBottomSheet<void>(
  //   context: context,
  //   builder: (BuildContext context) {
  //     return SizedBox(
  //       height: 200,
  //       child: TextScaleFactorClamper(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 _showFilePicker();
  //               },
  //               child: const Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text('Open file picker'),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 print('show image picker...');
  //                 _showImagePicker();
  //                 // _showVideoPicker();
  //               },
  //               child: const Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text('Open image picker'),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 print('show video picker...');
  //                 // _showImagePicker();
  //                 _showVideoPicker();
  //               },
  //               child: const Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text('Open video picker'),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text('Cancel'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   },
  // );
  // }

  void _onPreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  Map<String, dynamic>? _getStatusMap() {
    final Map<String, dynamic> statusMap = {};
    if (widget.room.type == types.RoomType.group) {
      /// If group room, we'll send a status map.
      widget.room.users.forEach((e) {
        statusMap[e.id] = null;
      });
    }
    return statusMap.isEmpty ? null : statusMap;
  }

  void _onSendPressed(types.PartialText message) {
    if (message.text.trim().isEmpty) return;
    ChatPendoRepo.trackSendingMessage(
        context: buildMethodContext,
        messageType: 'Text',
        textMessage: message.text);
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
      _getStatusMap(),
    );
    _sendPushNotif(body: message.text);
    _updateLatestTimeStampOnGroup(roomId: widget.room.id);
  }

  _updateLatestTimeStampOnGroup({required String roomId}) async {
    ChatRepository.instance.updateLatestTimeStampOnFirebase(roomId: roomId);
  }

  void _openFile(types.Message m) async {
    if (!(m is types.FileMessage)) {
      return;
    }
    final message = m;
    print('message tapped');
    var localPath = message.uri;

    if (message.uri.startsWith('http')) {
      final client = http.Client();
      final request = await client.get(Uri.parse(message.uri));
      final bytes = request.bodyBytes;
      final documentsDir = (await getApplicationDocumentsDirectory()).path;
      localPath = '$documentsDir/${message.fileName}';

      if (!File(localPath).existsSync()) {
        final file = File(localPath);
        await file.writeAsBytes(bytes);
      }
    }

    await OpenFile.open(localPath);
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  void _showFilePicker() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final fileName = result.files.single.name;
      final filePath = result.files.single.path;
      final file = File(filePath ?? '');

      try {
        final reference = FirebaseStorage.instance.ref(fileName);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          fileName: fileName,
          mimeType: lookupMimeType(filePath ?? ''),
          size: result.files.single.size,
          uri: uri,
        );

        ChatPendoRepo.trackSendingMessage(
            context: buildMethodContext, messageType: 'File');

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
          _getStatusMap(),
        );

        _updateLatestTimeStampOnGroup(roomId: widget.room.id);
        _sendPushNotif(body: fileName);
        _setAttachmentUploading(false);
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
        print(e);
      }
    } else {
      // User canceled the picker
    }
  }

  void _showVideoPicker() async {
    final result = await ImagePicker().getVideo(source: ImageSource.gallery);
    print(result);

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final videoName = result.path.split('/').last;

      try {
        final reference = FirebaseStorage.instance.ref(videoName);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          fileName: videoName,
          size: size,
          uri: uri,
        );

        ChatPendoRepo.trackSendingMessage(
            context: buildMethodContext, messageType: 'Video');
        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
          _getStatusMap(),
        );

        _updateLatestTimeStampOnGroup(roomId: widget.room.id);
        _sendPushNotif(body: 'Video');
        _setAttachmentUploading(false);
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
        print(e);
      }
    }
  }

  void _showImagePicker() async {
    final result = await ImagePicker().getImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    print(result);
    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final imageName = result.path.split('/').last;

      try {
        final reference = FirebaseStorage.instance.ref(imageName);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          imageName: imageName,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        ChatPendoRepo.trackSendingMessage(
            context: buildMethodContext, messageType: 'Image');

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
          _getStatusMap(),
        );

        _updateLatestTimeStampOnGroup(roomId: widget.room.id);
        _sendPushNotif(body: 'Image');
        _setAttachmentUploading(false);
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
        print(e);
      }
    } else {
      print('User canceled the picker');
    }
  }

  _sendPushNotif({required String body}) {
    if (widget.room.type == types.RoomType.group) {
      final name = selfFullName ?? 'New Message';

      NotificationRepo.instance.sendChatPushNotifTo(
        title: widget.room.name ?? 'Group',
        body: name + ': ' + body,
        isFromGroupChat: true,
        room: widget.room,
      );
    } else {
      NotificationRepo.instance.sendChatPushNotifTo(
        title: selfFullName ?? 'New Message',
        body: body,
      );
    }
  }
}
