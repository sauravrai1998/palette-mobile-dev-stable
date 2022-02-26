import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/advisor_dashboard_module/models/advisor_student_model.dart';
import 'package:palette/modules/profile_module/models/user_models/abstract_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/advisor_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/parent_profile_user_model.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_bloc.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_event.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_state.dart';
import 'package:palette/modules/todo_module/bloc/hide_bottom_navbar_bloc/hide_bottom_navbar_bloc.dart';
import 'package:palette/modules/todo_module/models/filter_models.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/ward.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/modules/todo_module/widget/parent_advisor_todo_widgets/parent_advisor_todo_list_view.dart';
import 'package:palette/utils/helpers.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'parent_advisor_create_new_todo_form.dart';

class ParentAdvisorTodoListTabView extends StatefulWidget {
  // final int selectedIndex;
  final selectedIndex;
  final String searchText;
  // final String studentId;
  final BaseProfileUserModel? parentOrAdvisor;
  final List<AdvisorStudent> advisorStudents;
  final bool sortDescending;
  final bool byme;
  final List<FilterCheckboxHeadingModel> filterCheckboxHeadingList;

  ParentAdvisorTodoListTabView({
    required this.searchText,
    required this.parentOrAdvisor,
    this.sortDescending = false,
    this.byme = false,
    this.selectedIndex = 2,
    this.advisorStudents = const [],
    this.filterCheckboxHeadingList = const [],
  });
  @override
  _ParentAdvisorTodoListTabViewState createState() =>
      _ParentAdvisorTodoListTabViewState();
}

class _ParentAdvisorTodoListTabViewState
    extends State<ParentAdvisorTodoListTabView> with TickerProviderStateMixin {
  var controller;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? role;
  String? sfid;
  String? sfuuid;
  bool hasRequests = false;
  bool hasDraft = false;
  bool createdByMeListNotEmpty = false;

  @override
  void initState() {
    controller ??= TabController(
      initialIndex: widget.selectedIndex,
      vsync: this,
      length: 5,
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
    final state = BlocProvider.of<TodoParentAdvisorBloc>(context).state;
    if (state is FetchTodoParentSuccessState) {
      final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;

      final bymeTabList = state.todoParentListResponse.todoList.where((todo) {
        return todo.task.listedBy.id == pendoState.accountId;
      }).toList();

      var draftList = state.todoParentListResponse.todoList.where((todo) {
        return todo.task.taskStatus == "Draft";
      }).toList();

      var reqList = state.todoParentListResponse.todoList.where((todo) {
        return todo.task.acceptedStatus == "Requested";
      }).toList();

      var length = 5;
      var initialIndex = 2;

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
    sfuuid = prefs.getString(saleforceUUIDConstant);
    role = prefs.getString('role').toString();
  }

  @override
  Widget build(BuildContext context) {
    void _onRefresh() async {
      final bloc = context.read<TodoParentAdvisorBloc>();
      bloc.add(
        FetchTodosParentEvent(),
      );
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
    }

    void _onLoading() async {
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use loadFailed(),if no data return,use LoadNodata()
      if (mounted) setState(() {});
      _refreshController.loadComplete();
    }

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropHeader(
        waterDropColor: defaultDark,
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: TextScaleFactorClamper(
        child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
            builder: (context, pendoState) {
          return Column(
            children: [
              BlocListener(
                bloc: context.read<TodoParentAdvisorBloc>(),
                listener: (context, state) {
                  if (state is FetchTodoParentSuccessState) {
                    final pendoState =
                        BlocProvider.of<PendoMetaDataBloc>(context).state;
                    final bymeTabList =
                        state.todoParentListResponse.todoList.where((todo) {
                      return todo.task.listedBy.id == pendoState.accountId;
                    }).toList();

                    var reqList =
                        state.todoParentListResponse.todoList.where((todo) {
                      return todo.task.acceptedStatus == "Requested";
                    }).toList();

                    var draftList =
                        state.todoParentListResponse.todoList.where((todo) {
                      return todo.task.taskStatus == "Draft";
                    }).toList();

                    var length = 5;
                    var initialIndex = 2;

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
                },
                child: TabBar(
                  indicatorWeight: 4,
                  indicatorColor: todoListActiveTab,
                  labelColor: todoListActiveTab,
                  unselectedLabelColor: defaultDark,
                  controller: controller,
                  isScrollable: true,
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
                      TodoPendoRepo.trackViewTodoRequests(
                          pendoState: pendoState);
                    }
                    FocusScope.of(context).unfocus();
                    TodoPendoRepo.trackTapOnTodoTabEvent(
                      pendoState: pendoState,
                      index: index,
                    );
                  },
                  //labelPadding: EdgeInsets.only(left: 15),
                  //indicatorPadding: EdgeInsets.only(left: 15),
                  labelStyle: montserratNormal.copyWith(fontSize: 15),
                  unselectedLabelStyle: montserratNormal.copyWith(fontSize: 15),
                  tabs: [
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
                    if (hasRequests)
                      Tab(
                        text: "REQUESTS",
                      ),
                    if (createdByMeListNotEmpty)
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
              ),
              BlocBuilder<TodoParentAdvisorBloc, TodoParentState>(
                builder: (context, state) {
                  if (state is FetchTodoParentLoadingState) {
                    return Center(
                      child: Container(
                          height: 38, width: 50, child: CustomPaletteLoader()),
                    );
                  }

                  if (state is FetchTodoParentSuccessState) {
                    return _getTabBarView(state: state);
                  }

                  if (state is FetchTodoParentErrorState) {
                    return Center(child: Text(state.err));
                  }

                  return SizedBox();
                },
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _getTabBarView({required FetchTodoParentSuccessState state}) {
    ParentProfileUserModel? parent;
    AdvisorProfileUserModel? advisor;

    if (widget.parentOrAdvisor is ParentProfileUserModel) {
      parent = widget.parentOrAdvisor as ParentProfileUserModel;
    } else {
      advisor = widget.parentOrAdvisor as AdvisorProfileUserModel;
    }

    List<Ward> wards = [];

    if (parent != null) {
      wards = parent.pupils
          .map((pupil) => Ward(
              id: pupil.id,
              name: pupil.name,
              profilePicture: pupil.profilePicture ?? ''))
          .toList();
    } else if (advisor != null) {
      wards = widget.advisorStudents
          .map(
            (advisorStudent) => Ward(
              id: advisorStudent.id!,
              name: advisorStudent.name!,
              profilePicture: advisorStudent.profilePicture ?? '',
            ),
          )
          .toList();
    } else {
      wards = [];
    }

    var stateTodoList = state.todoParentListResponse.todoList;

    /// Filtering based on bottom sheet

    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    var list = Helper.getFilteredTodos(
      filterCheckboxHeadingList: widget.filterCheckboxHeadingList,
      stateTodoList: stateTodoList,
      byme: widget.byme,
      currentUserSfid: pendoState.accountId,
    );

    if (widget.searchText != '') {
      if (list != null) {
        list = list
            .where((todo) =>
                todo.task.name!.toLowerCase().contains(widget.searchText))
            .toList();
      } else {
        stateTodoList = stateTodoList.where((todo) {
          return todo.task.name!
              .toLowerCase()
              .contains(widget.searchText.toLowerCase());
        }).toList();
      }
    }

    if (list != null) stateTodoList = list;

    ///

    if (widget.sortDescending) {
      stateTodoList
          .sort((b, a) => a.task.completeBy.compareTo(b.task.completeBy));
    } else {
      stateTodoList
          .sort((a, b) => a.task.completeBy.compareTo(b.task.completeBy));
    }

    var todoLists = stateTodoList;
    List<Todo> openTodoList = [],
        completeTodoList = [],
        closedTodoList = [],
        requestTodoList = [],
        draftTodoList = [],
        bymeTabList = [];

    ///
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

    final selfSfid =
        BlocProvider.of<PendoMetaDataBloc>(context).state.accountId;
    bymeTabList = stateTodoList.where((todo) {
      return todo.task.listedBy.id == selfSfid;
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

    todoLists.forEach((element) {
      if (element.task.taskStatus == "Open") {
        element.isopen = true;
      } else if (element.task.taskStatus == "Completed") if (!element.isopen)
        element.iscomp = true;
      if (element.task.taskStatus == "Open")
        openTodoList.add(element);
      else if (element.task.taskStatus == "Completed")
        completeTodoList.add(element);
      else if (element.task.taskStatus == "Draft")
        draftTodoList.add(element);
      else
        closedTodoList.add(element);
    });
    return Expanded(
      child: TabBarView(
        controller: controller,
        children: [
          ParentAdvisorCreateNewTodoForm(
            todoList: openTodoList,
            wards: wards,
            controller: controller,
          ),
          if (hasDraft)
            ParentAdvisorTodoListView(
              todoList: draftTodoList,
              category: '',
              asignee: wards,
            ),
          if (hasRequests)
            ParentAdvisorTodoListView(
              todoList: requestTodoList,
              category: '',
              isRequestTab: true,
              asignee: wards,
            ),
          if (createdByMeListNotEmpty)
            ParentAdvisorTodoListView(
              isByMeTab: true,
              todoList: bymeTabList,
              category: '',
              asignee: wards,
            ),
          ParentAdvisorTodoListView(
            todoList: todoLists,
            category: '',
            asignee: wards,
          ),
          ParentAdvisorTodoListView(
            todoList: openTodoList,
            category: 'OPEN',
            asignee: wards,
          ),
          ParentAdvisorTodoListView(
            todoList: completeTodoList,
            category: 'COMPLETED',
            asignee: wards,
          ),
          ParentAdvisorTodoListView(
            todoList: closedTodoList,
            category: 'CLOSED',
            asignee: wards,
          ),
        ],
      ),
    );
  }
}
