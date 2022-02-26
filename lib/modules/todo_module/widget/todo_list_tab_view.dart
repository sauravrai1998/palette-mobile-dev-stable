import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/modules/todo_module/bloc/hide_bottom_navbar_bloc/hide_bottom_navbar_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_bulk_bloc.dart';
import 'package:palette/modules/todo_module/models/filter_models.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_status.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/modules/todo_module/widget/create_new_form.dart';
import 'package:palette/modules/todo_module/widget/todo_list_view.dart';
import 'package:palette/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class TodoListTabView extends StatefulWidget {
  final String searchValued;
  static final _myTabbedPageKey = new GlobalKey<_TodoListTabViewState>();
  final String studentId;
  final String? stdId;
  bool isObserverAdmin;
  bool isParent;
  bool byme;
  bool sortDescending;
  List<FilterCheckboxHeadingModel> filterCheckboxHeadingList;

  TodoListTabView({
    required this.searchValued,
    required this.studentId,
    this.isParent = false,
    this.isObserverAdmin = false,
    this.stdId,
    this.byme = false,
    this.sortDescending = false,
    this.filterCheckboxHeadingList = const [],
  });
  @override
  _TodoListTabViewState createState() => _TodoListTabViewState();
}

class _TodoListTabViewState extends State<TodoListTabView>
    with TickerProviderStateMixin {
  TabController? controller;
  String? sfid;
  String? sfuuid;
  String? role;
  bool hasRequests = false;
  bool createdByMeListNotEmpty = false;
  bool hasDraft = false;

  @override
  void initState() {
    controller ??= TabController(
      initialIndex: widget.isParent ? 1 : 2,
      vsync: this,
      length: widget.isParent ? 4 : 5,
    );
    super.initState();
    _getSfidAndRole();
    _checkState();
    controller?.addListener(() {
      final index = controller?.index;

      if (index == null) return;
      if (index == 0) {
        BlocProvider.of<HideNavbarBloc>(context).add(HideBottomNavbarEvent());
      } else {
        BlocProvider.of<HideNavbarBloc>(context).add(ShowBottomNavbarEvent());
      }
    });
  }

  _checkState() {
    final state = BlocProvider.of<TodoListBloc>(context).state;
    if (state is TodoListSuccessState) {
      final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
      final selfSfid = pendoState.accountId;
      final bymeTabList = state.todoListResponse.todoList.where((todo) {
        return todo.task.listedBy.id == selfSfid;
      }).toList();

      var reqList = state.todoListResponse.todoList.where((todo) {
        return todo.task.acceptedStatus == "Requested";
      }).toList();

      var draftList = state.todoListResponse.todoList.where((todo) {
        return todo.task.taskStatus == "Draft";
      }).toList();

      var length = widget.isParent ? 4 : 5;
      var initialIndex = widget.isParent ? 1 : 2;

      if (reqList.isNotEmpty) {
        length = length + 1;
        initialIndex = initialIndex + 1;
        hasRequests = true;
      }

      if (draftList.isNotEmpty) {
        length = length + 1;
        initialIndex = initialIndex + 1;
        hasDraft = true;
      }

      if (bymeTabList.isNotEmpty) {
        length = length + 1;
        initialIndex = initialIndex + 1;
        createdByMeListNotEmpty = true;
      }

      controller = TabController(
        initialIndex: initialIndex,
        length: length,
        vsync: this,
      );
      setState(() {});
    }
  }

  _getSfidAndRole() async {
    final prefs = await SharedPreferences.getInstance();
    sfid = prefs.getString(sfidConstant);
    sfuuid = prefs.getString(sfidConstant);
    role = prefs.getString('role').toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextScaleFactorClamper(
      child: BlocListener(
        bloc: BlocProvider.of<TodoBulkBloc>(context),
        listener: (context, state) {
          if (state is TodoBulkSuccessState) {
            Helper.showToast('Updated Successfully');
          } else if (state is TodoBulkErrorState) {
            Helper.showToast('Update Failed');
          }
        },
        child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
            builder: (context, pendoState) {
          return Column(children: [
            TabBar(
              indicatorWeight: 4,
              indicatorColor: todoListActiveTab,
              labelColor: todoListActiveTab,
              unselectedLabelColor: defaultDark,
              controller: controller,
              isScrollable: true,
              //labelPadding: EdgeInsets.only(left: 15),
              //indicatorPadding: EdgeInsets.only(left: 15),
              labelStyle: montserratNormal.copyWith(fontSize: 15),
              unselectedLabelStyle: montserratNormal.copyWith(fontSize: 15),
              onTap: (index) {
                print('tab changed');

                if (index == 0) {
                  BlocProvider.of<HideNavbarBloc>(context)
                      .add(HideBottomNavbarEvent());
                } else {
                  BlocProvider.of<HideNavbarBloc>(context)
                      .add(ShowBottomNavbarEvent());
                }
                if (hasRequests && index == 1) {
                  TodoPendoRepo.trackViewTodoRequests(pendoState: pendoState);
                }
                FocusScope.of(context).unfocus();
                TodoPendoRepo.trackTapOnTodoTabEvent(
                    pendoState: pendoState, index: index);
              },
              tabs: [
                if (!widget.isParent)
                  Tab(
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      semanticLabel: "Tap to create a new todo",
                    ),
                  ),
                // Tag - Draft Tab
                if (hasDraft)
                  Tab(
                    text: "DRAFTS",
                  ),
                // Tag - Request Tab
                if (hasRequests)
                  Tab(
                    text: "REQUESTS",
                  ),
                if (createdByMeListNotEmpty && !widget.isParent)
                  Tab(
                    text: "BY ME",
                  ),
                Tab(
                  text: "ALL",
                ),
                Tab(
                  text: "OPEN",
                ),
                Tab(
                  text: "COMPLETED",
                ),
                Tab(
                  text: "CLOSED",
                ),
              ],
            ),
            BlocListener<TodoListBloc, TodoListState>(
              listener: (context, state) {
                if (state is TodoListSuccessState) {
                  final pendoState =
                      BlocProvider.of<PendoMetaDataBloc>(context).state;

                  final bymeTabList =
                      state.todoListResponse.todoList.where((todo) {
                    return todo.task.listedBy.id == pendoState.accountId;
                  }).toList();

                  var reqList = state.todoListResponse.todoList.where((todo) {
                    return todo.task.acceptedStatus == "Requested";
                  }).toList();

                  var draftList = state.todoListResponse.todoList.where((todo) {
                    return todo.task.taskStatus == "Draft";
                  }).toList();

                  var length = widget.isParent ? 4 : 5;
                  var initialIndex = widget.isParent ? 1 : 2;

                  if (reqList.isNotEmpty) {
                    length = length + 1;
                    initialIndex = initialIndex + 1;
                    hasRequests = true;
                  }

                  if (draftList.isNotEmpty) {
                    length = length + 1;
                    initialIndex = initialIndex + 1;
                    hasDraft = true;
                  }

                  if (bymeTabList.isNotEmpty && !widget.isParent) {
                    length = length + 1;
                    initialIndex = initialIndex + 1;
                    createdByMeListNotEmpty = true;
                  }

                  controller = TabController(
                    initialIndex: initialIndex,
                    length: length,
                    vsync: this,
                  );
                  setState(() {});
                }
              },
              child: BlocBuilder<TodoListBloc, TodoListState>(
                builder: (context, state) {
                  if (state is TodoListLoadingState) {
                    return Center(
                      child: Container(
                          height: 38, width: 50, child: CustomPaletteLoader()),
                    );
                  }

                  if (state is TodoListSuccessState) {
                    return _getTabBarView(state: state);
                  }

                  if (state is TodoListErrorState) {
                    return Center(child: Text(state.err));
                  }

                  return SizedBox();
                },
              ),
            ),
          ]);
        }),
      ),
    );
  }

  Widget _getTabBarView({required TodoListSuccessState state}) {
    var stateTodoList = state.todoListResponse.todoList;

    if (widget.sortDescending) {
      stateTodoList
          .sort((b, a) => a.task.completeBy.compareTo(b.task.completeBy));
    } else {
      stateTodoList
          .sort((a, b) => a.task.completeBy.compareTo(b.task.completeBy));
    }

    /// Filtering based on bottom sheet

    var list = Helper.getFilteredTodos(
      filterCheckboxHeadingList: widget.filterCheckboxHeadingList,
      stateTodoList: stateTodoList,
      byme: widget.byme,
      currentUserSfid: widget.stdId,
    );

    if (widget.searchValued != '') {
      if (list != null) {
        list = list
            .where((todo) =>
                todo.task.name!.toLowerCase().contains(widget.searchValued))
            .toList();
      } else {
        stateTodoList = stateTodoList
            .where((todo) =>
                todo.task.name!.toLowerCase().contains(widget.searchValued))
            .toList();
      }
    }
    if (list != null) stateTodoList = list;

    if (widget.sortDescending) {
      stateTodoList
          .sort((b, a) => a.task.completeBy.compareTo(b.task.completeBy));
    } else {
      stateTodoList
          .sort((a, b) => a.task.completeBy.compareTo(b.task.completeBy));
    }

    ///
    var todoLists = stateTodoList;
    List<Todo> allTodoList = [],
        openTodoList = [],
        completeTodoList = [],
        closedTodoList = [],
        requestTodoList = [],
        draftTodoList = [],
        bymeTabList = [];

    todoLists = todoLists.where((item) {
      if (item.task.todoScope == globalString) {
        if (item.task.approvalStatus == 'Approved') {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    }).toList();

    final selfSfid =
        BlocProvider.of<PendoMetaDataBloc>(context).state.accountId;
    bymeTabList = stateTodoList.where((todo) {
      return todo.task.listedBy.id == selfSfid;
    }).toList();

    draftTodoList = stateTodoList.where((todo) {
      return todo.task.taskStatus == "Draft";
    }).toList();

    requestTodoList = stateTodoList.where((todo) {
      return todo.task.acceptedStatus == "Requested";
    }).toList();

    requestTodoList = requestTodoList.where((todo) {
      return todo.task.listedBy.id !=
          BlocProvider.of<PendoMetaDataBloc>(context).state.accountId;
    }).toList();

    requestTodoList = requestTodoList.where((todo) {
      return todo.task.todoScope != globalString;
    }).toList();

    todoLists = todoLists.where((element) {
      // Remove the todo from the main list if it is not global and is requested.
      if (element.task.acceptedStatus == "Requested" &&
          element.task.todoScope != globalString) {
        return false;
      } else {
        return true;
      }
    }).toList();

    allTodoList = todoLists;
    openTodoList = todoLists
        .where((todo) => todo.task.taskStatus == TodoStatus.Open.name)
        .toList();
    completeTodoList = todoLists
        .where((todo) => todo.task.taskStatus == TodoStatus.Completed.name)
        .toList();
    closedTodoList = todoLists
        .where((todo) => todo.task.taskStatus == TodoStatus.Closed.name)
        .toList();

    return Expanded(
      child: Stack(children: [
        TabBarView(
          controller: controller,
          children: [
            if (!widget.isParent)
              CreateNewTodoForm(
                controller: controller!,
                studentId: widget.studentId,
              ),
            if (hasDraft)
              TodoListView(
                todoList: draftTodoList,
                category: '',
                studentId: widget.studentId,
                stdId: widget.stdId,
                isParent: widget.isParent,
                isObserverAdmin: widget.isObserverAdmin,
              ),
            if (hasRequests)
              TodoListView(
                isRequestTab: true,
                todoList: requestTodoList,
                category: '',
                studentId: widget.studentId,
                stdId: widget.stdId,
                isParent: widget.isParent,
                isObserverAdmin: widget.isObserverAdmin,
              ),
            if (createdByMeListNotEmpty && !widget.isParent)
              TodoListView(
                isByMeTab: true,
                todoList: bymeTabList,
                category: '',
                studentId: widget.studentId,
                stdId: widget.stdId,
                isParent: widget.isParent,
                isObserverAdmin: widget.isObserverAdmin,
              ),
            TodoListView(
              todoList: allTodoList,
              category: '',
              studentId: widget.studentId,
              stdId: widget.stdId,
              isParent: widget.isParent,
              isObserverAdmin: widget.isObserverAdmin,
            ),
            // Tag - Request Tab

            TodoListView(
              todoList: openTodoList,
              category: 'OPEN',
              studentId: widget.studentId,
              stdId: widget.stdId,
              isParent: widget.isParent,
              isObserverAdmin: widget.isObserverAdmin,
            ),
            TodoListView(
              todoList: completeTodoList,
              category: 'COMPLETED',
              studentId: widget.studentId,
              stdId: widget.stdId,
              isParent: widget.isParent,
              isObserverAdmin: widget.isObserverAdmin,
            ),
            TodoListView(
              todoList: closedTodoList,
              category: 'CLOSED',
              studentId: widget.studentId,
              stdId: widget.stdId,
              isParent: widget.isParent,
              isObserverAdmin: widget.isObserverAdmin,
            ),
          ],
        ),
      ]),
    );
  }
}
