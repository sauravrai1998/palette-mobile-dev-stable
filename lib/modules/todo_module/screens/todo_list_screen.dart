import 'dart:collection';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/common_repos/common_pendo_repo.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/auth_module/services/notification_repository.dart';
import 'package:palette/modules/notifications_module/bloc/notifications_bloc.dart';
import 'package:palette/modules/notifications_module/services/notifications_repo.dart';
import 'package:palette/modules/profile_module/models/user_models/student_profile_user_model.dart';
import 'package:palette/modules/profile_module/screens/profile_screens/student_profile_screen.dart';
import 'package:palette/modules/todo_module/bloc/todo_accept_reject_bloc/todo_accept_reject_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_accept_reject_bulk_bloc.dart/todo_accept_reject_bulk_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_bulk_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_filter_bloc/todo_filter_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_state.dart';
import 'package:palette/modules/todo_module/models/filter_models.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/modules/todo_module/services/todo_repo.dart';
import 'package:palette/modules/todo_module/widget/filter_button.dart';
import 'package:palette/modules/todo_module/widget/filter_clear_button.dart';
import 'package:palette/modules/todo_module/widget/filter_done_button.dart';
import 'package:palette/modules/todo_module/widget/circular_todo_button.dart';
import 'package:palette/modules/todo_module/widget/filter_widget.dart';
import 'package:palette/modules/todo_module/widget/sort_todo_button.dart';
import 'package:palette/modules/todo_module/widget/todo_bulk_edit_select_options.dart';
import 'package:palette/modules/todo_module/widget/todo_calendar_widget.dart';
import 'package:palette/modules/todo_module/widget/todo_list_action_widgets.dart';
import 'package:palette/modules/todo_module/widget/todo_list_header_month.dart';
import 'package:palette/modules/todo_module/widget/todo_list_view.dart';
import 'package:palette/utils/calendar_utils.dart';
import 'package:palette/utils/date_time_utils.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widget/todo_list_tab_view.dart';

class TodoListScreen extends StatefulWidget {
  final StudentProfileUserModel? student;
  final bool thirdPerson;
  final bool isObserverAdmin;
  final String studentId;
  TodoListScreen({
    Key? key,
    required this.student,
    this.thirdPerson = false,
    this.studentId = '',
    this.isObserverAdmin = false,
  }) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

var badgeCounter = 0;

class _TodoListScreenState extends State<TodoListScreen>
    with TickerProviderStateMixin {
  //?Add All Controllers to top
  final ScrollController sliverscrollController = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<FilterCheckboxHeadingModel> filterCheckboxHeadingList = [];
  int unreadNotifCounter = 0;

  bool _inSelectMode = false;
  bool _expandedFAB = false;

  _checkIfWeWereInSelectMode() {
    final selectedList =
        filtersAppliedCalendarTodoList.where((element) => element.isSelected);
    if (selectedList.isNotEmpty) {
      _inSelectMode = true;
    }
  }

  bool byme = false;
  bool sortDescending = false;
  List<String> listedByNames = [];
  List<Todo> stateTodoList = [];
  List<Todo> calendarTodoList = [];
  List<Todo> filtersAppliedCalendarTodoList = [];
  var isFilterOn = false;
  String? sfid;
  String? sfuuid;
  String? role;
  bool _searchSelected = false;
  bool _isCalendarViewSelected = false;
  bool _isMonthAndYearViewSelected = false;
  FocusNode _searchFocusNode = FocusNode();
  TextEditingController _searchController = TextEditingController();
  String searchText = '';
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  late LinkedHashMap<DateTime, List<Todo>> kEvents;
  late PageController _calendarPageController;

  @override
  void initState() {
    super.initState(); 
    _getSfidAndRole();

    filterCheckboxHeadingList.clear();

    final state = BlocProvider.of<TodoListBloc>(context).state;
    if (state is TodoListSuccessState) {
      stateTodoList = state.todoListResponse.todoList;
      String studentName = widget.student?.name ?? '';
      listedByNames = state.todoListResponse.allListedByInOneList
          .map((e) => e.name)
          .toList();
      listedByNames.remove(studentName);
      print('isTodoListLoadedFirstTime: $isTodoListLoadedFirstTime');
      if (isTodoListLoadedFirstTime) {
        filterCheckboxHeadingList =
            getFilterCheckboxHeadingList(listedByNames: listedByNames);
        isTodoListLoadedFirstTime = false;
        isFilterOn = false;
      }

      BlocProvider.of<TodoFilterBlocStudent>(context)
          .add(TodoFilterListEventStudent(
        isFilterOn: isFilterOn,
        filterCheckboxHeadingList: filterCheckboxHeadingList,
        byme: byme,
      ));
    }
    _checkIfWeWereInSelectMode();
  }

  @override
  void dispose() {
    super.dispose();
    isTodoListLoadedFirstTime = true;
    _searchFocusNode.dispose();
    _searchSelected = false;
    _searchController.dispose();
  }

  onSearchTextChanged(String value) {
    setState(() {
      searchText = value.toLowerCase().trim();
    });
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

  List<Todo> _getEventsForDay(DateTime day) {
    loadCalendarIndicators();
    return kEvents[day] ?? [];
  }

  _getSfidAndRole() async {
    final prefs = await SharedPreferences.getInstance();
    sfid = prefs.getString(sfidConstant);
    sfuuid = prefs.getString(saleforceUUIDConstant);
    role = prefs.getString('role').toString();
  }


  var trackTodoListScreen = false;
  @override
  Widget build(BuildContext context) {
    if (trackTodoListScreen == false) {
      CommonPendoRepo.trackTodoListScreenVisit(context: context);
      trackTodoListScreen = true;
    }
    void _onRefresh() async {
      final bloc = context.read<TodoListBloc>();
      bloc.add(
        TodoListEvent(studentId: widget.studentId),
      );

      await Future.delayed(Duration(milliseconds: 1000));

      _refreshController.refreshCompleted();
    }

    void _onLoading() async {
      await Future.delayed(Duration(milliseconds: 1000));

      if (mounted) setState(() {});
      _refreshController.loadComplete();
    }

    return BlocProvider<NotificationsBloc>(
      create: (context) => NotificationsBloc(
          notificationsRepository: NotificationsRepository.instance)
        ..add(FetchNotifications()),
      child: BlocBuilder<TodoFilterBlocStudent, TodoFilterStateStudent>(
          builder: (context, state) {
        if (state is TodoFilterListStateStudent) {
          byme = state.byme;
          isFilterOn = state.isFilterOn;
          filterCheckboxHeadingList = state.filterCheckboxHeadingList;
        }
        return SafeArea(
          child: Semantics(
            label: widget.thirdPerson == false
                ? "Welcome to your dashboard! you can keep track of your tasks using this todo module"
                : "This is the todo list for ",
            child: BlocListener(
              listener: (context, state) {
                if (state is TodoAcceptBulkSuccessState ||
                    state is TodoRejectBulkSuccessState) {
                  context
                      .read<TodoListBloc>()
                      .add(TodoListEvent(studentId: widget.studentId));
                } else if (state is TodoAcceptBulkFailedState ||
                    state is TodoRejectBulkFailedState) {}
              },
              bloc: context.read<TodoAcceptRejectBulkBloc>(),
              child: BlocListener<TodoBulkBloc, TodoBulkState>(
                listener: (context, state) {
                  if (state is TodoBulkSuccessState) {
                    print('Calling bloc again because of bulk success');
                    context
                        .read<TodoListBloc>()
                        .add(TodoListEvent(studentId: widget.studentId));
                  }
                },
                bloc: context.read<TodoBulkBloc>(),
                child: BlocListener(
                  listener: (context, state) {
                    if (state is UpdateTodoStatusSuccessState ||
                        state is UpdateTodoArchiveStatusSuccessState ||
                        state is UpdateTodoSuccessState) {
                      context
                          .read<TodoListBloc>()
                          .add(TodoListEvent(studentId: widget.studentId));
                    }
                  },
                  bloc: context.read<TodoBloc>(),
                  child: Stack(
                    children: [
                      Scaffold(
                        floatingActionButton:
                            _isCalendarViewSelected ? getFloatingBtn() : null,
                        appBar: _searchSelected
                            ? null
                            : widget.thirdPerson == true
                                ? AppBar(
                                    elevation: 0,
                                    title: Text(
                                      widget.student?.name ?? "",
                                      style: TextStyle(
                                          color: kDarkGrayColor,
                                          fontFamily: "MonsterratBold",
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: Colors.white,
                                    leading: IconButton(
                                      icon: SvgPicture.asset(
                                        "images/back_button.svg",
                                        height: 20,
                                        color: kDarkGrayColor,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  )
                                : AppBar(
                                    elevation: 0,
                                    backgroundColor: !_isCalendarViewSelected
                                        ? Colors.white
                                        : kLightGrayColor,
                                    titleSpacing: 0,
                                    centerTitle: false,
                                    title: _isCalendarViewSelected
                                        ? TodoListHeaderMonth(
                                            onPreviousIconTap: () {
                                              _calendarPageController
                                                  .previousPage(
                                                      duration: Duration(
                                                        seconds: 1,
                                                      ),
                                                      curve: Curves.easeInOut);
                                            },
                                            title: kMonthsList[
                                                    _focusedDay.month - 1] +
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
                                                _calendarFormat =
                                                    CalendarFormat.week;
                                              });
                                            })
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Text(
                                              "To-Do",
                                              style: TextStyle(
                                                fontFamily: 'MontserratBold',
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: defaultDark,
                                              ),
                                            ),
                                          ),
                                    actions: [
                                      TodoListActionWidget(
                                        notificationCount: unreadNotifCounter,
                                        onCounterCallBack: (counter) {
                                          setState(() {
                                            unreadNotifCounter = counter;
                                          });
                                        },
                                        onNotificationFetchSuccess: (state) {
                                          state.notificationList.modelList!
                                              .forEach((element) {
                                            if (!element.isRead) {
                                              unreadNotifCounter++;
                                            }
                                          });
                                          setState(() {});
                                          print(unreadNotifCounter);
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
                                                  calendarTodoList =
                                                      stateTodoList;
                                                  _isCalendarViewSelected =
                                                      true;
                                                  _focusedDay = DateTime.now();
                                                })
                                              : Helper.showToast(
                                                  "Loading Todos...");
                                        },
                                        isCalendarViewSelected:
                                            _isCalendarViewSelected,
                                        isSearchSelected: _searchSelected,
                                        searchFocusNode: _searchFocusNode,
                                      ),
                                    ],
                                  ),
                        body: Stack(children: [
                          SmartRefresher(
                              enablePullDown: true,
                              enablePullUp: false,
                              header: WaterDropHeader(
                                waterDropColor: defaultDark,
                              ),
                              controller: _refreshController,
                              onRefresh: _onRefresh,
                              onLoading: _onLoading,
                              child: widget.student == null
                                  ? TodoListTabView(
                                      searchValued: searchText,
                                      filterCheckboxHeadingList:
                                          filterCheckboxHeadingList,
                                      studentId: widget.studentId,
                                      isParent: widget.thirdPerson,
                                      isObserverAdmin: widget.isObserverAdmin,
                                      sortDescending: sortDescending,
                                    )
                                  : _isCalendarViewSelected
                                      ? calendarView()
                                      : taskListView()),
                        ]),
                      ),
                      widget.thirdPerson == false
                          ? SizedBox()
                          : Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  if (widget.student == null) return;
                                  final route = MaterialPageRoute(
                                      builder: (_) => StudentProfileScreen(
                                            student: widget.student!,
                                            thirdPerson: true,
                                            sfid: sfid ?? '',
                                            role: role ?? '',
                                          ));

                                  Navigator.push(context, route);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: !_searchSelected,
                                      child: Stack(children: [
                                        SvgPicture.asset(
                                          'images/student_small_splash.svg',
                                          height: 80,
                                          semanticsLabel:
                                              "Profile Picture of ${widget.student!.name}",
                                        ),
                                        Positioned(
                                          right: 28,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 14, left: 16),
                                            child: widget.student!
                                                        .profilePicture ==
                                                    'null'
                                                ? Container()
                                                : CachedNetworkImage(
                                                    imageUrl:
                                                        widget.student!
                                                                .profilePicture ??
                                                            '',
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                          width: 36,
                                                          height: 36,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                    placeholder: (context,
                                                            url) =>
                                                        CircleAvatar(
                                                            radius: 29,
                                                            backgroundColor:
                                                                Colors.white,
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Container()),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _filterButton() {
    return BlocListener(
      bloc: context.read<TodoListBloc>(),
      listener: (context, state) {
        if (state is TodoListSuccessState) {
          stateTodoList = state.todoListResponse.todoList;
          String studentName = widget.student?.name ?? '';
          listedByNames = state.todoListResponse.allListedByInOneList
              .map((e) => e.name)
              .toList();
          listedByNames.remove(studentName);
          print('isTodoListLoadedFirstTime: $isTodoListLoadedFirstTime');
          if (isTodoListLoadedFirstTime) {
            filterCheckboxHeadingList =
                getFilterCheckboxHeadingList(listedByNames: listedByNames);
            isTodoListLoadedFirstTime = false;
            isFilterOn = false;
          }

          BlocProvider.of<TodoFilterBlocStudent>(context)
              .add(TodoFilterListEventStudent(
            isFilterOn: isFilterOn,
            filterCheckboxHeadingList: filterCheckboxHeadingList,
            byme: byme,
          ));
        }
      },
      child: BlocBuilder<TodoListBloc, TodoListState>(
        builder: (context, state) {
          return IgnorePointer(
            ignoring:
                state is TodoListLoadingState || state is TodoListErrorState,
            child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                builder: (context, pendoState) {
              return Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        sortDescending = !sortDescending;
                      });
                      TodoPendoRepo.trackTodoSortingEvent(
                          isDescending: sortDescending, pendoState: pendoState);
                    },
                    child: SortTodoButton(
                      iconColor: sortDescending ? white : pinkRed,
                      backgroundColor: sortDescending ? pinkRed : white,
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: _filterButtonOnTap,
                    child: isFilterOn
                        ? FilterButton(
                            iconColor: white,
                            iconBackgroundColor: pinkRed,
                          )
                        : FilterButton(
                            iconColor: pinkRed,
                            iconBackgroundColor: white,
                          ),
                  ),
                  widget.thirdPerson == false || _searchSelected
                      ? Container()
                      : Row(
                          children: [
                            SizedBox(width: 12),
                            CircularTodoSearchButton(
                              iconColor: pinkRed,
                              onTap: () {
                                _searchFocusNode.requestFocus();
                                TodoPendoRepo.trackThirdPersonSearch(
                                  thirdPersonSfid: widget.studentId,
                                  pendoState: pendoState,
                                  thirdPersonName: widget.student?.name ?? '',
                                );
                                setState(() {
                                  _searchSelected = true;
                                });
                              },
                              icon: Icons.search,
                            ),
                          ],
                        ),
                ],
              );
            }),
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
                : filterCheckboxHeadingList[index]
                    .subCategories!
                    .map((element) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: CheckboxListTile(
                        checkColor: Colors.white,
                        activeColor: defaultDark,
                        value: element.isCheck,
                        onChanged: (value) {
                          stateSetter(() {
                            if (value == false) {
                              filterCheckboxHeadingList[index].isCheck = false;
                            }
                            element.isCheck = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(element.title,
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
              height: devHeight * 0.6,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _getClearButton(),
                              SizedBox(width: 60),
                              _getDoneButton(),
                            ],
                          ),
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

  Widget _getClearButton() {
    return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
        builder: (context, pendoState) {
      return GestureDetector(
        onTap: () {
          TodoPendoRepo.trackFilterClearEvent(pendoState: pendoState);
          Navigator.pop(context);
          filterCheckboxHeadingList =
              getFilterCheckboxHeadingList(listedByNames: listedByNames);
          isFilterOn = false;
          context.read<TodoFilterBlocStudent>().add(TodoFilterListEventStudent(
                isFilterOn: isFilterOn,
                filterCheckboxHeadingList: filterCheckboxHeadingList,
                byme: byme,
              ));
        },
        child: FilterClearButton(),
      );
    });
  }

  Widget _getDoneButton() {
    return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
        builder: (context, pendoState) {
      return GestureDetector(
        onTap: () {
          Navigator.pop(context);
          if (Helper.getFilteredTodos(
                  filterCheckboxHeadingList: filterCheckboxHeadingList,
                  stateTodoList: stateTodoList) !=
              null) {
            TodoPendoRepo.trackFilterDoneEvent(pendoState: pendoState);
            isFilterOn = true;
          } else {
            isFilterOn = false;
          }

          context.read<TodoFilterBlocStudent>().add(TodoFilterListEventStudent(
                isFilterOn: isFilterOn,
                filterCheckboxHeadingList: filterCheckboxHeadingList,
                byme: byme,
              ));
        },
        child: FilterDoneButton(),
      );
    });
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
                    child: (_calendarFormat == CalendarFormat.week
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
                  expandedHeight: _isMonthAndYearViewSelected
                      ? (120.0)
                      : _calendarFormat == CalendarFormat.month
                          ? (360.0)
                          : (150.0),
                  flexibleSpace: FlexibleSpaceBar(
                    background: TodoCalendarWidget(
                      calendarFormat: _calendarFormat,
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
                          _calendarFormat = format;
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
                  centerTitle: true,
                  title: _searchSelected
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                _searchFocusNode.unfocus();
                                setState(() {
                                  searchText = '';
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
                          _searchSelected ? '' : 'To-Do',
                          style: kalamLight.copyWith(
                              color: defaultDark, fontSize: 24),
                        ),
                );
              }),
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
        ];
      },
      body: BlocListener(
        listener: (context, state) {
          if (state is TodoListSuccessState) {
            calendarTodoList = state.todoListResponse.todoList;
            filtersAppliedCalendarTodoList = calendarTodoList
                .where((element) => (DateTimeUtils.isSameDate(
                    _focusedDay, element.task.completeBy)))
                .toList();
          }
        },
        bloc: context.read<TodoListBloc>(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(),
            widget.student == null
                ? SliverFillRemaining(
                    child: TodoListTabView(
                      searchValued: searchText,
                      filterCheckboxHeadingList: filterCheckboxHeadingList,
                      studentId: widget.studentId,
                      isParent: widget.thirdPerson,
                      isObserverAdmin: widget.isObserverAdmin,
                      sortDescending: sortDescending,
                    ),
                  )
                : BlocBuilder<TodoListBloc, TodoListState>(
                    builder: (context, state) {
                      // log("State of TodoListBloc is:$state and list length would be is:${state is TodoListSuccessState ? ((state).todoListResponse.todoList.length) : "0"}");
                      if (state is TodoListErrorState) {
                        return SliverFillRemaining(
                            child: Center(child: Text(state.err)));
                      } else if (state is TodoListLoadingState) {
                        return SliverFillRemaining(
                          child: Center(
                            child: CustomPaletteLoader(),
                          ),
                        );
                      } else if (state is TodoListSuccessState) {
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
                          return TodoListView(
                            updateInselectMode: (value) {
                              setState(() {
                                _inSelectMode = value;
                              });
                            },
                            useSliver: true,
                            todoList: filtersAppliedCalendarTodoList,
                            category: '',
                            studentId: widget.studentId,
                            stdId: widget.studentId,
                            isParent: widget.thirdPerson,
                            isObserverAdmin: widget.isObserverAdmin,
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

  Widget taskListView() {
    return TextScaleFactorClamper(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.thirdPerson
                ? Container(
                    margin:
                        const EdgeInsets.only(left: 20.0, top: 4, bottom: 6),
                    child: _filterButton(),
                  )
                : SizedBox(width: 0, height: 0),
            if (_searchSelected)
              Builder(builder: (context) {
                if (widget.thirdPerson) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _searchFocusNode.unfocus();
                            setState(() {
                              searchText = '';
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
                  );
                }

                return AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  centerTitle: false,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _searchFocusNode.unfocus();
                          setState(() {
                            searchText = '';
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
                );
              }),
            if (widget.thirdPerson != true)
              TodoListFilterWidget(
                  filterButton: _filterButton(),
                  isSearchSelected: _searchSelected,
                  byme: byme,
                  onSearchIconPressed: () {
                    setState(() {
                      _searchSelected = true;
                    });
                    _searchFocusNode.requestFocus();
                  },
                  onByMeSelected: (pendoState) {
                    byme = !byme;
                    TodoPendoRepo.trackTodoByMeEvent(
                        isByme: byme, pendoState: pendoState);
                    context
                        .read<TodoFilterBlocStudent>()
                        .add(TodoFilterListEventStudent(
                          isFilterOn: isFilterOn,
                          filterCheckboxHeadingList: filterCheckboxHeadingList,
                          byme: byme,
                        ));
                  }),
            Expanded(
              child: TodoListTabView(
                searchValued: searchText,
                filterCheckboxHeadingList: filterCheckboxHeadingList,
                studentId: widget.studentId,
                isParent: widget.thirdPerson,
                stdId: widget.student!.id,
                isObserverAdmin: widget.isObserverAdmin,
                byme: byme,
                sortDescending: sortDescending,
              ),
            ),
          ],
        ),
      ),
    );
  }

  getFloatingBtn() {
    // log("InSelectMode is:$_inSelectMode");
    return _inSelectMode
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
                        if (_expandedFAB) {
                          return TodoBulkEditSelectOptions(
                              onClearAll: () {
                                _clearSelection();
                                setState(() {});
                              },
                              todolist: filtersAppliedCalendarTodoList);
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
        : null;
  }

  void _clearSelection() {
    filtersAppliedCalendarTodoList.forEach((todo) => todo.isSelected = false);
    _inSelectMode = false;
    _expandedFAB = false;
    setState(() {});
  }
}
