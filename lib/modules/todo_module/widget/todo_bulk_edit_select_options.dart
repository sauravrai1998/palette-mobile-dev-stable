import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_bulk_bloc.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_status.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/utils/konstants.dart';

class TodoBulkEditSelectOptions extends StatelessWidget {
  final Function onClearAll;
  final List<Todo> todolist;
  const TodoBulkEditSelectOptions(
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
                _option(status: TodoStatus.Open, context: context),
                SizedBox(height: 2),
                _option(status: TodoStatus.Completed, context: context),
                SizedBox(height: 2),
                _option(status: TodoStatus.Closed, context: context),
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

  Widget _option({required TodoStatus status, required BuildContext context}) {
    return Container(
      height: 45,
      child: Center(
        child: InkWell(
          onTap: () {
            List<String> todoids = todolist
                .where((todo) => todo.isSelected)
                .map((todo) => todo.task.asignee[0].todoId)
                .toList();
            print('selected todos $todoids');
            final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
            TodoPendoRepo.trackTodoBulkStatusChange(todoIds: todoids, status: status.name, pendoState: pendoState,);
            BlocProvider.of<TodoBulkBloc>(context).add(
                TodoBulkEditStatusEvent(todoIds: todoids, status: status.name));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status.name,
                style: robotoTextStyle.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.check_circle_outline,
                color: white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
