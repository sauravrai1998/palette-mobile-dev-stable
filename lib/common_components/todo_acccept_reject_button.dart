import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_accept_reject_bloc/todo_accept_reject_bloc.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/utils/konstants.dart';

import 'custom_chasing_dots_loader.dart';

class TodoAcceptRejectButton extends StatelessWidget {
  final String todoId;

  const TodoAcceptRejectButton({
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            approveButton(onPressed: () {
              final pendoState =
                  BlocProvider.of<PendoMetaDataBloc>(context).state;
              TodoPendoRepo.trackAcceptTodoRequest(
                pendoState: pendoState,
                todoId: todoId,
              );
              context
                  .read<TodoAcceptRejectBloc>()
                  .add(TodoAcceptPostEvent(id: todoId));
            }),
            rejectButton(onPressed: () {
              BlocProvider.of<TodoAcceptRejectBloc>(context)
                  .add(TodoRejectPostEvent(id: todoId));
            }),
          ],
        ),
      ),
    );
  }

  Widget approveButton({required Function onPressed}) {
    return BlocBuilder<TodoAcceptRejectBloc, TodoAcceptRejectState>(
        builder: (context, state) {
      if (state is TodoAcceptLoadingState) {
        return CustomChasingDotsLoader(
          color: neoGreen,
        );
      }
      return GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Row(children: [
          Text('ACCEPT',
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

  Widget rejectButton({required Function onPressed}) {
    return BlocBuilder<TodoAcceptRejectBloc, TodoAcceptRejectState>(
        builder: (context, state) {
      if (state is TodoRejectLoadingState) {
        return CustomChasingDotsLoader(
          color: red,
        );
      }
      return GestureDetector(
        onTap: () {
          final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
          TodoPendoRepo.trackRejectTodoRequest(
            pendoState: pendoState,
            todoId: todoId,
          );
          onPressed();
        },
        child: Row(
          children: [
            Icon(
              Icons.cancel_outlined,
              color: red,
              size: 20,
            ),
          ],
        ),
      );
    });
  }
}
