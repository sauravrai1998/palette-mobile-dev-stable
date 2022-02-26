import 'package:palette/modules/todo_module/models/createtodo_response_model.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';

abstract class TodoParentState {}

abstract class TodoParentCrudState {}

class TodoParentInitialState extends TodoParentState {}

class FetchTodoParentLoadingState extends TodoParentState {}

class FetchTodoParentSuccessState extends TodoParentState {
  final TodoListResponse todoParentListResponse;
  FetchTodoParentSuccessState({required this.todoParentListResponse});
}

class FetchTodoParentErrorState extends TodoParentState {
  final String err;

  FetchTodoParentErrorState({required this.err});
}

///
/// Task Status Update
///
class UpdateTodoParentStatusLoadingState extends TodoParentState {}

class UpdateTodoParentStatusSuccessState extends TodoParentState {}

class UpdateTodoParentStatusErrorState extends TodoParentState {
  final String err;
  UpdateTodoParentStatusErrorState({required this.err});
}

///
/// Task Create TodoParent
///
class TodoParentCrudInitialState extends TodoParentCrudState {}

class CreateTodoParentLoadingState extends TodoParentCrudState {}

class CreateTodoParentSuccessState extends TodoParentCrudState {
  final ResponseDataAfterCreateTodo response;

  CreateTodoParentSuccessState({required this.response});
}

class CreateTodoParentErrorState extends TodoParentCrudState {
  final String err;
  CreateTodoParentErrorState({required this.err});
}

///
/// Task Create TodoParent Resource
///
class CreateTodoParentResourceLoadingState extends TodoParentCrudState {}

class CreateTodoParentResourceSuccessState extends TodoParentCrudState {}

class CreateTodoParentResourceErrorState extends TodoParentCrudState {
  final String err;
  CreateTodoParentResourceErrorState({required this.err});
}


class SaveTodoParentLoadingState extends TodoParentCrudState {}

class SaveTodoParentSuccessState extends TodoParentCrudState {
  final ResponseDataAfterCreateTodo response;

  SaveTodoParentSuccessState({required this.response});
}

class SaveTodoParentErrorState extends TodoParentCrudState {
  final String err;
  SaveTodoParentErrorState({required this.err});
}

class SaveTodoParentResourceLoadingState extends TodoParentCrudState {}

class SaveTodoParentResourceSuccessState extends TodoParentCrudState {}

class SaveTodoParentResourceErrorState extends TodoParentCrudState {
  final String err;
  SaveTodoParentResourceErrorState({required this.err});
}

///
/// Task TodoParent Update
///
class UpdateTodoParentLoadingState extends TodoParentState {}

class UpdateTodoParentSuccessState extends TodoParentState {}

class UpdateTodoParentErrorState extends TodoParentState {
  final String err;
  UpdateTodoParentErrorState({required this.err});
}
