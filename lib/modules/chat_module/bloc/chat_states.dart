import 'package:palette/modules/chat_module/models/chat_contact_list.dart';

abstract class ChatState {}

class InitialChatState extends ChatState {}

class ChatContactsSuccessState extends ChatState {
  final List<ChatContact> data;

  ChatContactsSuccessState({required this.data});
}

class ChatContactsFailedState extends ChatState {
  final String err;

  ChatContactsFailedState({required this.err});
}

class ChatContactsLoadingState extends ChatState {}
