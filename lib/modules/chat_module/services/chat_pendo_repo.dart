import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/chat_module/models/chat_contact_list.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:pendo_sdk/pendo_sdk.dart';

class ChatPendoRepo {
  static List<ChatContact> chatContacts = [];

  static trackDirectChatHistoryScreenVisit(
    PendoMetaDataState pendoState,
  ) async {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'chatType': 'Direct',
    };

    PendoFlutterPlugin.track(
        'Chat | ChatHistoryScreen - Visit Direct Chat History Screen', arg);
  }

  static trackGroupChatHistoryScreenVisit(PendoMetaDataState pendoState) async {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'chatType': 'Group',
    };

    PendoFlutterPlugin.track(
        'Chat | ChatHistoryScreen - Visit Group Chat History Screen', arg);
  }

  static trackDirectChatMessageDetailScreenVisit({
    required String otherUserUid,
    required PendoMetaDataState pendoState,
  }) async {
    final chatContact =
        chatContacts.where((contact) => contact.uuid == otherUserUid).toList();
    final otherUserSfid = chatContact.first.id;

    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'chatType': 'Direct',
      'otherUserId': otherUserSfid,
    };

    PendoFlutterPlugin.track(
        'Chat | ChatMessageScreen - Visit Chat Message Screen for Direct Chats',
        arg);
  }

  static trackCreatingDirectChat({
    required String otherUserSfid,
    required PendoMetaDataState pendoState,
  }) async {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'otherUserId': otherUserSfid,
    };

    PendoFlutterPlugin.track('Chat | ChatScreen - Creating a Direct Chat', arg);
  }

  static trackCreatingGroupChat({
    required List<ContactsData> chatContacts,
    required PendoMetaDataState pendoState,
  }) async {
    final otherUserSfidList = chatContacts.map((e) => e.sfid).toList();

    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'otherUserIds': otherUserSfidList,
    };

    PendoFlutterPlugin.track(
        'Chat | SelectContactScreen - Creating a Group Chat', arg);
  }

  static trackAddingParticipantGroupChat({
    required List<String> userIdsToAdd,
    required PendoMetaDataState pendoState,
  }) async {
    final otherUserSfidList = userIdsToAdd.map((userId) {
      final chatContact =
          chatContacts.where((contact) => contact.uuid == userId).toList();
      return chatContact.first.id;
    }).toList();

    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'chatType': 'Group',
      'otherUsersAdded': otherUserSfidList,
    };

    PendoFlutterPlugin.track(
        'Chat | SelectContactScreen - Adding Participants to Group Chat', arg);
  }

  static trackRemovingParticipantGroupChat({
    required String uid,
    required PendoMetaDataState pendoState,
  }) async {
    final chatContact =
        chatContacts.where((contact) => contact.uuid == uid).toList();
    final otherUserSfid = chatContact.first.id;

    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'chatType': 'Group',
      'userRemoved': otherUserSfid,
    };
    print('pendo event is calling');
    PendoFlutterPlugin.track(
        'Chat | GroupChatDetailScreen - Removing Participants to Group Chat',
        arg);
  }

  static trackEditingGroupName({
    required String oldGroupName,
    required String newGroupName,
    required PendoMetaDataState pendoState,
  }) async {
    final arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'oldGroupName': oldGroupName,
      'newGroupName': newGroupName,
    };

    PendoFlutterPlugin.track(
        'Chat | GroupChatDetailScreen - Editing Group Name', arg);
  }

  static trackSendingMessage(
      {required BuildContext? context,
      required String messageType,
      String? textMessage}) {
    if (context == null) return;
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;

    Map<String,dynamic> arg = {};
    if (textMessage == null) {
      arg = {
        visitorIdKey: pendoState.visitorId,
        personaTypeKey: pendoState.role,
        accountIdKey: pendoState.instituteName,
        instituteIdKey: pendoState.instituteId,
        'messageType': messageType,
      };
    } else {
      arg = {
        visitorIdKey: pendoState.visitorId,
        personaTypeKey: pendoState.role,
        accountIdKey: pendoState.instituteName,
        instituteIdKey: pendoState.instituteId,
        'messageType': messageType,
        'textMessage': textMessage,
      };
    }

    PendoFlutterPlugin.track('Chat | ChatMessageScreen - Sending Message', arg);
  }
}
