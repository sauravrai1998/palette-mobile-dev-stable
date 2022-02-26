import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/common_repos/common_pendo_repo.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/explore_module/blocs/event_detail_enroll_bloc/event_detail_enoll_bloc.dart';
import 'package:palette/modules/explore_module/blocs/event_detail_wishlist_bloc/event_detail_wishlist_bloc.dart';
import 'package:palette/modules/explore_module/blocs/explore_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/add_opportunities_consideration_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/create_opportunity_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/opportunity_bulk_edit_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/opportunity_bulk_share_bloc.dart';
import 'package:palette/modules/explore_module/models/explore_list_model.dart';
import 'package:palette/modules/explore_module/models/institute_list.dart';
import 'package:palette/modules/explore_module/models/opportunity_filter_model.dart';
import 'package:palette/modules/explore_module/screens/explore_detail_screen.dart';
import 'package:palette/modules/explore_module/services/explore_repository.dart';
import 'package:palette/modules/explore_module/widgets/add_to_todo_bottomsheet.dart';
import 'package:palette/modules/explore_module/widgets/bulk_share_bottom_sheet.dart';
import 'package:palette/modules/explore_module/widgets/bulk_share_bottom_sheet_single.dart';
import 'package:palette/modules/explore_module/widgets/explore_bulk_select_options.dart';
import 'package:palette/modules/explore_module/widgets/explore_bulk_select_options_other_roles.dart';
import 'package:palette/modules/explore_module/widgets/explore_list_item.dart';
import 'package:palette/modules/explore_module/widgets/filter_options_item.dart';
import 'package:palette/modules/explore_module/widgets/filter_options_item_with_icon.dart';
import 'package:palette/modules/explore_module/widgets/more_options_popup.dart';
import 'package:palette/utils/custom_date_formatter.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/explore_pendo_repo.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with TickerProviderStateMixin<ExploreScreen> {
  ExploreListBloc _bloc =
      ExploreListBloc(exploreRepo: ExploreRepository.instance);
  List<ExploreModel> filteredActivityList = [];
  List<DropdownMenuItem<Institute>>? _dropdownMenuItems;
  Institute? _selectedInstitute;
  TextEditingController _searchController = new TextEditingController();
  var _searchFocusNode = FocusNode();
  String sfid = '';
  String sfuuid = '';
  String role = '';
  String searchText = '';
  bool isEventTypeFilterSelected = false;

  final _filterOptionsForStudent = [
    'All',
    'Enrolled',
    'In Consideration',
  ];

  var _filterSelectedIndex = 0;
  var _searchSelected = false;
  late String userRole;
  var _inSelectMode = false;
  var _expandedFAB = false;
  var clearSelection = false;

  var isDismissibleAddToTodoBottomsheet = true;

  @override
  initState() {
    super.initState();
    setSfid();
    clearAllEventFilter();
  }

  void clearAllEventFilter() {
    eventTypeFilterModelList.forEach((element) {
      element.isSelected = false;
    });
  }

  setSfid() async {
    var prefs = await SharedPreferences.getInstance();
    sfid = prefs.getString(sfidConstant) ?? '';
    sfuuid = prefs.getString(saleforceUUIDConstant) ?? '';
    role = prefs.getString('role').toString();
    setState(() {});
  }

  var trackExploreDetailViewEvent = false;
  @override
  Widget build(BuildContext context) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    userRole = pendoState.role;
    if (!trackExploreDetailViewEvent) {
      CommonPendoRepo.trackExploreScreenVisit(context: context);
      trackExploreDetailViewEvent = true;
    }
    return BlocListener(
      listener: (context, state) {
        if (state is OpportunityBulkShareSuccessState) {
          Helper.showToast('Successfully shared');
        } else if (state is OpportunityBulkShareFailedState) {
          Helper.showToast(state.err);
        }
      },
      bloc: context.read<OpportunityBulkShareBloc>(),
      child: BlocListener(
        listener: (context, state) {
          if (state is AddOpportunitiesToTodoSuccessState) {
            Helper.showToast('Opportunities added to todo list successfully');
            print('getExploreList');
            _bloc.getExploreList();
            setState(() => isDismissibleAddToTodoBottomsheet = true);
          } else if (state is AddOpportunitiesToTodoFailureState) {
            Helper.showToast('Opportunities added to todo list failed');
            print('getExploreList');
            _bloc.getExploreList();
            setState(() => isDismissibleAddToTodoBottomsheet = true);
          } else if (state is AddOpportunitiesToTodoLoadingState) {
            setState(() => isDismissibleAddToTodoBottomsheet = false);
          }
        },
        bloc: context.read<AddOpportunitiesToTodoBloc>(),
        child: BlocListener(
          listener: (context, state) {
            if (state is OpportunityBulkAddToTodoSuccessState) {
              Helper.showToast('Opportunities added to todo list successfully');
              print('getExploreList');
              _bloc.getExploreList();
            }
            if (state is OpportunityBulkConsiderSuccessState) {
              Helper.showToast(
                  'Opportunities added to Consideration list successfully');
              print('getExploreList');
              _bloc.getExploreList();
            }
          },
          bloc: context.read<OpportunityBulkEditBloc>(),
          child: BlocListener(
            listener: (context, state) {
              if (state is CreateOpportunitySuccessState) {
                print('getExploreList');
                _bloc.getExploreList();
              }
            },
            bloc: context.read<CreateOpportunityBloc>(),
            child: BlocBuilder<CreateOpportunityBloc, CreateOpportunityState>(
                builder: (context, state) {
              // if (state is CreateOpportunitySuccessState) {
              //   print('getExploreList');
              //   _bloc.getExploreList();
              // }
              return TextScaleFactorClamper(
                  child: Semantics(
                      label:
                          "This is explore page you can see list of event at the center",
                      child: SafeArea(
                        child: Scaffold(
                          backgroundColor: Colors.white,
                          body: Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 28, 20, 0),
                                    // color: Colors.red,
                                    width: MediaQuery.of(context).size.width,
                                    // height: 70,
                                    child: _topRow(),
                                  ),
                                  // Container(
                                  //   margin: EdgeInsets.symmetric(horizontal: 30),
                                  //   // color: Colors.red,
                                  //   width: MediaQuery.of(context).size.width,
                                  //   height: 50,
                                  //   child: Semantics(
                                  //       container: true,
                                  //       label: "Search button",
                                  //       child: _searchBar()),
                                  // ),

                                  role.toLowerCase() == 'student'
                                      ? Container(
                                          margin: EdgeInsets.only(
                                            top: 16,
                                            bottom: 10,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: studentOptions(),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 6),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: eventTypeFilterModelList
                                                  .asMap()
                                                  .entries
                                                  .map((MapEntry map) =>
                                                      _buildEventTypeFilterButton(
                                                          map.key))
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                  SizedBox(height: 15),
                                  _exploreItemsList(),
                                ],
                              ),
                              Positioned(
                                top: 38,
                                left: 20,
                                right: 20,
                                child:
                                    // Animated
                                    Container(
                                  // transform: Matrix4.translationValues(
                                  //     _searchSelected ? 0 : 1000, -10, 0),
                                  // transformAlignment: Alignment.topRight,
                                  // duration: Duration(milliseconds: 340),
                                  width: _searchSelected
                                      ? MediaQuery.of(context).size.width
                                      : 0,
                                  height: _searchSelected
                                      ? MediaQuery.of(context).size.height /
                                          14.7
                                      : 0,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _searchFocusNode.unfocus();
                                              setState(() {
                                                _searchSelected = false;
                                                searchText = '';
                                                _searchController.text = '';
                                                _bloc.exploreListObserver.sink
                                                    .add(_bloc
                                                            .mainActivityList ??
                                                        []);
                                              });
                                            },
                                            child: Container(
                                              height: _searchSelected ? 30 : 0,
                                              width: _searchSelected ? 30 : 0,
                                              child: Icon(
                                                Icons
                                                    .arrow_back_ios_new_rounded,
                                                size: _searchSelected ? 20 : 0,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: _searchSelected
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7
                                                : 0,
                                            height: 35,
                                            child: TextField(
                                              controller: _searchController,
                                              cursorColor: Colors.blueGrey,
                                              autocorrect: false,
                                              focusNode: _searchFocusNode,
                                              // autofocus: true,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                hintText: 'Search...',
                                              ),
                                              onChanged: onSearchTextChanged,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          floatingActionButton: _inSelectMode
                              ? BlocListener<AddOpportunitiesToTodoBloc,
                                      AddOpportunitiesToTodoState>(
                                  listener: (context, state) {
                                    if (state
                                            is AddOpportunitiesToTodoSuccessState ||
                                        state
                                            is AddOpportunitiesToTodoFailureState) {
                                      setState(() {
                                        isDismissibleAddToTodoBottomsheet =
                                            true;
                                      });
                                    }
                                    if (state
                                        is AddOpportunitiesToTodoLoadingState) {
                                      setState(() =>
                                          isDismissibleAddToTodoBottomsheet =
                                              false);
                                    }
                                  },
                                  child: _fab())
                              : null,
                        ),
                      )));
            }),
          ),
        ),
      ),
    );
  }

  Widget _fab() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Builder(
        builder: (BuildContext context) {
          bool showAddTodo = false;
          bool showConsider = false;
          bool showShare = true; //TODO: share button visibility
          filteredActivityList.forEach((element) {
            if (element.isSelected) {
              if (!element.enrolledEvent) {
                showAddTodo = true;
              }
              if (element.activity?.opportunityScope?.toLowerCase() ==
                  'discrete') {
                showShare = false;
              }
            }
          });

          filteredActivityList.forEach((element) {
            if (element.isSelected) {
              if (!element.wishListedEvent) {
                showConsider = true;
              }
            }
          });

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (_expandedFAB)
                role.toLowerCase() == 'student'
                    ? ExploreBulkSelectOptionsStu(
                        showTodo: showAddTodo,
                        showConsider: showConsider,
                        showShare: showShare,
                        onClearTap: () {
                          _clearSelection();
                        },
                        onAddToTodoTap: () {
                          onAddToTodoTap();
                          setState(() {
                            _inSelectMode = false;
                            _expandedFAB = false;
                            filteredActivityList.forEach((element) {
                              element.isSelected = false;
                            });
                          });
                        },
                        onConsiderTap: () {
                          List<String> ids = getSelectedOpportunityIds(
                              _bloc.mainActivityList ?? []);

                          /// Pendo Log
                          ///
                          final pendoState =
                              BlocProvider.of<PendoMetaDataBloc>(context).state;
                          ExplorePendoRepo.trackBulkAddOppToConsideration(
                            eventIds: ids,
                            pendoState: pendoState,
                          );
                          context
                              .read<OpportunityBulkEditBloc>()
                              .add(OpportunityBulkConsider(ids: ids));
                          _clearSelection();
                        },
                        onShareTap: () {
                          ///
                          List<String> oppIds =
                              getSelectedOpportunityIds(filteredActivityList);

                          if (oppIds.length > 1) {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return BulkShareBottomSheetView(
                                    onPressed: (userIds) {
                                      /// Pendo Log
                                      ///
                                      final pendoState =
                                          BlocProvider.of<PendoMetaDataBloc>(
                                                  context)
                                              .state;
                                      ExplorePendoRepo.trackBulkShareOpp(
                                        eventIds: oppIds,
                                        assigneesIds: userIds,
                                        pendoState: pendoState,
                                      );
                                      BlocProvider.of<OpportunityBulkShareBloc>(
                                              context)
                                          .add(
                                        OpportunityBulkShareEvent(
                                          oppIds: oppIds,
                                          userIds: userIds,
                                        ),
                                      );
                                      _clearSelection();
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                          } else {
                            print('show for single');
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return BulkShareBottomSheetForSingle(
                                    eventId: oppIds.first,
                                    onPressed: (userIds) {
                                      BlocProvider.of<OpportunityBulkShareBloc>(
                                              context)
                                          .add(
                                        OpportunityBulkShareEvent(
                                          oppIds: oppIds,
                                          userIds: userIds,
                                        ),
                                      );
                                      _clearSelection();
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                          }
                        },
                      )
                    : ExploreBulkSelectOptionsOtherRoles(
                        showTodo: showAddTodo,
                        showConsider: showConsider,
                        showShare: showShare,
                        onClearTap: () {
                          _clearSelection();
                        },
                        onConsiderationTap: () {
                          List<String> ids =
                              getSelectedOpportunityIds(filteredActivityList);
                          print(
                              'Selected Opportunity Ids: $filteredActivityList');

                          /// Pendo Log
                          ///
                          final pendoState =
                              BlocProvider.of<PendoMetaDataBloc>(context).state;
                          ExplorePendoRepo.trackBulkAddOppToConsideration(
                            eventIds: ids,
                            pendoState: pendoState,
                          );
                          context
                              .read<OpportunityBulkEditBloc>()
                              .add(OpportunityBulkConsider(ids: ids));
                          _clearSelection();
                        },
                        onAddToTodoTap: () {
                          List<String> ids =
                              getSelectedOpportunityIds(filteredActivityList);
                          print('oppIds1: $ids');
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            isDismissible: isDismissibleAddToTodoBottomsheet,
                            builder: (context) {
                              print('oppIds: $ids');
                              return AddTodoBottomSheet(
                                oppurtunityIds: ids,
                              );
                            },
                          );
                          _clearSelection();
                        },
                        onShareTap: () {
                          //
                          List<String> oppIds =
                              getSelectedOpportunityIds(filteredActivityList);

                          if (oppIds.length > 1) {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return BulkShareBottomSheetView(
                                    onPressed: (userIds) {
                                      /// Pendo Log
                                      ///
                                      final pendoState =
                                          BlocProvider.of<PendoMetaDataBloc>(
                                                  context)
                                              .state;
                                      ExplorePendoRepo.trackBulkShareOpp(
                                        eventIds: oppIds,
                                        assigneesIds: userIds,
                                        pendoState: pendoState,
                                      );

                                      BlocProvider.of<OpportunityBulkShareBloc>(
                                              context)
                                          .add(
                                        OpportunityBulkShareEvent(
                                          oppIds: oppIds,
                                          userIds: userIds,
                                        ),
                                      );

                                      ///
                                      Navigator.pop(context);
                                      _clearSelection();
                                    },
                                  );
                                });
                          } else {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return BulkShareBottomSheetForSingle(
                                    eventId: oppIds.first,
                                    onPressed: (userIds) {
                                      /// Pendo Log
                                      ///
                                      final pendoState =
                                          BlocProvider.of<PendoMetaDataBloc>(
                                                  context)
                                              .state;
                                      ExplorePendoRepo.trackBulkShareOpp(
                                        eventIds: oppIds,
                                        assigneesIds: userIds,
                                        pendoState: pendoState,
                                      );

                                      BlocProvider.of<OpportunityBulkShareBloc>(
                                              context)
                                          .add(
                                        OpportunityBulkShareEvent(
                                          oppIds: oppIds,
                                          userIds: userIds,
                                        ),
                                      );
                                      _clearSelection();
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                          }
                        },
                      ),
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
                    borderRadius: BorderRadius.all(Radius.circular(22.5)),
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
          );
        },
      ),
    );
  }

  _clearSelection() {
    clearSelection = true;
    filteredActivityList.forEach((element) {
      element.isSelected = false;
    });
    setState(() {
      _inSelectMode = false;
      _expandedFAB = false;
    });
  }

  onAddToTodoTap() {
    List<String> ids = getSelectedOpportunityIds(filteredActivityList);

    /// Pendo Log
    ///
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    ExplorePendoRepo.trackBulkAddOppToTodo(
        eventIds: ids,
        assigneesIds: [sfid],
        pendoState: pendoState,
        isSendToProgramSelected: false);

    BlocProvider.of<AddOpportunitiesToTodoBloc>(context).add(AddOppToTodoEvent(
        opportunitiesIds: ids,
        assigneesIds: [sfid],
        context: context,
        instituteId: false));
    // context
    //     .read<OpportunityBulkEditBloc>()
    //     .add(OpportunityBulkAddToTodoForStudent(ids: ids));
  }

  List<String> getSelectedOpportunityIds(List<ExploreModel> oppList) {
    List<String> ids = [];
    oppList.forEach((element) {
      if (element.isSelected) {
        if (element.activity != null && element.activity?.activityId != null)
          ids.add(element.activity!.activityId!);
      }
    });
    print('get ids $ids');
    return ids;
  }

  List<Widget> studentOptions() {
    final first = _filterOptionsForStudent
        .asMap()
        .entries
        .map((MapEntry map) => _buildFilterButtonForStudent(map.key))
        .toList();
    final second = eventTypeFilterModelList
        .asMap()
        .entries
        .map((MapEntry map) => _buildEventTypeFilterButton(map.key))
        .toList();
    first.addAll(second);
    return first;
  }

  Widget _buildFilterButtonForStudent(int index) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _filterSelectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          child: StatusTypeExploreFilterOption(
            text: _filterOptionsForStudent[index],
            index: index,
            selectedIndex: _filterSelectedIndex,
          ),
        ));
  }

  Widget _buildEventTypeFilterButton(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          eventTypeFilterModelList[index].isSelected =
              !eventTypeFilterModelList[index].isSelected;
        });

        if (_noEventFilterSelected()) {
          setState(() {
            isEventTypeFilterSelected = false;
          });
        } else {
          setState(() {
            isEventTypeFilterSelected = true;
          });
        }
      },
      child: EventTypeExploreFilterOption(
        opportunityFilterModel: eventTypeFilterModelList[index],
      ),
    );
  }

  bool _noEventFilterSelected() {
    final c = eventTypeFilterModelList.where((element) => element.isSelected);
    return c.isEmpty;
  }

  List<DropdownMenuItem<Institute>>? _buildDropdownMenuItems(List? institutes) {
    List<DropdownMenuItem<Institute>> items = [];

    if (institutes == null) {
      _selectedInstitute = Institute(name: '', id: '');
      items.add(
        DropdownMenuItem(
          value: Institute(name: '', id: ''),
          child: Text(''),
        ),
      );
    } else {
      _bloc.getActivityListByParents(institutes[0].id ?? '');
      for (Institute institute in institutes) {
        String instName = Helper.getFirstWord(institute.name ?? '');
        items.add(
          DropdownMenuItem(
            value: institute,
            child: Text(instName),
          ),
        );
      }
    }

    return items;
  }

  void onSearchTextChanged(String text) async {
    // if(controller.text.isNotEmpty) {

    print('controller.text ${_searchController.text}');
    filteredActivityList = [];
    if (_searchController.text.trim().isNotEmpty) {
      filteredActivityList
          .addAll(_bloc.mainActivityList!.where((ExploreModel model) {
        return model.activity!.name!.toLowerCase().contains(text.toLowerCase());
      }).toList());
      _bloc.exploreListObserver.sink.add(filteredActivityList);

      /// Pendo log
      ///
      final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
      ExplorePendoRepo.trackSearchInOpportunity(
        title: _searchController.text,
        pendoState: pendoState,
      );
    } else {
      _bloc.exploreListObserver.sink.add(_bloc.mainActivityList ?? []);
    }
    // }
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: ExcludeSemantics(
        child: TextField(
          controller: _searchController,
          cursorColor: Colors.blueGrey,
          autocorrect: false,
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.search,
              color: Colors.grey,
              semanticLabel: "search",
            ),
            border: InputBorder.none,
            hintText: 'Search...',
          ),
          onChanged: onSearchTextChanged,
        ),
      ),
    );
  }

  Widget _topRow() {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _searchSelected
              ? Container(width: 0)
              : Semantics(
                  container: true,
                  child: Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        "Opportunities",
                        style: robotoTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 26),
                      )),
                ),
          SizedBox(width: 1),
          Container(
            width: _searchSelected ? 0 : null,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchSelected = true;
                    });
                    _searchFocusNode.requestFocus();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    child: Icon(Icons.search),
                  ),
                ),
                _searchSelected
                    ? Container()
                    : userRole.toLowerCase() != 'observer'
                        ? IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => MoreOptionsPopupMenu(),
                                barrierColor: Colors.black.withOpacity(0.4),
                              );
                            },
                            icon: Icon(Icons.more_vert))
                        : Container(),
              ],
            ),
          ),

          //dropDownColumn(context)
        ],
      ),
    );
  }

  Widget _dropDownColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_instituteListDropdown(context)],
    );
  }

  Widget _instituteListDropdown(BuildContext context) {
    return FutureBuilder<String>(
        future: _bloc.getPathForRegister(),
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data == 'Parent') {
            if (_selectedInstitute == null) _bloc.getInstituteListByParents();
            return _dropdownWidget();
          } else {
            return Container();
          }
        });
  }

  void _onChangeDropdownItem(Institute? selectedInstitute) {
    setState(() {
      _selectedInstitute = selectedInstitute;
      _searchController.clear();
      _bloc.mainActivityList!.clear();
      if (_selectedInstitute!.name == 'All')
        _bloc.getAllActivitiesList();
      else
        _bloc.getActivityListByParents(_selectedInstitute!.id!);
      if (_bloc.mainActivityList!.isEmpty)
        _bloc.exploreListObserver.sink.add([]);
    });
  }

  Widget _dropdownWidget() {
    return StreamBuilder<List<Institute>>(
        stream: _bloc.instituteListObserver.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else {
            if (_selectedInstitute == null) {
              _dropdownMenuItems = _buildDropdownMenuItems(snapshot.data!);
              _selectedInstitute = _dropdownMenuItems![0].value;
              _bloc.getAllActivitiesList();
            }

            return Container();
          }
        });
  }

  Widget _exploreItemsList() {
    return FutureBuilder<String>(
        future: _bloc.getPathForRegister(),
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data == 'Student' ||
              snapshot.data == 'Advisor' ||
              snapshot.data == 'Admin' ||
              snapshot.data == 'Observer') {
            if (_bloc.mainActivityList!.isEmpty) {
              print('Test explore list empty');
              _bloc.getExploreList();
              return _exploreListViewOtherThanParent(snapshot.data ?? '');
            } else
              return _exploreListViewOtherThanParent(snapshot.data ?? '');
          } else if (snapshot.data != null && snapshot.data == 'Parent') {
            if (_bloc.mainActivityList!.isEmpty) {
              _bloc.getExploreList();
              return _showParentExploreListView();
            } else {
              return _showParentExploreListView();
            }
          } else
            return Container();
        });
  }

  Widget _exploreListViewOtherThanParent(String role) {
    print('_exploreListViewOtherThanParent');
    return StreamBuilder<List<ExploreModel>>(
      stream: _bloc.exploreListObserver.stream,
      builder: (context, snapshot) {
        if (snapshot.data != null &&
                snapshot.connectionState == ConnectionState.active ||
            snapshot.hasData) {
          List<ExploreModel> exploreList = snapshot.data!;
          List<ExploreModel> filteredList = exploreList;
          filteredActivityList = exploreList; // Used for searching
          // if (_inSelectMode == false){
          //   filteredList.forEach((element) { element.isSelected = false; });
          // }
          switch (_filterSelectedIndex) {
            case 0:
              filteredList = exploreList;
              break;
            case 1:
              filteredList = exploreList
                  .where((element) => element.enrolledEvent)
                  .toList();
              break;
            case 2:
              filteredList = exploreList
                  .where((element) => element.wishListedEvent)
                  .toList();
              break;
          }

          if (role != 'Student' && isEventTypeFilterSelected) {
            filteredList = Helper.filterOpportunityListBasedOnEventType(
                exploreList: exploreList, context: context);
          } else if (role == 'Student' && isEventTypeFilterSelected) {
            filteredList = Helper.filterOpportunityListBasedOnEventType(
                exploreList: filteredList, context: context);
          }

          if (filteredList.isNotEmpty) {
            return Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 20),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  var no = index + 1;
                  return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                      builder: (context, pendoState) {
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          _inSelectMode = true;
                          filteredList[index].isSelected = true;
                        });
                      },
                      onTap: () async {
                        if (_inSelectMode) {
                          setState(() {
                            filteredList[index].isSelected =
                                !filteredList[index].isSelected;
                          });
                          if (_noItemSelected(filteredList)) {
                            setState(() {
                              _inSelectMode = false;
                            });
                          }
                          return;
                        }

                        final screen = BlocProvider(
                          create: (BuildContext context) =>
                              EventDetailWishlistBloc(
                            exploreRepository: ExploreRepository.instance,
                          ),
                          child: BlocProvider<EventDetailEnrollBloc>(
                            create: (BuildContext context) =>
                                EventDetailEnrollBloc(
                                    exploreRepository:
                                        ExploreRepository.instance),
                            child: ExploreDetail(
                              info: filteredList[index],
                              exploreListBloc: _bloc,
                              isWishListedCallBack: (bool isWishListed) {
                                filteredList[index].wishListedEvent =
                                    isWishListed;
                              },
                              isEnrollCallBack: (bool isEnrolled) {
                                filteredList[index].enrolledEvent = isEnrolled;
                              },
                              sfid: sfid,
                              sfuuid: sfuuid,
                              role: role,
                            ),
                          ),
                        );

                        ExplorePendoRepo.trackExploreDetailViewEvent(
                          eventTitle: filteredList[index].activity?.name ?? '',
                          eventType:
                              filteredList[index].activity?.category ?? '',
                          eventVenue: filteredList[index].activity?.venue ?? '',
                          startDate: CustomDateFormatter.dateIn_DDMMMYYYY(
                              filteredList[index].activity?.startDate ?? ''),
                          pendoState: pendoState,
                        );
                        await Navigator.push(
                            context, MaterialPageRoute(builder: (_) => screen));
                        setState(() {});
                      },
                      child: Builder(builder: (context) {
                        if (index == 0) {
                          print(
                            'filteredList[index].enrolledEvent: ${filteredList[index].enrolledEvent}',
                          );
                        }
                        return Container(
                          margin: EdgeInsets.only(
                            left: filteredList[index].isSelected ? 20 : 8,
                            right: 8,
                          ),
                          child: ExploreListItem(
                            exploreModel: filteredList[index],
                            eventNumber: no,
                          ),
                        );
                      }),
                    );
                  });
                },
              ),
            );
          } else {
            return Expanded(
              child: Container(
                child: Center(
                  child: Text(
                    'No events Found',
                    style: TextStyle(color: defaultDark),
                  ),
                ),
              ),
            );
          }
        } else if (snapshot.data == null &&
            snapshot.connectionState == ConnectionState.waiting) {
          print('snapshot.data: ${snapshot.data}');
          return _getLoadingIndicator();
        } else {
          return Container();
        }
      },
    );
  }

  bool _noItemSelected(List<ExploreModel> filteredList) {
    final c = filteredList.where((element) => element.isSelected);
    return c.isEmpty;
  }

  Widget _showParentExploreListView() {
    return StreamBuilder<List<ExploreModel>>(
      stream: _bloc.exploreListObserver.stream,
      builder: (context, snapshot) {
        print('snapshot.connectionState: ${snapshot.connectionState}');
        if (snapshot.data != null &&
            snapshot.connectionState == ConnectionState.active) {
          List<ExploreModel> list =
              snapshot.data!.isNotEmpty ? snapshot.data! : [];
          filteredActivityList = list;

          if (isEventTypeFilterSelected) {
            list = Helper.filterOpportunityListBasedOnEventType(
                exploreList: list, context: context);
          }

          if (clearSelection) {
            print('stream builder running');
            list.forEach((element) {
              element.isSelected = false;
            });
          }
          if (snapshot.data!.isEmpty || list.isEmpty) {
            return Text('No events found', style: robotoTextStyle);
          }

          if (snapshot.data!.isEmpty && _searchController.text.isEmpty) {
            return _getLoadingIndicator();
          } else {
            return Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                      builder: (context, pendoState) {
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          _inSelectMode = true;
                          clearSelection = false;
                          list[index].isSelected = true;
                        });
                      },
                      onTap: () {
                        if (_inSelectMode) {
                          clearSelection = false;
                          setState(() {
                            list[index].isSelected = !list[index].isSelected;
                          });
                          if (_noItemSelected(list)) {
                            setState(() {
                              _inSelectMode = false;
                            });
                          }
                          return;
                        }

                        final screen = BlocProvider(
                          create: (BuildContext context) =>
                              EventDetailWishlistBloc(
                            exploreRepository: ExploreRepository.instance,
                          ),
                          child: BlocProvider<EventDetailEnrollBloc>(
                            create: (BuildContext context) =>
                                EventDetailEnrollBloc(
                                    exploreRepository:
                                        ExploreRepository.instance),
                            child: ExploreDetail(
                              info: list[index],
                              exploreListBloc: _bloc,
                              isWishListedCallBack: (bool isWishListed) {
                                list[index].wishListedEvent = isWishListed;
                              },
                              isEnrollCallBack: (bool isEnrolled) {
                                list[index].enrolledEvent = isEnrolled;
                              },
                              sfid: sfid,
                              sfuuid: sfuuid,
                              role: role,
                            ),
                          ),
                        );
                        ExplorePendoRepo.trackExploreDetailViewEvent(
                          eventTitle: list[index].activity?.name ?? '',
                          eventType: list[index].activity?.category ?? '',
                          eventVenue: list[index].activity?.venue ?? '',
                          startDate: CustomDateFormatter.dateIn_DDMMMYYYY(
                              list[index].activity?.startDate ?? ''),
                          pendoState: pendoState,
                        );
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => screen));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: ExploreListItem(
                          exploreModel: list[index],
                          eventNumber: index,
                        ),
                      ),
                    );
                  });
                },
              ),
            );
          }
        } else if (snapshot.data == null &&
            snapshot.connectionState == ConnectionState.waiting) {
          return _getLoadingIndicator();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _getLoadingIndicator() {
    return Center(
      child: Container(height: 20, width: 35, child: CustomPaletteLoader()),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
