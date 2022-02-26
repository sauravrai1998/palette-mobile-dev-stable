import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_model.dart';

abstract class TodoParentEvent {}

abstract class TodoParentCrudEvent {}

class FetchTodosParentEvent extends TodoParentEvent {
  FetchTodosParentEvent();
}

class CreateTodoParentEvent extends TodoParentCrudEvent {
  final bool isSendToProgramSelectedFlag;
  final TodoModel todoModel;
  final List<String> asignee;
  final BuildContext context;

  final String selfSfId;

  CreateTodoParentEvent({
    required this.todoModel,
    required this.context,
    required this.asignee,
    required this.isSendToProgramSelectedFlag,
    required this.selfSfId,
  });
}

class CreateTodoParentResourceEvent extends TodoParentCrudEvent {
  final List<String> todoId;
  final List<Resources> resources;
  CreateTodoParentResourceEvent(
      {required this.todoId, required this.resources});
}

class SaveTodoParentEvent extends TodoParentCrudEvent {
  final bool isSendToProgramSelectedFlag;
  final TodoModel todoModel;
  final List<String> asignee;
  final BuildContext context;
  final String selfSfId;

  SaveTodoParentEvent({
    required this.todoModel,
    required this.context,
    required this.asignee,
    required this.isSendToProgramSelectedFlag,
    required this.selfSfId,
  });
}

class SaveTodoParentResourceEvent extends TodoParentCrudEvent {
  final List<String> todoId;
  final List<Resources> resources;
  SaveTodoParentResourceEvent(
      {required this.todoId, required this.resources});
}

class UpdateTodoParentEvent extends TodoParentEvent {
  final List<String> taskId;
  final TodoModel todoModel;
  final List<Resources> newResources;
  final List<String> deletedResources;
  UpdateTodoParentEvent({
    required this.todoModel,
    required this.taskId,
    required this.newResources,
    required this.deletedResources,
  });
}
