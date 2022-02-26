import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/share_drawer_module/model/share_detail_view_model.dart';
import 'package:palette/modules/todo_module/models/createtodo_response_model.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_model.dart';
import 'package:palette/modules/todo_module/services/todo_repo_parents.dart';

abstract class ShareCreateTodoState {}

class ShareCreateTodoInitialState extends ShareCreateTodoState {}

class ShareCreateTodoLoadingState extends ShareCreateTodoState {}

class ShareCreateTodoSuccessState extends ShareCreateTodoState {}

class ShareCreateTodoFailureState extends ShareCreateTodoState {
  final String errorMessage;

  ShareCreateTodoFailureState({required this.errorMessage});
}

abstract class ShareCreateTodoEvent {}

class CreateTodoFromShareEvent extends ShareCreateTodoEvent {
  final TodoModel todomodel;
  final List<String> assigneeIds;
  final String selfId;
  final String urlLink;
  final BuildContext context;
  CreateTodoFromShareEvent(
      {required this.todomodel,
      required this.assigneeIds,
      required this.selfId,
      required this.context,
      required this.urlLink});
}

class SaveTodoShareEvent extends ShareCreateTodoEvent {
  final ShareDetailForTodoViewModel shareDetailForTodoViewModel;

  SaveTodoShareEvent({required this.shareDetailForTodoViewModel});
}

class ShareCreateTodoBloc
    extends Bloc<ShareCreateTodoEvent, ShareCreateTodoState> {
  ShareCreateTodoBloc(ShareCreateTodoState initialState)
      : super(ShareCreateTodoInitialState());

  @override
  Stream<ShareCreateTodoState> mapEventToState(
      ShareCreateTodoEvent event) async* {
    if (event is CreateTodoFromShareEvent) {
      yield ShareCreateTodoLoadingState();
      try {
        ResponseDataAfterCreateTodo resp = await TodoRepoParents.instance
            .createTodoParent(
                todoModel: event.todomodel,
                asigneeList: event.assigneeIds,
                context: event.context,
                isSendToProgramSelectedFlag: false,
                selfSfId: event.selfId);

        await TodoRepoParents.instance.createResourcesTodo(
            todoId: resp.ids,
            resources: [
              Resources(name: event.urlLink, url: event.urlLink, type: "url")
            ]);
        yield ShareCreateTodoSuccessState();
      } catch (e) {
        yield ShareCreateTodoFailureState(errorMessage: e.toString());
      }
    }
  }
}
