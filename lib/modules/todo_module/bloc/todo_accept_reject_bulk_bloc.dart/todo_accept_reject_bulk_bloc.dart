import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/todo_module/services/todo_repo.dart';

/// Events
///
abstract class TodoAcceptRejectBulkEvent {}

class TodoAcceptBulkPostEvent extends TodoAcceptRejectBulkEvent {
  List<String> todoIds;
  TodoAcceptBulkPostEvent({required this.todoIds});
}

class TodoRejectBulkPostEvent extends TodoAcceptRejectBulkEvent {
  List<String> todoIds;
  TodoRejectBulkPostEvent({required this.todoIds});
}

/// States
///
abstract class TodoAcceptRejectBulkState {}

class TodoAcceptRejectBulkInitialState extends TodoAcceptRejectBulkState {}

/// Accept States
class TodoAcceptBulkSuccessState extends TodoAcceptRejectBulkState {}

class TodoAcceptBulkLoadingState extends TodoAcceptRejectBulkState {}

class TodoAcceptBulkFailedState extends TodoAcceptRejectBulkState {
  final String errorMessage;

  TodoAcceptBulkFailedState({required this.errorMessage});
}

/// Reject States
class TodoRejectBulkSuccessState extends TodoAcceptRejectBulkState {}

class TodoRejectBulkLoadingState extends TodoAcceptRejectBulkState {}

class TodoRejectBulkFailedState extends TodoAcceptRejectBulkState {
  final String errorMessage;

  TodoRejectBulkFailedState({required this.errorMessage});
}

class TodoAcceptRejectBulkBloc
    extends Bloc<TodoAcceptRejectBulkEvent, TodoAcceptRejectBulkState> {
  TodoAcceptRejectBulkBloc(TodoAcceptRejectBulkState initialState)
      : super(TodoAcceptRejectBulkInitialState());

  @override
  Stream<TodoAcceptRejectBulkState> mapEventToState(
      TodoAcceptRejectBulkEvent event) async* {
    if (event is TodoAcceptBulkPostEvent) {
      yield TodoAcceptBulkLoadingState();
      try {
        /// Accept call
        await TodoRepo.instance.bulkAcceptTodo(todoIds: event.todoIds);
        yield TodoAcceptBulkSuccessState();
      } catch (e) {
        yield TodoAcceptBulkFailedState(errorMessage: e.toString());
      }
    } else if (event is TodoRejectBulkPostEvent) {
      yield TodoRejectBulkLoadingState();
      try {
        /// Reject call
        await TodoRepo.instance.bulkRejectTodo(todoIds: event.todoIds);
        yield TodoRejectBulkSuccessState();
      } catch (e) {
        yield TodoRejectBulkFailedState(errorMessage: e.toString());
      }
    }
  }
}

