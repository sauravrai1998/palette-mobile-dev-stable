import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_accept_reject_bulk_bloc.dart/todo_accept_reject_bulk_bloc.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/utils/konstants.dart';

class TodoRequestBulkOptions extends StatelessWidget {
  final Function onClearAll;
  final List<Todo> todolist;
  const TodoRequestBulkOptions(
      {Key? key, required this.onClearAll, required this.todolist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: uploadIconButtonColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  'Options',
                  style: roboto700.copyWith(fontSize: 14, color: Colors.white),
                ),
                SizedBox(height: 4),
                Container(
                  width: 28,
                  height: 1.6,
                  color: Colors.white,
                ),
                SizedBox(height: 8),
                _acceptButton(context: context),
                SizedBox(height: 2),
                _rejectButton(context: context),
              ],
            ),
          ),
          _clearSelectionButton()
        ],
      ),
    );
  }

  Widget _clearSelectionButton() {
    return InkWell(
      onTap: () => onClearAll(),
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 12),
        color: clearSelectionBackgroundColor.withOpacity(0.12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Clear Selection',
              style:
                  robotoTextStyle.copyWith(fontSize: 14, color: Colors.white),
            ),
            Icon(
              Icons.delete,
              color: white,
              size: 18,
            )
          ],
        ),
      ),
    );
  }

  Widget _acceptButton({required BuildContext context}) {
    return Container(
      height: 45,
      child: Center(
        child: InkWell(
          onTap: () {
            List<String> todoIds = todolist
                .where((todo) => todo.isSelected)
                .map((todo) => todo.task.asignee[0].todoId)
                .toList();
            print('selected todos $todoIds');
            BlocProvider.of<TodoAcceptRejectBulkBloc>(context).add(TodoAcceptBulkPostEvent(todoIds: todoIds));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ACCEPT',
                style: robotoTextStyle.copyWith(
                  fontSize: 16,
                  color: white,
                ),
              ),
              Icon(
                Icons.task_alt,
                color: white,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rejectButton({required BuildContext context}) {
    return Container(
      height: 45,
      child: Center(
        child: InkWell(
          onTap: () {
            List<String> todoIds = todolist
                .where((todo) => todo.isSelected)
                .map((todo) => todo.task.asignee[0].todoId)
                .toList();
            print('selected todos $todoIds');
            BlocProvider.of<TodoAcceptRejectBulkBloc>(context).add(TodoRejectBulkPostEvent(todoIds: todoIds));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'REJECT',
                style: robotoTextStyle.copyWith(
                  fontSize: 16,
                  color: white,
                ),
              ),
              Icon(
                Icons.cancel_outlined,
                color: white,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
