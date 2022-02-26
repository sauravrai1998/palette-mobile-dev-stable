import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/comment_module/model/comment_list_response_model.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_repository.dart';

abstract class SendCommentEvent {}

class SendComment extends SendCommentEvent {
  final Map<String, dynamic> map;
  SendComment(this.map);
}

abstract class SendCommentsState {}

class SendCommentsInitialState extends SendCommentsState {}

class SendCommentLoadingState extends SendCommentsState {}
class SendCommentSuccessState extends SendCommentsState {}
class SendCommentFailureState extends SendCommentsState {
  final String error;
  SendCommentFailureState(this.error);
}

class SendCommentsBloc extends Bloc<SendCommentEvent, SendCommentsState> {

// final notificationsRepository = CommentsRepository.instance;
  final RecommendRepository commentRepository;
  // CommentsBloc() : super(CommentsInitialState());
  SendCommentsBloc({required this.commentRepository})
      : super((SendCommentsInitialState()));

  @override
  Stream<SendCommentsState> mapEventToState(SendCommentEvent event) async*{

    if (event is SendComment) {
      yield SendCommentLoadingState();
      try {
        print('sending');
        await commentRepository.sendComment(event.map);
        yield SendCommentSuccessState();
        print('send');

      } catch (e) {
        yield SendCommentFailureState(e.toString());
      }
    }
    // throw UnimplementedError();
  }
}

