import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/todo_module/bloc/draft_todo_publish_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_accept_reject_bloc/todo_accept_reject_bloc.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/modules/todo_module/widget/common_todo_popup.dart';
import 'package:palette/utils/konstants.dart';

import 'custom_chasing_dots_loader.dart';

class TodoPublishButton extends StatelessWidget {
  final String todoId;

  const TodoPublishButton({
    Key? key,
    required this.todoId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bottomOptions(context);
  }

  Widget bottomOptions(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 38),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 4,
            offset: Offset(-2, 6), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: approveButton(onPressed: () {
          print('publishing: $todoId');
          final pendoState =
              BlocProvider.of<PendoMetaDataBloc>(context).state;
          TodoPendoRepo.trackPublishDraftTodo(
            pendoState: pendoState,
            todoId: todoId,
          );
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return TodoAlertPopup(
                type: TodoAlertsType.publish,
                title: 'To-Do',
                body:
                'Are you sure you want to publish this To-Do?',
                cancelTap: () {
                  Navigator.pop(context);
                },
                yesTap: () {
                  Navigator.pop(context);
                  context
                      .read<DraftTodoPublishBloc>()
                      .add(DraftTodoPublishEvent(id: todoId));
                },
              );
            },
          );
          // context
          //     .read<DraftTodoPublishBloc>()
          //     .add(DraftTodoPublishEvent(id: todoId));
        }),
      ),
    );
  }

  Widget approveButton({required Function onPressed}) {
    return BlocBuilder<DraftTodoPublishBloc, DraftTodoState>(
        builder: (context, state) {
          if (state is TodoPublishLoadingState) {
            return CustomChasingDotsLoader(
              color: neoGreen,
            );
          }
          return GestureDetector(
            onTap: () {
              onPressed();
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Text('PUBLISH',
                  style: robotoTextStyle.copyWith(
                      fontSize: 16, fontWeight: FontWeight.bold, color: neoGreen)),
              SizedBox(width: 5),
              Icon(
                Icons.task_alt,
                color: neoGreen,
              )
            ]),
          );
        });
  }
}
