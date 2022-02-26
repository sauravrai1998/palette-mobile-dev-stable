import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_event.dart';
import 'package:palette/modules/todo_module/bloc/todo_state.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/services/todo_repo.dart';

class TodoListEvent {
  final String studentId;
  TodoListEvent({required this.studentId});
}

abstract class TodoListState {}

class TodoListInitialState extends TodoListState {}

class TodoListLoadingState extends TodoListState {}

class TodoListSuccessState extends TodoListState {
  final TodoListResponse todoListResponse;

  TodoListSuccessState({required this.todoListResponse});
}

class TodoListErrorState extends TodoListState {
  final String err;
  TodoListErrorState({required this.err});
}

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final TodoRepo todoRepo;
  TodoListBloc({
    required this.todoRepo,
  }) : super((TodoListInitialState()));

  @override
  Stream<TodoListState> mapEventToState(TodoListEvent event) async* {
    if (event is TodoListEvent) {
      yield TodoListLoadingState();
      try {
        final todoListResponse = await todoRepo.fetchTodoList(event.studentId);
        yield TodoListSuccessState(todoListResponse: todoListResponse);
      } catch (e) {
        yield TodoListErrorState(err: e.toString());
      }
    }
  }
}

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepo todoRepo;

  TodoBloc({
    required this.todoRepo,
  }) : super((TodoInitialState()));

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is UpdateTodoStatusEvent) {
      yield UpdateTodoStatusLoadingState();
      try {
        await todoRepo.updateTodoStatus(
          taskId: event.taskId,
          status: event.status,
          note: event.note
        );

        yield UpdateTodoStatusSuccessState();
      } catch (e) {
        yield UpdateTodoStatusErrorState(err: e.toString());
      }
    } else if (event is UpdateTodoArchiveStatusEvent) {
      yield UpdateTodoArchiveStatusLoadingState();
      try {
        await todoRepo.updateTodoArchiveStatus(
          taskId: event.taskId,
          archived: event.archived,
        );

        yield UpdateTodoArchiveStatusSuccessState();
      } catch (e) {
        yield UpdateTodoArchiveStatusErrorState(err: e.toString());
      }
    } else if (event is UpdateTodoEvent) {
      yield UpdateTodoLoadingState();
      try {
        await todoRepo.updateTodo(
          ids: event.taskId,
          deletedResources: event.deletedResources,
          newResources: event.newResources,
          todoModel: event.todoModel,
        );
        print('done with loading');
        yield UpdateTodoSuccessState();
      } catch (e) {
        yield UpdateTodoErrorState(err: e.toString());
      }
    }
  }
}

class TodoCrudBloc extends Bloc<TodoCrudEvent, TodoCrudState> {
  final TodoRepo todoRepo;

  TodoCrudBloc({
    required this.todoRepo,
  }) : super((TodoCrudInitialState()));

  @override
  Stream<TodoCrudState> mapEventToState(TodoCrudEvent event) async* {
    if (event is CreateTodoEvent) {
      yield CreateTodoLoadingState();
      try {
        final todoId = await todoRepo.createTodo(
          context: event.context,
          todoModel: event.todoModel,
          selfSfId: event.selfSfId,
          asigneeList: event.asigneeList,
          isSendToProgramSelectedFlag: event.isSendToProgramSelectedFlag,
        );
        yield CreateTodoSuccessState(response: todoId);
      } catch (e) {
        yield CreateTodoErrorState(err: e.toString());
      }
    }else if (event is SaveTodoEvent) {
      yield SaveTodoLoadingState();
      try {
        final todoId = await todoRepo.saveTodo(
          todoModel: event.todoModel,
          selfSfId: event.selfSfId,
          asigneeList: event.asigneeList,
          isSendToProgramSelectedFlag: event.isSendToProgramSelectedFlag,
          context: event.context
        );
        yield SaveTodoSuccessState(response: todoId);
      } catch (e) {
        yield SaveTodoErrorState(err: e.toString());
      }
    } else if (event is SaveTodoResourceEvent) {
      yield SaveTodoResourcesLoadingState();
      try {
        await todoRepo.createResourcesTodo(
            resources: event.resources, ids: event.todoId);
        yield SaveTodoResourceSuccessState();
      } catch (e) {
        yield SaveTodoResourceErrorState(err: e.toString());
      }
    } else if (event is CreateTodoResourceEvent) {
      yield CreateTodoResourcesLoadingState();
      try {
        await todoRepo.createResourcesTodo(
            resources: event.resources, ids: event.todoId);
        yield CreateTodoResourceSuccessState();
      } catch (e) {
        yield CreateTodoResourceErrorState(err: e.toString());
      }
    }
  }
}
