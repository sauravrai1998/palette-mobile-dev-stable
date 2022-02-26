import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/advisor_dashboard_module/models/advisor_student_model.dart';
import 'package:palette/modules/profile_module/models/user_models/abstract_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/Admin_profile_user_model.dart';
import 'package:palette/modules/todo_module/bloc/hide_bottom_navbar_bloc/hide_bottom_navbar_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_ad_bloc/todo_ad_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_state.dart';
import 'package:palette/modules/todo_module/models/filter_models.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/ward.dart';
import 'package:palette/modules/todo_module/screens/admin_view/admin_create_todo.dart';
import 'package:palette/modules/todo_module/screens/admin_view/admin_todo_list_view.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/utils/helpers.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminTodoListTabView extends StatefulWidget {
  // final int selectedIndex;
  final int selectedIndex;
  final bool byme;
  final String searchText;
  // final String studentId;
  final BaseProfileUserModel? adminModel;
  final List<AdvisorStudent> advisorStudents;
  final bool sortDescending;
  final List<FilterCheckboxHeadingModel> filterCheckboxHeadingList;

  AdminTodoListTabView({
    required this.searchText,
    required this.adminModel,
    this.byme = false,
    this.sortDescending = false,
    this.selectedIndex = 2,
    this.advisorStudents = const [],
    this.filterCheckboxHeadingList = const [],
  });
  @override
  _AdminTodoListTabViewState createState() => _AdminTodoListTabViewState();
}

class _AdminTodoListTabViewState extends State<AdminTodoListTabView>
    with TickerProviderStateMixin {
  var controller;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? role;
  String? sfid;
  String? sfuuid;
  bool hasRequests = false;
  bool createdByMeListNotEmpty = false;
  bool hasDraft = false;

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
    final state = BlocProvider.of<TodoAdminBloc>(context).state;
    if (state is FetchTodoAdminSuccessState) {
      final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
      final selfSfid = pendoState.accountId;
      final bymeTabList = state.todoAdminListResponse.todoList.where((todo) {
        return todo.task.listedBy.id == selfSfid;
      }).toList();

      var reqList = state.todoAdminListResponse.todoList.where((todo) {
        return todo.task.acceptedStatus == "Requested";
      }).toList();

      var draftList = state.todoAdminListResponse.todoList.where((todo) {
        return todo.task.taskStatus == "Draft";
      }).toList();

      var length = 5;
      var initialIndex = 2;

      if (reqList.isNotEmpty) {
        length = length + 1;
        initialIndex = initialIndex + 1;
        hasRequests = true;
      }

      if (bymeTabList.isNotEmpty) {
        length = length + 1;
        initialIndex = initialIndex + 1;
        createdByMeListNotEmpty = true;
      }

      if (draftList.isNotEmpty) {
        length = length + 1;
        initialIndex = initialIndex + 1;
        hasDraft = true;
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
      //TODO: implement refresh logic

      final bloc = context.read<TodoAdminBloc>();
      bloc.add(FetchTodosAdminEvent());
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

    return BlocListener(
      listener: (context, state) {
        context.read<TodoAdminBloc>().add(FetchTodosAdminEvent());
        if (state is UpdateTodoStatusSuccessState) {
          print('herere');
          context.read<TodoAdminBloc>().add(FetchTodosAdminEvent());
        } else if (state is UpdateTodoStatusErrorState) {
          print('herere err');
          Helper.showToast(state.err);
        }
      },
      bloc: context.read<TodoBloc>(),
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(
          waterDropColor: defaultDark,
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: TextScaleFactorClamper(
          child: BlocListener(
            bloc: context.read<TodoAdminBloc>(),
            listener: (context, state) {
              if (state is FetchTodoAdminSuccessState) {
                final pendoState =
                    BlocProvider.of<PendoMetaDataBloc>(context).state;

                final bymeTabList =
                    state.todoAdminListResponse.todoList.where((todo) {
                  return todo.task.listedBy.id == pendoState.accountId;
                }).toList();

                var reqList =
                    state.todoAdminListResponse.todoList.where((todo) {
                  return todo.task.acceptedStatus == "Requested";
                }).toList();

                var draftList =
                    state.todoAdminListResponse.todoList.where((todo) {
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
            child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                builder: (context, pendoState) {
              return Column(
                children: [
                  TabBar(
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
                    unselectedLabelStyle:
                        montserratNormal.copyWith(fontSize: 15),
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
                  BlocBuilder<TodoAdminBloc, TodoAdminState>(
                    builder: (context, state) {
                      if (state is FetchTodoAdminLoadingState) {
                        return Center(
                          child: Container(
                              height: 38,
                              width: 50,
                              child: CustomPaletteLoader()),
                        );
                      }

                      if (state is FetchTodoAdminSuccessState) {
                        return _getTabBarView(state: state);
                      }

                      if (state is FetchTodoAdminErrorState) {
                        return Center(child: Text(state.err));
                      }

                      return SizedBox();
                    },
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _getTabBarView({required FetchTodoAdminSuccessState state}) {
    AdminProfileUserModel? admin;

    if (widget.adminModel is AdminProfileUserModel) {
      admin = widget.adminModel as AdminProfileUserModel;
    }

    List<Ward> wards = [];

    if (admin != null) {
      // TODO: Handle this case.
      // wards = admin.wards
      //     .map((pupil) => Ward(
      //         id: pupil.id,
      //         name: pupil.name,
      //         profilePicture: pupil.profilePicture ?? ''))
      //     .toList();
    }
    //else if (advisor != null) {
    //   wards = widget.advisorStudents
    //       .map(
    //         (advisorStudent) => Ward(
    //           id: advisorStudent.id!,
    //           name: advisorStudent.name!,
    //           profilePicture: advisorStudent.profilePicture ?? '',
    //         ),
    //       )
    //       .toList();
    // }
    else {
      wards = [];
    }

    var stateTodoList = state.todoAdminListResponse.todoList;

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
            .where((todo) => todo.task.name!
                .toLowerCase()
                .contains(widget.searchText.toLowerCase()))
            .toList();
      } else {
        stateTodoList = stateTodoList
            .where((todo) => todo.task.name!
                .toLowerCase()
                .contains(widget.searchText.toLowerCase()))
                
            .toList();
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
      else
        closedTodoList.add(element);
    });

    return Expanded(
      child: TabBarView(
        controller: controller,
        children: [
          AdminCreateNewTodoForm(
            todoList: openTodoList,
            wards: wards,
            controller: controller,
          ),
          if (hasDraft)
            AdminTodoListView(
              todoList: draftTodoList,
              category: '',
              asignee: wards,
            ),
          if (hasRequests)
            AdminTodoListView(
              isRequestTab: true,
              todoList: requestTodoList,
              category: '',
              asignee: wards,
            ),
          if (createdByMeListNotEmpty)
            AdminTodoListView(
              isByMeTab: true,
              todoList: bymeTabList,
              category: '',
              asignee: wards,
            ),
          AdminTodoListView(
            todoList: todoLists,
            category: '',
            asignee: wards,
          ),
          AdminTodoListView(
            todoList: openTodoList,
            category: 'OPEN',
            asignee: wards,
          ),
          AdminTodoListView(
            todoList: completeTodoList,
            category: 'COMPLETED',
            asignee: wards,
          ),
          AdminTodoListView(
            todoList: closedTodoList,
            category: 'CLOSED',
            asignee: wards,
          ),
        ],
      ),
    );
  }
}
