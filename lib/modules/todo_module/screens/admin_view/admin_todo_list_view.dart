import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_accept_reject_bloc/todo_accept_reject_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_accept_reject_bulk_bloc.dart/todo_accept_reject_bulk_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_ad_bloc/todo_ad_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_bulk_bloc.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/ward.dart';
import 'package:palette/modules/todo_module/widget/todo_bulk_edit_select_options.dart';
import 'package:palette/modules/todo_module/widget/todo_list_item.dart';
import 'package:palette/modules/todo_module/widget/todo_request_bulk_options.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

class AdminTodoListView extends StatefulWidget {
  final List<Todo> todoList;
  final bool isRequestTab;
  final bool isByMeTab;
  final String category;
  final List<Ward> asignee;
  final bool isParent;
  final bool useSliver;
  final String? stdId;

  AdminTodoListView(
      {Key? key,
      required this.todoList,
      required this.category,
      this.useSliver = false,
      this.isByMeTab = false,
      this.stdId,
      this.isParent = true,
      this.isRequestTab = false,
      required this.asignee})
      : super(key: key);

  @override
  _AdminTodoListViewState createState() => _AdminTodoListViewState();
}

class _AdminTodoListViewState extends State<AdminTodoListView> {
  var _inSelectMode = false;
  var _expandedFAB = false;

  @override
  void initState() {
    super.initState();
    _checkIfWeWereInSelectMode();
  }

  _checkIfWeWereInSelectMode() {
    final selectedList = widget.todoList.where((element) => element.isSelected);
    if (selectedList.isNotEmpty) {
      _inSelectMode = true;
    }
  }

  Widget getChild(int index) {
    var no = index + 1;
    final type = widget.todoList[index].task.type ?? 'Other';

    /// For social icon has to be checked for 4 types
    final grad1 = type.startsWith('College') || type.startsWith('Education')
        ? educationColorGrad1
        : type.startsWith('Job')
            ? companyColorGrad1
            : type == 'Other'
                ? genericColorGrad1
                : socialColorGrad1;
    final grad2 = type.startsWith('College') || type.startsWith('Education')
        ? educationColorGrad2
        : type.startsWith('Job')
            ? companyColorGrad2
            : type == 'Other'
                ? genericColorGrad2
                : socialColorGrad2;

    final image = type.startsWith('College') || type.startsWith('Education')
        ? "images/todo_education.svg"
        : type.startsWith('Job')
            ? "images/todo_business.svg"
            : _getImageStringForEvent(type: type);

    final iconBackground =
        type.startsWith('College') || type.startsWith('Education')
            ? educationColorGrad1
            : type.startsWith('Job')
                ? companyColorGrad1
                : type == 'Other'
                    ? genericColorGrad1
                    : socialColorGrad1;

    return Semantics(
      label: "Todo $no",
      child: Padding(
        padding: EdgeInsets.only(
            top: widget.useSliver && index == 0 ? 40.0 : 0,
            bottom: (index == widget.todoList.length - 1) ? 40 : 0),
        child: TodoListItemWidget(
          todo: widget.todoList[index],
          grad1: grad1,
          isRequestTab: widget.isRequestTab,
          isByMeTab: widget.isByMeTab,
          grad2: grad2,
          imageLoc: image,
          iconBackground: iconBackground,
          studentId: " ",
          isParent: widget.isParent,
          stdId: this.widget.stdId,
          asignee: widget.asignee,
          calledFromAdvisorParent: true,
          inSelectMode: _inSelectMode,
          inSelectModeCallBack: () {
            setState(() {
              widget.todoList[index].isSelected =
                  !widget.todoList[index].isSelected;
            });
            if (_noItemSelected(widget.todoList)) {
              setState(() {
                _inSelectMode = false;
              });
            }
          },
          onLongPress: () {
            print('longpresssssss');
            setState(() {
              _inSelectMode = true;
              widget.todoList[index].isSelected = true;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useSliver) {
      return widget.todoList.isEmpty
          ? SliverFillRemaining(
              child: Center(
                child: Text(
                  'NO TASKS ${widget.category}',
                  style: montserratBoldTextStyle,
                ),
              ),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => getChild(index),
                  childCount: widget.todoList.length),
            );
    }
    return widget.todoList.isNotEmpty
        ? Scaffold(
            floatingActionButton: _inSelectMode
                ? BlocListener<TodoAcceptRejectBulkBloc,
                    TodoAcceptRejectBulkState>(
                    listener: (context, state) {
                      if (state is TodoAcceptBulkSuccessState ||
                          state is TodoRejectSuccessState ||
                          state is TodoAcceptBulkFailedState ||
                          state is TodoRejectBulkFailedState) {
                        _clearSelection();

                        setState(() {});
                      }

                      if (state is TodoAcceptBulkSuccessState ||
                          state is TodoRejectBulkSuccessState) {
                        context
                            .read<TodoAdminBloc>()
                            .add(FetchTodosAdminEvent());
                      } else if (state is TodoAcceptBulkFailedState ||
                          state is TodoRejectBulkFailedState) {
                        ///

                      }
                    },
                    bloc: context.read<TodoAcceptRejectBulkBloc>(),
                    child: BlocListener(
                      bloc: context.read<TodoBulkBloc>(),
                      listener: (context, state) {
                        if (state is TodoBulkSuccessState ||
                            state is TodoBulkErrorState) {
                          _clearSelection();
                          setState(() {});
                        }
                        if (state is TodoBulkSuccessState) {
                          Helper.showToast('Updated Successfully');
                          context
                              .read<TodoAdminBloc>()
                              .add(FetchTodosAdminEvent());
                        } else if (state is TodoBulkErrorState) {
                          Helper.showToast('Updated Failed');
                        }
                      },
                      child: BlocBuilder<TodoBulkBloc, TodoBulkState>(
                          builder: (context, state) {
                        if (state is TodoBulkSuccessState ||
                            state is TodoBulkErrorState) {}
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Builder(builder: (context) {
                                if (_expandedFAB && widget.isRequestTab) {
                                  return TodoRequestBulkOptions(
                                    onClearAll: () {
                                      _clearSelection();
                                      setState(() {});
                                    },
                                    todolist: widget.todoList,
                                  );
                                } else if (_expandedFAB &&
                                    !widget.isRequestTab) {
                                  return TodoBulkEditSelectOptions(
                                      onClearAll: () {
                                        _clearSelection();
                                        setState(() {});
                                      },
                                      todolist: widget.todoList);
                                } else {
                                  return Container();
                                }
                              }),
                              SizedBox(height: 10),
                              FloatingActionButton(
                                backgroundColor: uploadIconButtonColor,
                                onPressed: () {
                                  setState(() {
                                    _expandedFAB = !_expandedFAB;
                                  });
                                },
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22.5)),
                                    color: uploadIconButtonColor,
                                  ),
                                  child: Center(
                                    child: _expandedFAB
                                        ? Icon(Icons.close)
                                        : Icon(
                                            Icons.arrow_forward_ios_outlined),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  )
                : null,
            body: ListView.builder(
              padding:
                  EdgeInsets.only(bottom: kFloatingActionButtonMargin + 46),
              itemCount: widget.todoList.length,
              itemBuilder: (context, index) {
                return getChild(index);
              },
            ),
          )
        : Center(
            child: Text(
              'NO TASKS ${widget.category}',
              style: montserratBoldTextStyle,
            ),
          );
  }

  String _getImageStringForEvent({required String type}) {
    if (type == 'Event - Arts') {
      return 'images/todo_arts.svg';
    } else if (type == 'Event - Volunteer') {
      return 'images/todo_volunteer.svg';
    } else if (type == 'Event - Social') {
      return 'images/todo_social.svg';
    } else if (type == 'Events - Sports') {
      return 'images/todo_sports.svg';
    } else if (type == 'Employment') {
      return 'images/employment.svg';
    } else {
      return 'images/genericVM.svg';
    }
  }

  void _clearSelection() {
    widget.todoList.forEach((todo) => todo.isSelected = false);
    _inSelectMode = false;
    _expandedFAB = false;
  }

  bool _noItemSelected(List<Todo> list) {
    final c = list.where((element) => element.isSelected);
    return c.isEmpty;
  }
}
