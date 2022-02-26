import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';

import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/modules/explore_module/blocs/get_my_creations_bloc/get_my_creations_bloc.dart';
import 'package:palette/modules/explore_module/blocs/modification_removal_request_bloc/modification_removal_request_bloc.dart';
import 'package:palette/modules/explore_module/blocs/my_creations_bloc/get_share_users_bloc.dart';
import 'package:palette/modules/explore_module/blocs/my_creations_bloc/my_creations_bulk_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/edit_opportunity_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/opportunity_bulk_share_bloc.dart';

import 'package:palette/modules/explore_module/blocs/opportunity_bloc/opportunity_visibility_bloc.dart';
import 'package:palette/modules/explore_module/models/opp_created_by_me_response.dart';
import 'package:palette/modules/explore_module/screens/created_by_me_detail_screen.dart';
import 'package:palette/modules/explore_module/services/explore_pendo_repo.dart';
import 'package:palette/modules/explore_module/widgets/bulk_share_bottom_sheet.dart';
import 'package:palette/modules/explore_module/widgets/bulk_share_bottom_sheet_single.dart';
import 'package:palette/modules/explore_module/widgets/created_by_me_bulk_select_options.dart';
import 'package:palette/modules/explore_module/widgets/opp_created_by_me_list_item.dart';
import 'package:palette/modules/student_recommendation_module/widgets/removal_bottom_sheet.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

class OppCreatedByMeScreen extends StatefulWidget {
  const OppCreatedByMeScreen({Key? key}) : super(key: key);

  @override
  _OppCreatedByMeScreenState createState() => _OppCreatedByMeScreenState();
}

class _OppCreatedByMeScreenState extends State<OppCreatedByMeScreen> {
  TextEditingController _searchController = new TextEditingController();
  List<OppCreatedByMeModel> oppCreatedByMeList = [];
  var _inSelectMode = false;
  var _expandedFAB = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditOpportunityBloc, EditOpportunityState>(
      listener: (context, state) {
        if (state is EditOpportunitySuccessState) {
          Helper.showToast('Opportunity Updated successfully');
          final _bloc = BlocProvider.of<GetMyCreationsBloc>(context);
          _bloc.add(GetMyCreationsFetchEvent());
        }
      },
      child: BlocListener(
        listener: (context, state) {
          if (state is OpportunityBulkShareSuccessState) {
            Helper.showToast('Successfully shared');
          } else if (state is OpportunityBulkShareFailedState) {
            Helper.showToast(state.err);
          }
        },
        bloc: context.read<OpportunityBulkShareBloc>(),
        child: BlocListener<MyCreationsBlukBloc, MyCreationsBulkState>(
          listener: (context, state) {
            if (state is MyCreationsBulkSuccessState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('${state.message}')));
            }
          },
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: defaultDark,
                            )),
                        SizedBox(width: 10),
                        Text(
                          'My Creations',
                          style: roboto700,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: _searchBar(),
                  ),
                  BlocBuilder<MyCreationsBlukBloc, MyCreationsBulkState>(
                      builder: (context, state) {
                    // if (state is MyCreationsBulkLoadingState) {
                    //   return Center(child: CustomPaletteLoader());
                    // }
                    if (state is MyCreationsBulkSuccessState) {
                      final bloc = BlocProvider.of<GetMyCreationsBloc>(context);
                      bloc.add(GetMyCreationsFetchEvent());
                      BlocProvider.of<MyCreationsBlukBloc>(context)
                          .add(MyCreationBulkResetEvent());
                    }
                    return _body();
                  }),
                ],
              ),
              bottom: false,
            ),
            floatingActionButton: _inSelectMode
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (_expandedFAB)
                          CreatedByMeBulkSelectOptions(
                            oppCreatedByMeList: oppCreatedByMeList,
                            onClearTap: () {
                              _onClearTap();
                            },
                            onHideTap: (_visibility) {
                              final opportunityIds = oppCreatedByMeList
                                  .where((element) => element.isSelected)
                                  .map((element) => element.id)
                                  .toList();
                              print(
                                  "opportunityIds.length: ${opportunityIds.length}");
                              BlocProvider.of<MyCreationsBlukBloc>(context).add(
                                  BulkHideMyCreationsEvent(
                                      opportunityIds: opportunityIds,
                                      visibility: _visibility));
                              setState(() {
                                _inSelectMode = false;
                                _expandedFAB = false;
                                oppCreatedByMeList.forEach(
                                    (element) => element.isSelected = false);
                              });
                              /// Pendo log
                              ///
                              final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
                              ExplorePendoRepo.trackBulkHideInMyCreationPage(
                                pendoState: pendoState,
                                opportunityIds: opportunityIds
                              );
                            },
                            onDeactivateTap: () {
                              final opportunityIds = oppCreatedByMeList
                                  .where((element) => element.isSelected)
                                  .map((element) => element.id)
                                  .toList();
                              print(
                                  "opportunityIds.length: ${opportunityIds.length}");
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return BlocProvider<
                                          OpportunityVisibilityBloc>(
                                      create: (context) =>
                                          OpportunityVisibilityBloc(
                                              OpportunityVisibilityInitialState()),
                                      child: RemovalBottomSheet(
                                        opportunityId: opportunityIds,
                                        isBulk: true,
                                      ));
                                },
                                isDismissible: false,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                              );
                              // BlocProvider.of<MyCreationsBlukBloc>(context).add(
                              //     BulkDeleteMyCreationsEvent(
                              //         eventIds: opportunityIds));
                              setState(() {
                                _inSelectMode = false;
                                _expandedFAB = false;
                                oppCreatedByMeList.forEach(
                                    (element) => element.isSelected = false);
                              });
                            },
                            onShareTap: () {
                              ///
                              final oppIds = oppCreatedByMeList
                                  .where((element) => element.isSelected)
                                  .map((element) => element.id)
                                  .toList();
                              if (oppIds.length > 1) {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return BulkShareBottomSheetView(
                                        onPressed: (userIds) {
                                          final oppIds = oppCreatedByMeList
                                              .where((element) =>
                                                  element.isSelected)
                                              .map((element) => element.id)
                                              .toList();
                                          /// Pendo log
                                          ///
                                          final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
                                          ExplorePendoRepo
                                              .trackMyCreationBulkShare(
                                            pendoState: pendoState,
                                            oppIds: oppIds,
                                            assigneesIds: userIds,
                                          );

                                          BlocProvider.of<
                                                      OpportunityBulkShareBloc>(
                                                  context)
                                              .add(
                                            OpportunityBulkShareEvent(
                                              oppIds: oppIds,
                                              userIds: userIds,
                                            ),
                                          );
                                          _onClearTap();
                                          Navigator.pop(context);
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
                                          ExplorePendoRepo
                                              .trackMyCreationSingleShare(
                                            context: context,
                                            assigneesIds: userIds,
                                            oppIds: oppIds,
                                          );

                                          BlocProvider.of<
                                                      OpportunityBulkShareBloc>(
                                                  context)
                                              .add(
                                            OpportunityBulkShareEvent(
                                              oppIds: oppIds,
                                              userIds: userIds,
                                            ),
                                          );
                                          _onClearTap();
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
                  )
                : null,
          ),
        ),
      ),
    );
  }

  _onClearTap() {
    setState(() {
      _inSelectMode = false;
      _expandedFAB = false;
      oppCreatedByMeList.forEach((element) => element.isSelected = false);
    });
  }

  Widget floatingLoader() {
    return CustomChasingDotsLoader(color: white);
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
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

  void onSearchTextChanged(String text) async {
    setState(() {});
  }

  Widget _body() {
    return BlocBuilder<GetMyCreationsBloc, GetMyCreationsState>(
        builder: (context, state) {
      if (state is GetMyCreationsLoadingState) {
        return Center(child: CustomPaletteLoader());
      }
      if (state is GetMyCreationsGetFailedState) {
        Center(child: Text(state.err));
      }
      if (state is GetMyCreationsSuccessState) {
        oppCreatedByMeList = state.oppCreatedByMeResp.oppCreatedByMeList;
        if (_searchController.text != '') {
          oppCreatedByMeList = oppCreatedByMeList
              .where(
                (opp) => opp.eventName
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()),
              )
              .toList();

          /// Pendo log
          ///
          final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
          ExplorePendoRepo.trackSearchInMyCreationPage(
            title: _searchController.text,
            pendoState: pendoState,
          );
        }

        return _listView(oppCreatedByMeList: oppCreatedByMeList);
      }
      return Container();
    });
  }

  Widget _listView({required List<OppCreatedByMeModel> oppCreatedByMeList}) {
    if (oppCreatedByMeList.isEmpty) {
      return Center(child: Text('No data available'));
    }
    return Expanded(
      child: ListView.builder(
        itemCount: oppCreatedByMeList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              setState(() {
                _inSelectMode = true;
                oppCreatedByMeList[index].isSelected = true;
              });
            },
            onTap: () {
              if (_inSelectMode) {
                setState(() {
                  oppCreatedByMeList[index].isSelected =
                      !oppCreatedByMeList[index].isSelected;
                });
                if (_noItemSelected(oppCreatedByMeList)) {
                  setState(() {
                    _inSelectMode = false;
                  });
                }
                return;
              }

              /// Pendo log
              ///
              final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
              ExplorePendoRepo.trackViewMyCreationDetailPage(
                oppCreatedByMeObj: oppCreatedByMeList[index],
                pendoState: pendoState,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider<OpportunityVisibilityBloc>(
                          create: (context) => OpportunityVisibilityBloc(
                              OpportunityVisibilityInitialState())),
                      BlocProvider<OpportunityShareUsersBloc>(
                        create: (context) {
                          return OpportunityShareUsersBloc()
                            ..add(GetShareUsersFetchEvent(
                                eventId: oppCreatedByMeList[index].id));
                        },
                      ),
                      BlocProvider<CancelRequestBloc>(
                          create: (context) => CancelRequestBloc(
                              CancelRequestInitialState())),
                    ],
                    child: CreatedByMeDetailScreen(
                        oppCreatedByMeObj: oppCreatedByMeList[index]),
                  ),
                ),
              );
            },
            child: OppCreatedByMeListItem(
              oppCreatedByMeModel: oppCreatedByMeList[index],
            ),
          );
        },
      ),
    );
  }

  bool _noItemSelected(List<OppCreatedByMeModel> oppCreatedByMeList) {
    final c = oppCreatedByMeList.where((element) => element.isSelected);
    return c.isEmpty;
  }
}
