import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/comment_module/model/comment_list_response_model.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_repository.dart';

abstract class CommentEvent {}

class FetchComments extends CommentEvent {
  final String eventId;
  FetchComments(this.eventId);
}

// class SendComment extends CommentEvent {
//   final Map<String, dynamic> map;
//   SendComment(this.map);
// }

abstract class CommentsState {}

class CommentsInitialState extends CommentsState {}

class FetchCommentsLoadingState extends CommentsState {}
class FetchCommentsSuccessState extends CommentsState {
  CommentListModel commentList;
  FetchCommentsSuccessState({required this.commentList});
}
class FetchCommentsFailureState extends CommentsState {
  final String error;
  FetchCommentsFailureState(this.error);
}

// class SendCommentLoadingState extends CommentsState {}
// class SendCommentSuccessState extends CommentsState {}
// class SendCommentFailureState extends CommentsState {
//   final String error;
//   SendCommentFailureState(this.error);
// }

class CommentsBloc extends Bloc<CommentEvent, CommentsState> {

// final notificationsRepository = CommentsRepository.instance;
  final RecommendRepository commentRepository;
  // CommentsBloc() : super(CommentsInitialState());
  CommentsBloc({required this.commentRepository})
      : super((CommentsInitialState()));

  @override
  Stream<CommentsState> mapEventToState(CommentEvent event) async*{

    if (event is FetchComments) {
      yield FetchCommentsLoadingState();
      try {
        print('fetching');
        var commentList = await commentRepository.getCommentsList(eventId: event.eventId);
        yield FetchCommentsSuccessState(commentList: commentList);
        print(commentList);
        print('fetched');

      } catch (e) {
        yield FetchCommentsFailureState(e.toString());
      }
    }
    // else if (event is SendComment) {
    //   yield SendCommentLoadingState();
    //   try {
    //     print('fetching');
    //     await commentRepository.sendComment(event.map);
    //     yield SendCommentSuccessState();
    //     print('send');
    //
    //   } catch (e) {
    //     yield SendCommentFailureState(e.toString());
    //   }
    // }
    // throw UnimplementedError();
  }
}

