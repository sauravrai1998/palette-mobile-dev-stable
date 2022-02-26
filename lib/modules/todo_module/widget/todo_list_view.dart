import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_accept_reject_bloc/todo_accept_reject_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_accept_reject_bulk_bloc.dart/todo_accept_reject_bulk_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_bulk_bloc.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/widget/todo_bulk_edit_select_options.dart';
import 'package:palette/modules/todo_module/widget/todo_list_item.dart';
import 'package:palette/modules/todo_module/widget/todo_request_bulk_options.dart';
import 'package:palette/utils/konstants.dart';

class TodoListView extends StatefulWidget {
  final List<Todo> todoList;
  final bool isRequestTab;
  final String category;
  final bool isByMeTab;
  final studentId;
  final bool isParent;
  final bool isObserverAdmin;
  final ScrollController? scrollController;
  final String? stdId;
  final bool useSliver;
  final void Function(bool)? updateInselectMode;

  TodoListView({
    Key? key,
    required this.todoList,
    required this.category,
    this.updateInselectMode,
    this.useSliver = false,
    this.scrollController,
    this.isRequestTab = false,
    this.isByMeTab = false,
    this.stdId,
    this.isParent = false,
    this.isObserverAdmin = false,
    required this.studentId,
  }) : super(key: key);

  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  var _inSelectMode = false;
  var _expandedFAB = false;

  @override
  void initState() {
    _checkIfWeWereInSelectMode();
    super.initState();
  }

  _checkIfWeWereInSelectMode() {
    final selectedList = widget.todoList.where((element) => element.isSelected);
    if (selectedList.isNotEmpty) {
      _inSelectMode = true;
      if (widget.updateInselectMode != null) {
        widget.updateInselectMode!(true);
      }
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
          isRequestTab: widget.isRequestTab,
          isByMeTab: widget.isByMeTab,
          todo: widget.todoList[index],
          grad1: grad1,
          grad2: grad2,
          imageLoc: image,
          iconBackground: iconBackground,
          studentId: widget.studentId,
          isParent: widget.isParent,
          stdId: this.widget.stdId,
          calledFromAdvisorParent: false,
          isObserverAdmin: this.widget.isObserverAdmin,
          inSelectMode: _inSelectMode,
          inSelectModeCallBack: () {
            setState(() {
              widget.todoList[index].isSelected =
                  !widget.todoList[index].isSelected;
              log("IsSelected Value is:${widget.todoList[index].isSelected}");
            });
            if (_noItemSelected(widget.todoList)) {
              setState(() {
                _inSelectMode = false;
                if (widget.updateInselectMode != null) {
                  widget.updateInselectMode!(false);
                }
              });
            }
          },
          onLongPress: () {
            setState(() {
              _inSelectMode = true;
              if (widget.updateInselectMode != null) {
                widget.updateInselectMode!(true);
              }
              widget.todoList[index].isSelected = true;
            });
          },
        ),
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return widget.useSliver
        ? widget.todoList.isEmpty
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
              )
        : widget.todoList.isNotEmpty
            ? Scaffold(
                floatingActionButton: _inSelectMode
                    ? BlocListener(
                        listener: (context, state) {
                          if (state is TodoAcceptBulkSuccessState ||
                              state is TodoRejectSuccessState ||
                              state is TodoAcceptBulkFailedState ||
                              state is TodoRejectBulkFailedState) {
                            _clearSelection();
                            setState(() {});
                          }
                        },
                        bloc: context.read<TodoAcceptRejectBulkBloc>(),
                        child: BlocListener(
                          listener: (context, state) {
                            if (state is TodoBulkSuccessState ||
                                state is TodoBulkErrorState) {
                              _clearSelection();
                              setState(() {});
                            }
                          },
                          bloc: context.read<TodoBulkBloc>(),
                          child: BlocBuilder<TodoBulkBloc, TodoBulkState>(
                              builder: (context, state) {
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(22.5)),
                                        color: uploadIconButtonColor,
                                      ),
                                      child: Center(
                                        child: _expandedFAB
                                            ? Icon(Icons.close)
                                            : Icon(Icons
                                                .arrow_forward_ios_outlined),
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
                  padding: const EdgeInsets.only(
                      bottom: kFloatingActionButtonMargin + 48),
                  itemCount: widget.todoList.length,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) => getChild(index),
                ),
              )
            : Center(
                child: Text(
                  'NO TASKS ${widget.category}',
                  style: montserratBoldTextStyle,
                ),
              );
  }

  getFloatingBtn() {
    return _inSelectMode
        ? BlocListener(
            listener: (context, state) {
              log("Status Listening is:$state");
              if (state is TodoAcceptBulkSuccessState ||
                  state is TodoRejectSuccessState ||
                  state is TodoAcceptBulkFailedState ||
                  state is TodoRejectBulkFailedState) {
                _clearSelection();
                setState(() {});
              }
            },
            bloc: context.read<TodoAcceptRejectBulkBloc>(),
            child: BlocListener(
              listener: (context, state) {
                if (state is TodoBulkSuccessState ||
                    state is TodoBulkErrorState) {
                  _clearSelection();
                  setState(() {});
                }
              },
              bloc: context.read<TodoBulkBloc>(),
              child: BlocBuilder<TodoBulkBloc, TodoBulkState>(
                  builder: (context, state) {
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
                        } else if (_expandedFAB && !widget.isRequestTab) {
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
                                : Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          )
        : SizedBox();
  }

  void _clearSelection() {
    widget.todoList.forEach((todo) => todo.isSelected = false);
    _inSelectMode = false;
    if (widget.updateInselectMode != null) {
      widget.updateInselectMode!(false);
    }
    _expandedFAB = false;
  }

  bool _noItemSelected(List<Todo> list) {
    final c = list.where((element) => element.isSelected);
    return c.isEmpty;
  }

  String _getImageStringForEvent({required String type}) {
    if (type == 'Event - Arts') {
      return 'images/todo_arts.svg';
    } else if (type == 'Event - Volunteer') {
      return 'images/todo_volunteer.svg';
    } else if (type == 'Event - Social') {
      return 'images/todo_social.svg';
    } else if (type == 'Event - Sports') {
      return 'images/todo_sports.svg';
    } else if (type == 'Employment') {
      return 'images/employment.svg';
    } else {
      return 'images/genericVM.svg';
    }
  }
}
