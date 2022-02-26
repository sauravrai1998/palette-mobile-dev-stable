import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_event.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_state.dart';
import 'package:palette/modules/todo_module/services/todo_repo_parents.dart';

class TodoParentAdvisorBloc extends Bloc<TodoParentEvent, TodoParentState> {
  final TodoRepoParents todoRepo;

  TodoParentAdvisorBloc({
    required this.todoRepo,
  }) : super((TodoParentInitialState()));

  @override
  Stream<TodoParentState> mapEventToState(TodoParentEvent event) async* {
    if (event is FetchTodosParentEvent) {
      yield FetchTodoParentLoadingState();
      try {
        final todoListResponse = await todoRepo.fetchTodoList();
        yield FetchTodoParentSuccessState(
            todoParentListResponse: todoListResponse);
      } catch (e) {
        yield FetchTodoParentErrorState(err: e.toString());
      }
    } else if (event is UpdateTodoParentEvent) {
      yield UpdateTodoParentLoadingState();
      try {
        await todoRepo.updateTodo(
          taskId: event.taskId,
          deletedResources: event.deletedResources,
          newResources: event.newResources,
          todoModel: event.todoModel,
        );
        yield UpdateTodoParentSuccessState();
      } catch (e) {
        yield UpdateTodoParentErrorState(err: e.toString());
      }
    }
  }
}

class TodoParentCrudBloc
    extends Bloc<TodoParentCrudEvent, TodoParentCrudState> {
  final TodoRepoParents todoRepo;

  TodoParentCrudBloc({
    required this.todoRepo,
  }) : super((TodoParentCrudInitialState()));

  @override
  Stream<TodoParentCrudState> mapEventToState(
      TodoParentCrudEvent event) async* {
    if (event is CreateTodoParentEvent) {
      print('in bloc');
      yield CreateTodoParentLoadingState();
      try {
        final res = await todoRepo.createTodoParent(
          context: event.context,
          isSendToProgramSelectedFlag: event.isSendToProgramSelectedFlag,
          todoModel: event.todoModel,
          asigneeList: event.asignee,
          selfSfId: event.selfSfId,
        );
        yield CreateTodoParentSuccessState(response: res);
      } catch (e) {
        yield CreateTodoParentErrorState(err: e.toString());
      }
    } else if (event is CreateTodoParentResourceEvent) {
      print('CreateTodoParentResourceEvent');
      yield CreateTodoParentResourceLoadingState();
      try {
        await todoRepo.createResourcesTodo(
            resources: event.resources, todoId: event.todoId);
        yield CreateTodoParentResourceSuccessState();
      } catch (e) {
        yield CreateTodoParentResourceErrorState(err: e.toString());
      }
    }else if (event is SaveTodoParentEvent) {
      yield SaveTodoParentLoadingState();
      try {
        final todoId = await todoRepo.saveTodoParent(
          context: event.context,
          todoModel: event.todoModel,
          selfSfId: event.selfSfId,
          asigneeList: event.asignee,
          isSendToProgramSelectedFlag: event.isSendToProgramSelectedFlag,
        );
        yield SaveTodoParentSuccessState(response: todoId);
      } catch (e) {
        yield SaveTodoParentErrorState(err: e.toString());
      }
    } else if (event is SaveTodoParentResourceEvent) {
      yield SaveTodoParentResourceLoadingState();
      try {
        await todoRepo.createResourcesTodo(
            resources: event.resources, todoId: event.todoId);
        yield SaveTodoParentResourceSuccessState();
      } catch (e) {
        yield SaveTodoParentResourceErrorState(err: e.toString());
      }
    }
  }
}
