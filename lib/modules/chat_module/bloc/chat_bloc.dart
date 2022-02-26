import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/chat_module/bloc/chat_events.dart';
import 'package:palette/modules/chat_module/bloc/chat_states.dart';
import 'package:palette/modules/chat_module/services/chat_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepo;
  ChatBloc({
    required this.chatRepo,
  }) : super((InitialChatState()));

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is FetchChatContactsEvent) {
      yield ChatContactsLoadingState();
      try {
        final chatContactList = await chatRepo.getChatContactList();
        yield ChatContactsSuccessState(data: chatContactList);
      } catch (e) {
        print(e);
        yield ChatContactsFailedState(err: e.toString());
      }
    }
  }
}
