import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_model.dart';

abstract class TodoEvent {}

abstract class TodoCrudEvent {}

class FetchTodosEvent extends TodoEvent {
  final String studentId;

  FetchTodosEvent({required this.studentId});
}

class UpdateTodoStatusEvent extends TodoEvent {
  final String taskId;
  final String status;
  final String note;

  UpdateTodoStatusEvent({required this.taskId, required this.status, required this.note});
}

class UpdateTodoArchiveStatusEvent extends TodoEvent {
  final String taskId;
  final bool archived;

  UpdateTodoArchiveStatusEvent({required this.taskId, required this.archived});
}

class CreateTodoEvent extends TodoCrudEvent {
  final List<String> asigneeList;
  final BuildContext context;
  final bool isSendToProgramSelectedFlag;
  final String selfSfId;

  final TodoModel todoModel;
  CreateTodoEvent({
    required this.todoModel,
    required this.context,
    required this.asigneeList,
    required this.isSendToProgramSelectedFlag,
    required this.selfSfId,
  });
}

class CreateTodoResourceEvent extends TodoCrudEvent {
  final List<String> todoId;
  final List<Resources> resources;
  CreateTodoResourceEvent({required this.todoId, required this.resources});
}

class SaveTodoEvent extends TodoCrudEvent {
  final List<String> asigneeList;
  final bool isSendToProgramSelectedFlag;
  final String selfSfId;
  final BuildContext context;

  final TodoModel todoModel;
  SaveTodoEvent({
    required this.context,
    required this.todoModel,
    required this.asigneeList,
    required this.isSendToProgramSelectedFlag,
    required this.selfSfId,
  });
}

class SaveTodoResourceEvent extends TodoCrudEvent {
  final List<String> todoId;
  final List<Resources> resources;
  SaveTodoResourceEvent({required this.todoId, required this.resources});
}

class UpdateTodoEvent extends TodoEvent {
  final List<String> taskId;
  final TodoModel todoModel;
  final List<Resources> newResources;
  final List<String> deletedResources;
  UpdateTodoEvent({
    required this.todoModel,
    required this.taskId,
    required this.newResources,
    required this.deletedResources,
  });
}
