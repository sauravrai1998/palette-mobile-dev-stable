import 'package:palette/modules/todo_module/models/createtodo_response_model.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';

abstract class TodoState {}

abstract class TodoCrudState {}

class TodoInitialState extends TodoState {}

class FetchTodoLoadingState extends TodoState {}

class FetchTodoSuccessState extends TodoState {
  final TodoListResponse todoListResponse;

  FetchTodoSuccessState({required this.todoListResponse});
}

class FetchTodoErrorState extends TodoState {
  final String err;

  FetchTodoErrorState({required this.err});
}

///
/// Task Status Update
///
class UpdateTodoStatusLoadingState extends TodoState {}

class UpdateTodoStatusSuccessState extends TodoState {}

class UpdateTodoStatusErrorState extends TodoState {
  final String err;
  UpdateTodoStatusErrorState({required this.err});
}

///
/// Task Status Update
///
class UpdateTodoArchiveStatusLoadingState extends TodoState {}

class UpdateTodoArchiveStatusSuccessState extends TodoState {}

class UpdateTodoArchiveStatusErrorState extends TodoState {
  final String err;
  UpdateTodoArchiveStatusErrorState({required this.err});
}

///
/// Task Create Todo
///
class TodoCrudInitialState extends TodoCrudState {}

class CreateTodoLoadingState extends TodoCrudState {}

class CreateTodoSuccessState extends TodoCrudState {
  final ResponseDataAfterCreateTodo response;

  CreateTodoSuccessState({required this.response});
}

class CreateTodoErrorState extends TodoCrudState {
  final String err;
  CreateTodoErrorState({required this.err});
}

///
/// Task Create Todo Resource
///
class CreateTodoResourcesLoadingState extends TodoCrudState {}

class CreateTodoResourceSuccessState extends TodoCrudState {}

class CreateTodoResourceErrorState extends TodoCrudState {
  final String err;
  CreateTodoResourceErrorState({required this.err});
}

///
/// Save Todo
///
class SaveTodoLoadingState extends TodoCrudState {}

class SaveTodoSuccessState extends TodoCrudState {
  final ResponseDataAfterCreateTodo response;

  SaveTodoSuccessState({required this.response});
}

class SaveTodoErrorState extends TodoCrudState {
  final String err;
  SaveTodoErrorState({required this.err});
}

class SaveTodoResourcesLoadingState extends TodoCrudState {}

class SaveTodoResourceSuccessState extends TodoCrudState {}

class SaveTodoResourceErrorState extends TodoCrudState {
  final String err;
  SaveTodoResourceErrorState({required this.err});
}

///
/// Task Todo Update
///
class UpdateTodoLoadingState extends TodoState {}

class UpdateTodoSuccessState extends TodoState {}

class UpdateTodoErrorState extends TodoState {
  final String err;
  UpdateTodoErrorState({required this.err});
}
