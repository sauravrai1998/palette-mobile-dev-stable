import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/todo_module/services/todo_repo.dart';

/// Events
///
abstract class TodoAcceptRejectEvent {}

class TodoAcceptPostEvent extends TodoAcceptRejectEvent {
  String id;
  TodoAcceptPostEvent({required this.id});
}

class TodoRejectPostEvent extends TodoAcceptRejectEvent {
  String id;
  TodoRejectPostEvent({required this.id});
}

/// States
///
abstract class TodoAcceptRejectState {}

class TodoAcceptRejectInitialState extends TodoAcceptRejectState {}

/// Accept States
class TodoAcceptSuccessState extends TodoAcceptRejectState {}

class TodoAcceptLoadingState extends TodoAcceptRejectState {}

class TodoAcceptFailedState extends TodoAcceptRejectState {
  final String errorMessage;

  TodoAcceptFailedState({required this.errorMessage});
}

/// Reject States
class TodoRejectSuccessState extends TodoAcceptRejectState {}

class TodoRejectLoadingState extends TodoAcceptRejectState {}

class TodoRejectFailedState extends TodoAcceptRejectState {
  final String errorMessage;

  TodoRejectFailedState({required this.errorMessage});
}

class TodoAcceptRejectBloc
    extends Bloc<TodoAcceptRejectEvent, TodoAcceptRejectState> {
  TodoAcceptRejectBloc(TodoAcceptRejectState initialState)
      : super(TodoAcceptRejectInitialState());

  @override
  Stream<TodoAcceptRejectState> mapEventToState(
      TodoAcceptRejectEvent event) async* {
    if (event is TodoAcceptPostEvent) {
      yield TodoAcceptLoadingState();
      try {
        /// Accept call
        await TodoRepo.instance.acceptTodo(id: event.id);
        yield TodoAcceptSuccessState();
      } catch (e) {
        yield TodoAcceptFailedState(errorMessage: e.toString());
      }
    } else if (event is TodoRejectPostEvent) {
      yield TodoRejectLoadingState();
      try {
        /// Reject call
        await TodoRepo.instance.rejectTodo(id: event.id);
        yield TodoRejectSuccessState();
      } catch (e) {
        yield TodoRejectFailedState(errorMessage: e.toString());
      }
    }
  }
}
