import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/todo_module/services/todo_repo.dart';

abstract class TodoBulkEvent {}

class TodoBulkEditStatusEvent extends TodoBulkEvent {
  final List<String> todoIds;
  final String status;

  TodoBulkEditStatusEvent({required this.todoIds, required this.status});
}

abstract class TodoBulkState {}

class TodoBulkInitialState extends TodoBulkState {}

class TodoBulkLoadingState extends TodoBulkState {}

class TodoBulkSuccessState extends TodoBulkState {}

class TodoBulkErrorState extends TodoBulkState {
  final String errorMessage;

  TodoBulkErrorState({required this.errorMessage});
}

class TodoBulkBloc extends Bloc<TodoBulkEvent, TodoBulkState> {
  TodoBulkBloc(TodoBulkState initialState) : super(TodoBulkInitialState());

  @override
  Stream<TodoBulkState> mapEventToState(TodoBulkEvent event) async* {
    if (event is TodoBulkEditStatusEvent) {
      yield TodoBulkLoadingState();
      try {
        final result = await TodoRepo.instance
            .updateTodoStatusBulk(todoIds: event.todoIds, status: event.status);

        await Future.delayed(const Duration(seconds: 1), () {});
        if (result == true) {
          // Ensuring the next GET API is called after this POST API call success
          print('result of bulk update is true');
          yield TodoBulkSuccessState();
        }
      } catch (e) {
        yield TodoBulkErrorState(errorMessage: e.toString());
      }
    }
  }
}
