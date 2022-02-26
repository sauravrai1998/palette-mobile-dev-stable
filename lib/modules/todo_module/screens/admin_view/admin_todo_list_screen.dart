import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/common_repos/common_pendo_repo.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/advisor_dashboard_module/bloc/student_list_bloc/advisor_student_bloc.dart';
import 'package:palette/modules/advisor_dashboard_module/bloc/student_list_bloc/advisor_student_states.dart';
import 'package:palette/modules/profile_module/bloc/profile_image_bloc/profile_image_bloc.dart';
import 'package:palette/modules/profile_module/models/user_models/abstract_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/admin_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/advisor_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/parent_profile_user_model.dart';
import 'package:palette/modules/profile_module/screens/profile_screens/admin_profile_screen.dart';
import 'package:palette/modules/profile_module/screens/profile_screens/advisor_profile_screen.dart';
import 'package:palette/modules/profile_module/screens/profile_screens/parent_profile_screen.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_bloc.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_state.dart';
import 'package:palette/modules/todo_module/bloc/todo_ad_bloc/todo_ad_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_filter_bloc/todo_filter_bloc.dart';
import 'package:palette/modules/todo_module/models/filter_models.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/screens/admin_view/admin_todo_list_view.dart';
import 'package:palette/modules/todo_module/screens/admin_view/admin_todo_tabview.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/modules/todo_module/widget/filter_button.dart';
import 'package:palette/modules/todo_module/widget/filter_clear_button.dart';
import 'package:palette/modules/todo_module/widget/filter_done_button.dart';
import 'package:palette/modules/todo_module/widget/circular_todo_button.dart';
import 'package:palette/modules/todo_module/widget/sort_todo_button.dart';
import 'package:palette/modules/todo_module/widget/todo_calendar_widget.dart';
import 'package:palette/modules/todo_module/widget/todo_list_action_widgets.dart';
import 'package:palette/modules/todo_module/widget/todo_list_header_month.dart';
import 'package:palette/utils/calendar_utils.dart';
import 'package:palette/utils/date_time_utils.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/todo_listItem.dart';

class AdminListTodoScreen extends StatefulWidget {
  final BaseProfileUserModel? adminModel;
  AdminListTodoScreen({
    Key? key,
    required this.adminModel,
  }) : super(key: key);

  @override
  _AdminListTodoScreenState createState() => _AdminListTodoScreenState();
}

class _AdminListTodoScreenState extends State<AdminListTodoScreen> {
  List<FilterCheckboxHeadingModel> filterCheckboxHeadingList = [];
  List<String> listedByNames = [];
  var filterOptionsAssigned = false;
  var isFilterOn = false;
  List<Todo> stateTodoList = [];
  var sortDescending = false;
  String? sfid;
  String? sfuuid;
  String? role;
  bool _searchSelected = false;
  FocusNode _searchFocusNode = FocusNode();
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  bool byme = false;

  /// Calender View
  List<Todo> calendarTodoList = [];
  List<Todo> filtersAppliedCalendarTodoList = [];
  bool _isCalendarViewSelected = false;
  late PageController _calendarPageController;
  DateTime _focusedDay = DateTime.now();
  bool _isMonthAndYearViewSelected = false;
  late LinkedHashMap<DateTime, List<Todo>> kEvents;
  final ScrollController sliverscrollController = ScrollController();
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  CalendarFormat calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();

    /// Calendar View empty list fix
    final state = BlocProvider.of<TodoAdminBloc>(context).state;
    if (state is FetchTodoAdminSuccessState) {
      stateTodoList = state.todoAdminListResponse.todoList;
      print('filled');
    }

    /// Calendar View empty list fix

    print('init in todo admin');
    _getSfidAndRole();
  }

  onSearchTextChangedInCalendarView(String value) {
    setState(() {
      filtersAppliedCalendarTodoList = calendarTodoList
          .where((todo) => todo.task.name!
              .toLowerCase()
              .contains(value.toLowerCase().trim()))
          .toList()
          .where((element) =>
              DateTimeUtils.isSameDate(element.task.completeBy, _focusedDay))
          .toList();
    });
  }

  onSearchTextChanged(String value) {
    setState(() {
      _searchText = value.trim();
    });
  }

  List<Todo> _getEventsForDay(DateTime day) {
    loadCalendarIndicators();
    return kEvents[day] ?? [];
  }

  void loadCalendarIndicators() {
    final Map<DateTime, List<Todo>> mpp = {};
    calendarTodoList.forEach((eachTodo) {
      List<Todo> tempList = [];
      tempList = calendarTodoList
          .where((val) => val.task.completeBy == eachTodo.task.completeBy)
          .toList();
      mpp[eachTodo.task.completeBy] = tempList;
    });
    kEvents = LinkedHashMap<DateTime, List<Todo>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(mpp);
  }

  _getSfidAndRole() async {
    final prefs = await SharedPreferences.getInstance();
    sfid = prefs.getString(sfidConstant);
    sfuuid = prefs.getString(saleforceUUIDConstant);
    role = prefs.getString('role').toString();
  }

  var trackParentAdvisorScreen = false;
  @override
  Widget build(BuildContext context) {
    if (trackParentAdvisorScreen == false) {
      CommonPendoRepo.trackTodoListScreenVisit(context: context);
      trackParentAdvisorScreen = true;
    }
    return BlocListener(
      listener: (context, adminTodoState) {
        if (adminTodoState is FetchTodoAdminSuccessState) {
          // isFilterOn = false;

          stateTodoList = adminTodoState.todoAdminListResponse.todoList;
            calendarTodoList = adminTodoState.todoAdminListResponse.todoList;
            filtersAppliedCalendarTodoList = calendarTodoList
                .where((element) => (DateTimeUtils.isSameDate(
                    _focusedDay, element.task.completeBy)))
                .toList();

        }
      },
      bloc: context.read<TodoAdminBloc>(),
      child: BlocBuilder<TodoFilterBloc, TodoFilterState>(
          builder: (context, todoFilterState) {
        if (todoFilterState is TodoFilterListState) {
          isFilterOn = todoFilterState.isFilterOn;
          filterCheckboxHeadingList = todoFilterState.filterCheckboxHeadingList;
        }
        return SafeArea(
          child: Semantics(
            label:
                "Welcome to your dashboard! you can keep track of your tasks using this todo module",
            child: Scaffold(
              body: Stack(children: [
                Scaffold(
                  appBar: PreferredSize(
                    preferredSize: _searchSelected
                        ? Size.fromHeight(0)
                        : Size.fromHeight(80),
                    child: !_searchSelected
                        ? AppBar(
                            automaticallyImplyLeading: false,
                            backgroundColor: _isCalendarViewSelected
                                ? kLightGrayColor
                                : Colors.transparent,
                            elevation: 0,
                            centerTitle: false,
                            title: _isCalendarViewSelected
                                ? TodoListHeaderMonth(
                                    onPreviousIconTap: () {
                                      _calendarPageController.previousPage(
                                          duration: Duration(
                                            seconds: 1,
                                          ),
                                          curve: Curves.easeInOut);
                                    },
                                    title: kMonthsList[_focusedDay.month - 1] +
                                        " " +
                                        _focusedDay.year.toString(),
                                    onNextTap: () {
                                      _calendarPageController.nextPage(
                                          duration: Duration(
                                            seconds: 1,
                                          ),
                                          curve: Curves.easeInOut);
                                    },
                                    onTitleTap: () {
                                      setState(() {
                                        _isMonthAndYearViewSelected =
                                            !_isMonthAndYearViewSelected;
                                        calendarFormat = CalendarFormat.week;
                                      });
                                    })
                                : Text(
                                    'To-do',
                                    style: TextStyle(
                                      fontFamily: 'MontserratBold',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: defaultDark,
                                    ),
                                  ),
                            actions: [
                              TodoListActionWidget(
                                notificationCount: 0,
                                onCounterCallBack: (counter) {
                                  // setState(() {
                                  //   unreadNotifCounter = counter;
                                  // });
                                },
                                onNotificationFetchSuccess: (state) {
                                  // state.notificationList.modelList!
                                  //     .forEach((element) {
                                  //   if (!element.isRead) {
                                  //     unreadNotifCounter++;
                                  //   }
                                  // });
                                  // setState(() {});
                                  // print(unreadNotifCounter);
                                },
                                onMenuIconPressed: () {
                                  setState(() {
                                    _isCalendarViewSelected = false;
                                  });
                                },
                                onSearchPressed: () {
                                  setState(() {
                                    _searchSelected = true;
                                  });
                                  _searchFocusNode.requestFocus();
                                },
                                onCalendarIconPressed: () {
                                  setState(() {
                                    _isCalendarViewSelected = true;
                                  });
                                  stateTodoList.isNotEmpty
                                      ? setState(() {
                                          calendarTodoList = stateTodoList;
                                          _isCalendarViewSelected = true;
                                          _focusedDay = DateTime.now();
                                        })
                                      : Helper.showToast("Loading Todos...");
                                },
                                isCalendarViewSelected: _isCalendarViewSelected,
                                isSearchSelected: _searchSelected,
                                searchFocusNode: _searchFocusNode,
                              ),
                              _isCalendarViewSelected
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          right: 20, top: 10, bottom: 10),
                                      child: Row(
                                        children: [
                                          CircularTodoSearchButton(
                                            onTap: () {
                                              _searchFocusNode.requestFocus();
                                              setState(() {
                                                _searchSelected = true;
                                              });
                                            },
                                            icon: Icons.search,
                                          ),
                                        ],
                                      ),
                                    )
                            ],
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                  ),
                  body: Builder(builder: (context) {
                    if (_isCalendarViewSelected) {
                      return calendarView();
                    } else {
                      return taskListView(
                        todoFilterState: todoFilterState,
                      );
                    }
                  }),
                ),
                // widget.isFromAdvisorDashboard
                //     ? Container()
                //     :
                Visibility(
                  visible: !_searchSelected,
                  child: GestureDetector(
                    onTap: () {
                      print('tapp profilee');
                      final parentOrAdvisor = widget.adminModel;
                      if (parentOrAdvisor is ParentProfileUserModel) {
                        final route = MaterialPageRoute(
                            builder: (_) =>
                                ParentProfileScreen(parent: parentOrAdvisor));
                        Navigator.push(context, route);
                      } else if (parentOrAdvisor is AdvisorProfileUserModel) {
                        final route = MaterialPageRoute(
                            builder: (_) =>
                                AdvisorProfileScreen(advisor: parentOrAdvisor));
                        Navigator.push(context, route);
                      } else if (parentOrAdvisor is AdminProfileUserModel) {
                        final route = MaterialPageRoute(
                            builder: (_) =>
                                AdminProfileScreen(admin: parentOrAdvisor));
                        Navigator.push(context, route);
                      }
                    },
                    child: _isCalendarViewSelected
                        ? Container()
                        : Container(
                            // child:
                            // Stack(children: [
                            //   Builder(builder: (context) {
                            //     if (widget.adminModel
                            //         is ParentProfileUserModel) {
                            //       return SvgPicture.asset(
                            //         'images/parent_small_splash.svg',
                            //         height: 92,
                            //         semanticsLabel: "Profile Picture.",
                            //       );
                            //     } else {
                            //       return SvgPicture.asset(
                            //         'images/advisor_small_splash.svg',
                            //         height: 92,
                            //         semanticsLabel: "Profile Picture.",
                            //       );
                            //     }
                            //   }),
                            //   BlocBuilder<ProfileImageBloc, ProfileImageState>(
                            //       builder: (context, state) {
                            //     String? profilePictureUrl;
                            //     final parentOrAdvisor = widget.adminModel;
                            //     if (state is ProfileImageSuccessState) {
                            //       profilePictureUrl = state.url;
                            //     } else if (state is ProfileImageDeleteState) {
                            //       return Container();
                            //     } else {
                            //       if (parentOrAdvisor
                            //           is ParentProfileUserModel) {
                            //         profilePictureUrl =
                            //             parentOrAdvisor.profilePicture;
                            //       } else if (parentOrAdvisor
                            //           is AdvisorProfileUserModel) {
                            //         profilePictureUrl =
                            //             parentOrAdvisor.profilePicture;
                            //       } else if (parentOrAdvisor
                            //           is AdminProfileUserModel) {
                            //         profilePictureUrl =
                            //             parentOrAdvisor.profilePicture;
                            //       }
                            //     }

                            //     return Padding(
                            //       padding: const EdgeInsets.only(
                            //           top: 15, left: 11.5),
                            //       child: CachedNetworkImage(
                            //         imageUrl: profilePictureUrl ?? '',
                            //         imageBuilder: (context, imageProvider) =>
                            //             Container(
                            //           width: 42,
                            //           height: 42,
                            //           decoration: BoxDecoration(
                            //             color: Colors.white,
                            //             shape: BoxShape.circle,
                            //             image: DecorationImage(
                            //                 image: imageProvider,
                            //                 fit: BoxFit.cover),
                            //           ),
                            //         ),
                            //         placeholder: (context, url) => CircleAvatar(
                            //             radius:
                            //                 // widget.screenHeight <= 736 ? 35 :
                            //                 29,
                            //             backgroundColor: Colors.white,
                            //             child: CircularProgressIndicator()),
                            //         errorWidget: (context, url, error) =>
                            //             Container(),
                            //       ),
                            //     );
                            //   }),
                            // ]),
                            ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: Align(
                //     alignment: Alignment.topRight,
                //     child: _filterButton(),
                //   ),
                // ),
              ]),
            ),
          ),
        );
      }),
    );
  }

  double _getExpandedHeight() {
    if (_isMonthAndYearViewSelected) {
      if (_searchSelected) {
        return 150;
      } else {
        return 130;
      }
    } else {
      if (calendarFormat == CalendarFormat.month) {
        if (_searchSelected) {
          return 390;
        } else {
          return 340;
        }
      } else {
        if (_searchSelected) {
          return 180;
        }
        return 130;
      }
    }
  }

  Widget calendarView() {
    return NestedScrollView(
      controller: sliverscrollController,
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, isInnerScrolled) {
        return [
          SliverOverlapAbsorber(
              sliver: SliverLayoutBuilder(builder: (context, constraints) {
                final scrollHeight = constraints.scrollOffset;
                // log("Scroll Height is:$scrollHeight");
                return SliverAppBar(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                  floating: true,
                  forceElevated: isInnerScrolled,
                  snap: true,
                  pinned: true,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(
                        !_isMonthAndYearViewSelected ? 50 : 180),
                    child: (calendarFormat == CalendarFormat.week
                            ? (scrollHeight <= 99)
                            : !(scrollHeight > 290))
                        ? SizedBox()
                        : Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () {
                                sliverscrollController.animateTo(0,
                                    duration: Duration(milliseconds: 800),
                                    curve: Curves.linear);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 8, 12, 8),
                                child: Text(
                                  _focusedDay.day.toString() +
                                      " " +
                                      kMonthsList[_focusedDay.month - 1] +
                                      " " +
                                      _focusedDay.year.toString(),
                                  style: kalamLight.copyWith(
                                      fontFamily: "MontserratReg",
                                      color: white,
                                      fontSize: 22),
                                ),
                              ),
                            ),
                          ),
                  ),
                  expandedHeight: _getExpandedHeight(),
                  flexibleSpace: FlexibleSpaceBar(
                    background: TodoCalendarWidget(
                      calendarFormat: calendarFormat,
                      eventLoader: _getEventsForDay,
                      focusedDay: _focusedDay,
                      isMonthAndYearViewSelected: _isMonthAndYearViewSelected,
                      onCalendarCreated: (PageController controller) {
                        _calendarPageController = controller;
                      },
                      onDaySelected: (datetime, dat) {
                        setState(() {
                          _focusedDay = datetime;
                          // log("Selected Dates are:${calendarTodoList.where((element) => (DateTimeUtils.isSameDate(datetime, element.task.completeBy))).toList().map((e) => e.task.completeBy).toList()}");
                          filtersAppliedCalendarTodoList = calendarTodoList
                              .where((element) => (DateTimeUtils.isSameDate(
                                  datetime, element.task.completeBy)))
                              .toList();
                        });
                        print(
                          'now the calendar list is: $filtersAppliedCalendarTodoList',
                        );
                      },
                      rangeSelectionMode: _rangeSelectionMode,
                      updateCalendarFormat: (CalendarFormat format) {
                        setState(() {
                          calendarFormat = format;
                        });
                      },
                      updateFocusedDate: (DateTime dateTime) {
                        setState(() {
                          _focusedDay = dateTime;
                        });
                      },
                      updateIsMonthAndYearViewSelected: (bool value) {
                        setState(() {
                          _isMonthAndYearViewSelected = value;
                        });
                      },
                    ),
                  ),
                  backgroundColor: kLightGrayColor,
                  elevation: 0,
                  centerTitle: false,
                  title: _searchSelected
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                _searchFocusNode.unfocus();
                                setState(() {
                                  _searchText = '';
                                  _searchController.clear();
                                  _searchSelected = false;
                                });
                              },
                              icon: Container(
                                height: 20,
                                width: 24,
                                margin: EdgeInsets.only(bottom: 2),
                                child: SvgPicture.asset(
                                  'images/left_arrow.svg',
                                  color: _isCalendarViewSelected
                                      ? defaultLight
                                      : kDarkGrayColor,
                                  semanticsLabel: "Back",
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 35,
                                margin: EdgeInsets.only(top: 2),
                                child: TextField(
                                  controller: _searchController,
                                  cursorColor: Colors.blueGrey,
                                  autocorrect: false,
                                  style: TextStyle(
                                      fontFamily: "MonsterratReg",
                                      color: _isCalendarViewSelected
                                          ? Colors.white
                                          : Colors.black),
                                  focusNode: _searchFocusNode,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search...',
                                      hintStyle: TextStyle(
                                          fontFamily: "MonsterratReg",
                                          color: _isCalendarViewSelected
                                              ? Colors.white
                                              : Colors.black)),
                                  onChanged: _isCalendarViewSelected
                                      ? onSearchTextChangedInCalendarView
                                      : onSearchTextChanged,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          _searchSelected || _isCalendarViewSelected
                              ? ''
                              : 'To-Do',
                          style: TextStyle(
                            fontFamily: 'MontserratBold',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: defaultDark,
                          ),
                        ),
                );
              }),
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
        ];
      },
      body: BlocListener(
        listener: (context, state) {
          if (state is FetchTodoAdminSuccessState) {
            print('FetchTodoAdminSuccessState: ${FetchTodoAdminSuccessState}');
            //
          }
        },
        bloc: context.read<TodoAdminBloc>(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(),
            BlocBuilder<TodoAdminBloc, TodoAdminState>(
              builder: (context, state) {
                // log("State of TodoListBloc is:$state and list length would be is:${state is TodoListSuccessState ? ((state).todoListResponse.todoList.length) : "0"}");
                if (state is FetchTodoAdminErrorState) {
                  return SliverFillRemaining(
                      child: Center(child: Text(state.err)));
                } else if (state is FetchTodoAdminLoadingState) {
                  return SliverFillRemaining(
                    child: Center(
                      child: CustomPaletteLoader(),
                    ),
                  );
                } else if (state is FetchTodoAdminSuccessState) {
                  // log("Entered Sliver Layout Builder");

                  if (calendarTodoList.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                          child: Text(
                        'NO TASKS',
                        style: montserratBoldTextStyle,
                      )),
                    );
                  } else {
                    return AdminTodoListView(
                      todoList: filtersAppliedCalendarTodoList,
                      category: '',
                      useSliver: true,
                      asignee: [],
                    );
                  }
                } else {
                  return SliverFillRemaining(
                      child: Center(
                    child: Text(
                      "Loading...",
                      style: montserratBoldTextStyle,
                    ),
                  ));
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget taskListView({
    required TodoFilterState todoFilterState,
  }) {
    return TextScaleFactorClamper(
      child:
          BlocBuilder<TodoAdminBloc, TodoAdminState>(builder: (context, state) {
        if (state is FetchTodoAdminLoadingState) {
          return _getLoadingIndicator();
        } else if (state is FetchTodoAdminSuccessState) {
          return Column(
            children: [
              if (_searchSelected)
                AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _searchFocusNode.unfocus();
                          setState(() {
                            _searchText = '';
                            _searchController.clear();
                            _searchSelected = false;
                          });
                        },
                        child: Container(
                          height: 18,
                          width: 30,
                          child: SvgPicture.asset(
                            'images/left_arrow.svg',
                            semanticsLabel: "Back",
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 35,
                          margin: EdgeInsets.only(top: 2),
                          child: TextField(
                            controller: _searchController,
                            cursorColor: Colors.blueGrey,
                            autocorrect: false,
                            focusNode: _searchFocusNode,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search...',
                            ),
                            onChanged: onSearchTextChanged,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, bottom: 8, right: 12),
                child: _filterButton(todoFilterState: todoFilterState),
              ),
              Expanded(
                child: AdminTodoListTabView(
                  searchText: _searchText,
                  sortDescending: sortDescending,
                  byme: byme,
                  filterCheckboxHeadingList: filterCheckboxHeadingList,
                  adminModel: widget.adminModel!,
                ),
              ),
            ],
          );
        } else if (state is FetchTodoAdminErrorState) {
          return Center(child: Text(state.err));
        }
        return Container();
      }),
    );
  }

  Widget _filterButton({required TodoFilterState todoFilterState}) {
    return BlocListener(
      bloc: context.read<TodoParentAdvisorBloc>(),
      listener: (context, state) {},
      child: BlocBuilder<TodoParentAdvisorBloc, TodoParentState>(
        builder: (context, state) {
          print('success state in admin builder');
          if (state is FetchTodoParentSuccessState &&
              isTodoListLoadedFirstTimeForParent) {
            if (todoFilterState is TodoFilterListState &&
                todoFilterState.filterCheckboxHeadingList.isNotEmpty) {
              filterCheckboxHeadingList =
                  todoFilterState.filterCheckboxHeadingList;
            } else {
              filterCheckboxHeadingList =
                  getFilterCheckboxHeadingListForParentAndAdvisor();
            }

            BlocProvider.of<TodoFilterBloc>(context).add(TodoFilterListEvent(
              isFilterOn: isFilterOn,
              filterCheckboxHeadingList: filterCheckboxHeadingList,
              byme: byme,
            ));
            isTodoListLoadedFirstTimeForParent = false;
            stateTodoList = state.todoParentListResponse.todoList;
          }
          return IgnorePointer(
            ignoring: state is FetchTodoParentLoadingState ||
                state is FetchTodoParentErrorState,
            child: Row(
              mainAxisAlignment: _searchSelected
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(10),
                  child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                      builder: (context, pendoState) {
                    return InkWell(
                      onTap: () {
                        byme = !byme;
                        TodoPendoRepo.trackTodoByMeEvent(
                            isByme: byme, pendoState: pendoState);
                        context.read<TodoFilterBloc>().add(TodoFilterListEvent(
                              isFilterOn: isFilterOn,
                              filterCheckboxHeadingList:
                                  filterCheckboxHeadingList,
                              byme: byme,
                            ));
                      },
                      child: TextScaleFactorClamper(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          //width: 100,
                          decoration: BoxDecoration(
                              color: byme ? pinkRed : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 5,
                                  offset: Offset(0, 1),
                                ),
                              ]),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "By me",
                                style: montserratBoldTextStyle.copyWith(
                                  color: byme ? Colors.white : pinkRed,
                                  fontSize: 14,
                                ),
                                semanticsLabel: byme
                                    ? "Remove filter"
                                    : "Filter to only show tasks created by you",
                              ),
                              if (byme)
                                SvgPicture.asset(
                                  "images/crossicon.svg",
                                  color: Colors.white,
                                  height: 14,
                                  width: 14,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(width: 12),
                BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                    builder: (context, pendoState) {
                  return GestureDetector(
                    onTap: () {
                      ///...
                      setState(() {
                        sortDescending = !sortDescending;
                      });
                      TodoPendoRepo.trackTodoSortingEvent(
                          isDescending: sortDescending, pendoState: pendoState);
                    },
                    child: SortTodoButton(
                        iconColor: sortDescending ? white : pinkRed,
                        backgroundColor: sortDescending ? pinkRed : white),
                  );
                }),
                SizedBox(width: 12),
                GestureDetector(
                    onTap: _filterButtonOnTap,
                    child: isFilterOn
                        ? FilterButton(
                            iconBackgroundColor: pinkRed,
                            iconColor: white,
                          )
                        : FilterButton(
                            iconColor: pinkRed,
                            iconBackgroundColor: white,
                          )),
              ],
            ),
          );
        },
      ),
    );
  }

  void _filterButtonOnTap() {
    Widget _listView(StateSetter stateSetter) {
      return ListView.builder(
        itemCount: filterCheckboxHeadingList.length,
        itemBuilder: (context, index) {
          if (filterCheckboxHeadingList[index].title.name.toLowerCase() ==
                  'other' ||
              filterCheckboxHeadingList[index].title.name.toLowerCase() ==
                  'education' ||
              filterCheckboxHeadingList[index].title.name.toLowerCase() ==
                  'employment') {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: CheckboxListTile(
                checkColor: Colors.white,
                activeColor: defaultDark,
                value: filterCheckboxHeadingList[index].isCheck,
                onChanged: (value) {
                  if (value == null) return;
                  stateSetter(() {
                    filterCheckboxHeadingList[index].isCheck = value;
                    if (filterCheckboxHeadingList[index].subCategories != null)
                      filterCheckboxHeadingList[index]
                          .subCategories!
                          .forEach((e) {
                        e.isCheck = value;
                      });
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(filterCheckboxHeadingList[index].title.name,
                    style: robotoTextStyle.copyWith(fontSize: 16)),
              ),
            );
          }
          return ExpansionTile(
            title: CheckboxListTile(
              checkColor: Colors.white,
              activeColor: defaultDark,
              value: filterCheckboxHeadingList[index].isCheck,
              onChanged: (value) {
                if (value == null) return;
                stateSetter(() {
                  filterCheckboxHeadingList[index].isCheck = value;
                  if (filterCheckboxHeadingList[index].subCategories != null)
                    filterCheckboxHeadingList[index]
                        .subCategories!
                        .forEach((e) {
                      e.isCheck = value;
                    });
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(filterCheckboxHeadingList[index].title.name,
                  style: robotoTextStyle.copyWith(fontSize: 16)),
            ),
            children: filterCheckboxHeadingList[index].subCategories == null
                ? []
                : filterCheckboxHeadingList[index].subCategories!.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: CheckboxListTile(
                        checkColor: Colors.white,
                        activeColor: defaultDark,
                        value: e.isCheck,
                        onChanged: (value) {
                          stateSetter(() {
                            if (value == false) {
                              filterCheckboxHeadingList[index].isCheck = false;
                            }
                            e.isCheck = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(e.title,
                            style: robotoTextStyle.copyWith(fontSize: 16)),
                      ),
                    );
                  }).toList(),
          );
        },
      );
    }

    final devHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return TextScaleFactorClamper(
            child: Container(
              height: devHeight * 0.55,
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter stateSetter) {
                  return Container(
                    height: devHeight / 2,
                    padding: const EdgeInsets.fromLTRB(0, 20, 12, 12),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 4,
                          child: _listView(stateSetter),
                        ),
                        Expanded(
                          flex: 1,
                          child: BlocBuilder<PendoMetaDataBloc,
                                  PendoMetaDataState>(
                              builder: (context, pendoState) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    TodoPendoRepo.trackFilterClearEvent(
                                        pendoState: pendoState);
                                    Navigator.pop(context);
                                    setState(() {
                                      filterCheckboxHeadingList =
                                          getFilterCheckboxHeadingListForParentAndAdvisor();
                                      isFilterOn = false;
                                    });
                                    context
                                        .read<TodoFilterBloc>()
                                        .add(TodoFilterListEvent(
                                          isFilterOn: isFilterOn,
                                          filterCheckboxHeadingList:
                                              filterCheckboxHeadingList,
                                          byme: byme,
                                        ));
                                  },
                                  child: FilterClearButton(),
                                ),
                                SizedBox(width: 60),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    if (Helper.getFilteredTodos(
                                            filterCheckboxHeadingList:
                                                filterCheckboxHeadingList,
                                            stateTodoList: stateTodoList) !=
                                        null) {
                                      isFilterOn = true;
                                    } else {
                                      isFilterOn = false;
                                    }
                                    TodoPendoRepo.trackFilterDoneEvent(
                                        pendoState: pendoState);
                                    setState(() {});
                                    context
                                        .read<TodoFilterBloc>()
                                        .add(TodoFilterListEvent(
                                          isFilterOn: isFilterOn,
                                          filterCheckboxHeadingList:
                                              filterCheckboxHeadingList,
                                          byme: byme,
                                        ));
                                  },
                                  child: FilterDoneButton(),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  Widget _getLoadingIndicator() {
    return Center(
      child: Container(height: 38, width: 50, child: CustomPaletteLoader()),
    );
  }
}
