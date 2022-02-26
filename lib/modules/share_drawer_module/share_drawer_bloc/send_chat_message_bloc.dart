import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:palette/modules/auth_module/services/notification_repository.dart';
import 'package:palette/modules/chat_module/services/chat_repository.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';

abstract class SendChatMessageEvent {}

class SendChatMessageFromShareDrawer extends SendChatMessageEvent {
  final String message;
  final List<ContactsData> userIds;
  SendChatMessageFromShareDrawer(
      {required this.message, required this.userIds});
}

abstract class SendChatMessageState {}

class SendChatMessageInitialState extends SendChatMessageState {}

class SendChatMessageLoadingState extends SendChatMessageState {}

class SendChatMessageSuccessState extends SendChatMessageState {}

class SendChatMessageErrorState extends SendChatMessageState {
  final String error;
  SendChatMessageErrorState({required this.error});
}

class SendChatMessageBloc
    extends Bloc<SendChatMessageEvent, SendChatMessageState> {
  SendChatMessageBloc(SendChatMessageState initialState)
      : super(SendChatMessageInitialState());

  @override
  Stream<SendChatMessageState> mapEventToState(
      SendChatMessageEvent event) async* {
    if (event is SendChatMessageFromShareDrawer) {
      yield SendChatMessageLoadingState();
      try {
        await sendChat(message: event.message, userIds: event.userIds);
        yield SendChatMessageSuccessState();
      } catch (e) {
        yield SendChatMessageErrorState(error: e.toString());
      }
    }
  }

  Future sendChat(
      {required String message, required List<ContactsData> userIds}) async {
    // for (var selectedRecipient in selectedRecipients) {
    //   final room = await FirebaseChatCore.instance
    //       .createRoom(User(id: selectedRecipient.firebaseUuid));

    //   print('roomId: ${room.id}');
    //   print('otherUserId: ${selectedRecipient.firebaseUuid}');
    //   print('widget.message: ${widget.message}');

    //   FirebaseChatCore.instance.sendMessage(
    //     widget.message,
    //     room.id,
    //     null,
    //   );
    // }

    final t = PartialText(text: message);

    for (int i = 0; i < userIds.length; i++) {
      print('otherUserId: ${userIds[i].firebaseUuid}');
      final room = await FirebaseChatCore.instance
          .createRoom(User(id: userIds[i].firebaseUuid));

      print('roomId: ${room.id}');
      print('widget.message: ${t.text}');

      FirebaseChatCore.instance.sendMessage(
        t,
        room.id,
        null,
      );

      ChatRepository.instance.updateLatestTimeStampOnFirebase(roomId: room.id);

      NotificationRepo.instance.sendChatPushNotifTo(
          title: 'New Message',
          body: t.text);

          // NotificationRepo.instance.sendChatPushNotifTo(
          // title: 'New Message',
          // body: t.text,
          // room: room,
          // isFromGroupChat: false);
    }
    // Navigator.pop(context);
  }
}
