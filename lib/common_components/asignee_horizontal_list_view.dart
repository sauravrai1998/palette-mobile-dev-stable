import 'package:flutter/material.dart';
import 'package:palette/common_components/institute_logo.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_status.dart';
import 'package:palette/modules/todo_module/widget/parent_advisor_todo_widgets/parent_todo_icon.dart';

import 'common_components_link.dart';

class AsigneeHorizontalListView extends StatelessWidget {
  final Todo todoItem;

  const AsigneeHorizontalListView({
    Key? key,
    required this.todoItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if ((todoItem.task.todoScope == globalString ||
            todoItem.task.asignee.isNotEmpty))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person),
                    Text(
                      "  ASSIGNEES",
                      style: montserratNormal,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Builder(builder: (context) {
                  if (todoItem.task.todoScope == globalString) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        children: [
                          InstituteLogo(radius: 20),
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ENTIRE PROGRAM",
                                style: robotoTextStyle.copyWith(
                                  color: defaultDark,
                                ),
                              ),
                              Text(
                                "TAWS - Tranzed Academy For Working Students",
                                style: robotoTextStyle.copyWith(
                                  color: greyishGrey2,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  return Container(
                      //padding: EdgeInsets.all(12),
                      height: 123,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: todoItem.task.asignee.length,
                        itemBuilder: (ctx, ind) {
                          var fullName =
                              todoItem.task.asignee[ind].asigneeName.split(" ");
                          var firstName =
                              fullName[0].trim().substring(0, 1).toUpperCase();
                          var lastName =
                              fullName[1].trim().substring(0, 1).toUpperCase();
                          var initial = firstName + lastName;
                          return Container(
                            //width: 80,
                            padding: const EdgeInsets.only(left: 8),
                            //margin: EdgeInsets.all(4),
                            child: Tooltip(
                              message: _getToolTipMessage(todoItem, ind) ?? " ",
                              preferBelow: true,
                              verticalOffset: 39,
                              waitDuration: Duration(seconds: 0),
                              textStyle: montserratNormal.copyWith(
                                  fontSize: 12, color: Colors.white),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _getStatusBrColor(todoItem, ind),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ExcludeSemantics(
                                    child: ProfileIconTodo(
                                      initial: initial,
                                      img: todoItem.task.asignee[ind]
                                              .profilePicture ??
                                          '',
                                      height: 60,
                                      bgColor: _getStatusBrColor(todoItem, ind),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Center(
                                    child: Text(
                                      todoItem.task.asignee[ind].asigneeName,
                                      style: roboto700.copyWith(
                                          color: defaultDark, fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ));
                })
              ],
            ),
          ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }

  Color _getStatusBrColor(Todo todo, int index) {
    if (todo.task.asignee[index].acceptedStatus != null) {
      if (todo.task.asignee[index].acceptedStatus == 'Rejected') {
        return greyishGrey.withOpacity(0.5);
      } else if (todo.task.asignee[index].acceptedStatus == 'Requested') {
        return greyishGrey;
      }
    }

    final status = todo.task.asignee[index].status;
    if (status == TodoStatus.Open.name)
      return openOpacTool;
    else if (status == TodoStatus.Completed.name)
      return completedOpacTool;
    else
      return closedOpacTool;
  }

  String _getToolTipMessage(Todo todo, int index) {
    final acceptedSt = todo.task.asignee[index].acceptedStatus;
    if (acceptedSt != null && acceptedSt != 'Accepted') {
      if (acceptedSt == 'Rejected') {
        return 'Rejected';
      } else if (acceptedSt == 'Requested') {
        return 'Yet to accept';
      }
    }

    return todoItem.task.asignee[index].status == null ? '':todoItem.task.asignee[index].status;
  }
}
