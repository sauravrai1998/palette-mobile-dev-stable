import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/todo_module/services/todo_repo_admin.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_model.dart';
import 'package:palette/modules/todo_module/models/createtodo_response_model.dart';

abstract class TodoAdminState {}

abstract class TodoAdminCrudState {}

class TodoAdminInitialState extends TodoAdminState {}

class FetchTodoAdminLoadingState extends TodoAdminState {}

class FetchTodoAdminSuccessState extends TodoAdminState {
  final TodoListResponse todoAdminListResponse;
  FetchTodoAdminSuccessState({required this.todoAdminListResponse});
}

class FetchTodoAdminErrorState extends TodoAdminState {
  final String err;

  FetchTodoAdminErrorState({required this.err});
}

///
/// Task Status Update
///
class UpdateTodoAdminStatusLoadingState extends TodoAdminState {}

class UpdateTodoAdminStatusSuccessState extends TodoAdminState {}

class UpdateTodoAdminStatusErrorState extends TodoAdminState {
  final String err;
  UpdateTodoAdminStatusErrorState({required this.err});
}

///
/// Task Create TodoAdmin
///
class TodoAdminCrudInitialState extends TodoAdminCrudState {}

class CreateTodoAdminLoadingState extends TodoAdminCrudState {}

class CreateTodoAdminSuccessState extends TodoAdminCrudState {
  final ResponseDataAfterCreateTodo response;

  CreateTodoAdminSuccessState({required this.response});
}

class CreateTodoAdminErrorState extends TodoAdminCrudState {
  final String err;
  CreateTodoAdminErrorState({required this.err});
}

///
/// Task Create TodoAdmin Resource
///
class CreateTodoAdminResourceLoadingState extends TodoAdminCrudState {}

class CreateTodoAdminResourceSuccessState extends TodoAdminCrudState {}

class CreateTodoAdminResourceErrorState extends TodoAdminCrudState {
  final String err;
  CreateTodoAdminResourceErrorState({required this.err});
}

class SaveTodoAdminLoadingState extends TodoAdminCrudState {}

class SaveTodoAdminSuccessState extends TodoAdminCrudState {
  final ResponseDataAfterCreateTodo response;

  SaveTodoAdminSuccessState({required this.response});
}

class SaveTodoAdminErrorState extends TodoAdminCrudState {
  final String err;
  SaveTodoAdminErrorState({required this.err});
}

class SaveTodoAdminResourceLoadingState extends TodoAdminCrudState {}

class SaveTodoAdminResourceSuccessState extends TodoAdminCrudState {}

class SaveTodoAdminResourceErrorState extends TodoAdminCrudState {
  final String err;
  SaveTodoAdminResourceErrorState({required this.err});
}
///
/// Task TodoAdmin Update
///
class UpdateTodoAdminLoadingState extends TodoAdminState {}

class UpdateTodoAdminSuccessState extends TodoAdminState {}

class UpdateTodoAdminErrorState extends TodoAdminState {
  final String err;
  UpdateTodoAdminErrorState({required this.err});
}

abstract class TodoAdminEvent {}

abstract class TodoAdminCrudEvent {}

class FetchTodosAdminEvent extends TodoAdminEvent {
  FetchTodosAdminEvent();
}

class CreateTodoAdminEvent extends TodoAdminCrudEvent {
  final TodoModel todoModel;
  final List<String> asignee;
  final BuildContext context;
  final bool isSendToProgramSelectedFlag;
  final String selfSfid;
  CreateTodoAdminEvent({
    required this.todoModel,
    required this.context,
    required this.asignee,
    required this.isSendToProgramSelectedFlag,
    required this.selfSfid,
  });
}

class CreateTodoAdminResourceEvent extends TodoAdminCrudEvent {
  final List<String> todoId;
  final List<Resources> resources;
  CreateTodoAdminResourceEvent({required this.todoId, required this.resources});
}

class SaveTodoAdminEvent extends TodoAdminCrudEvent {
  final TodoModel todoModel;
  final List<String> asignee;
  final bool isSendToProgramSelectedFlag;
  final String selfSfid;
  final BuildContext context;
  SaveTodoAdminEvent({
    required this.todoModel,
    required this.asignee,
    required this.isSendToProgramSelectedFlag,
    required this.selfSfid,
    required this.context
  });
}

class SaveTodoAdminResourceEvent extends TodoAdminCrudEvent {
  final List<String> todoId;
  final List<Resources> resources;
  SaveTodoAdminResourceEvent({required this.todoId, required this.resources});
}

class UpdateTodoAdminEvent extends TodoAdminEvent {
  final List<String> taskId;
  final TodoModel todoModel;
  final List<Resources> newResources;
  final List<String> deletedResources;
  UpdateTodoAdminEvent({
    required this.todoModel,
    required this.taskId,
    required this.newResources,
    required this.deletedResources,
  });
}

class TodoAdminBloc extends Bloc<TodoAdminEvent, TodoAdminState> {
  final TodoRepoAdmins todoRepo;

  TodoAdminBloc({
    required this.todoRepo,
  }) : super((TodoAdminInitialState()));

  @override
  Stream<TodoAdminState> mapEventToState(TodoAdminEvent event) async* {
    if (event is FetchTodosAdminEvent) {
      yield FetchTodoAdminLoadingState();
      try {
        final todoListResponse = await todoRepo.fetchTodoList();
        yield FetchTodoAdminSuccessState(
            todoAdminListResponse: todoListResponse);
      } catch (e) {
        yield FetchTodoAdminErrorState(err: e.toString());
      }
    } else if (event is UpdateTodoAdminEvent) {
      yield UpdateTodoAdminLoadingState();
      try {
        await todoRepo.updateTodo(
          taskId: event.taskId,
          deletedResources: event.deletedResources,
          newResources: event.newResources,
          todoModel: event.todoModel,
        );
        yield UpdateTodoAdminSuccessState();
      } catch (e) {
        yield UpdateTodoAdminErrorState(err: e.toString());
      }
    }
  }
}

class TodoAdminCrudBloc extends Bloc<TodoAdminCrudEvent, TodoAdminCrudState> {
  final TodoRepoAdmins todoRepo;

  TodoAdminCrudBloc({
    required this.todoRepo,
  }) : super((TodoAdminCrudInitialState()));

  @override
  Stream<TodoAdminCrudState> mapEventToState(TodoAdminCrudEvent event) async* {
    if (event is CreateTodoAdminEvent) {
      print('in bloc');
      yield CreateTodoAdminLoadingState();
      try {
        final res = await todoRepo.createTodoAdmin(
          todoModel: event.todoModel,
          asigneeId: event.asignee,
          context: event.context,
          isSendToProgramSelectedFlag: event.isSendToProgramSelectedFlag,
          selfSfId: event.selfSfid,
        );
        yield CreateTodoAdminSuccessState(response: res);
      } catch (e) {
        yield CreateTodoAdminErrorState(err: e.toString());
      }
    } else if (event is CreateTodoAdminResourceEvent) {
      print('CreateTodoAdminResourceEvent');
      yield CreateTodoAdminResourceLoadingState();
      try {
        await todoRepo.createResourcesTodo(
            resources: event.resources, todoId: event.todoId);
        yield CreateTodoAdminResourceSuccessState();
      } catch (e) {
        yield CreateTodoAdminResourceErrorState(err: e.toString());
      }
    } else if (event is SaveTodoAdminEvent) {
      print('Save in bloc');
      yield SaveTodoAdminLoadingState();
      try {
        final res = await todoRepo.saveTodoAdmin(
          todoModel: event.todoModel,
          asigneeId: event.asignee,
          isSendToProgramSelectedFlag: event.isSendToProgramSelectedFlag,
          selfSfId: event.selfSfid,
          context: event.context
        );
        yield SaveTodoAdminSuccessState(response: res);
      } catch (e) {
        yield SaveTodoAdminErrorState(err: e.toString());
      }
    } else if (event is SaveTodoAdminResourceEvent) {
      print('SaveTodoAdminResourceEvent');
      yield CreateTodoAdminResourceLoadingState();
      try {
        await todoRepo.createResourcesTodo(
            resources: event.resources, todoId: event.todoId);
        yield SaveTodoAdminResourceSuccessState();
      } catch (e) {
        yield SaveTodoAdminResourceErrorState(err: e.toString());
      }
    }
  }
}
