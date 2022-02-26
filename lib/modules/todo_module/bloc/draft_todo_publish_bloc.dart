import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/todo_module/services/todo_repo.dart';

/// Events
///
abstract class DraftTodoEvent {}

class DraftTodoPublishEvent extends DraftTodoEvent {
  String id;
  DraftTodoPublishEvent({required this.id});
}

/// States
///
abstract class DraftTodoState {}

class DraftTodoPublishInitialState extends DraftTodoState {}

/// TodoPublish States
class TodoPublishSuccessState extends DraftTodoState {}

class TodoPublishLoadingState extends DraftTodoState {}

class TodoPublishFailedState extends DraftTodoState {
  final String errorMessage;

  TodoPublishFailedState({required this.errorMessage});
}

class DraftTodoPublishBloc
    extends Bloc<DraftTodoEvent, DraftTodoState> {
  DraftTodoPublishBloc(DraftTodoState initialState)
      : super(DraftTodoPublishInitialState());

  @override
  Stream<DraftTodoState> mapEventToState(
      DraftTodoEvent event) async* {
    if (event is DraftTodoPublishEvent) {
      yield TodoPublishLoadingState();
      try {
        /// Publish call
        await TodoRepo.instance.publishDraftTodo(id: event.id);
        yield TodoPublishSuccessState();
      } catch (e) {
        yield TodoPublishFailedState(errorMessage: e.toString());
      }
    }
  }
}
