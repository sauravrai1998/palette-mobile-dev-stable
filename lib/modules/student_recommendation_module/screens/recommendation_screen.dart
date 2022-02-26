import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/common_repos/common_pendo_repo.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/comment_module/bloc/comment_bloc.dart';
import 'package:palette/modules/student_recommendation_module/bloc/recommendation_bloc/consideration_bulk_bloc.dart';
import 'package:palette/modules/student_recommendation_module/bloc/recommendation_bloc/considertion_bulk_share_bloc.dart';
import 'package:palette/modules/student_recommendation_module/bloc/recommendation_bloc/recommendation_bloc.dart';
import 'package:palette/modules/student_recommendation_module/bloc/recommendation_bloc/recommendation_bulk_share_bloc.dart';
import 'package:palette/modules/student_recommendation_module/bloc/recommendation_bloc/recommendation_event.dart';
import 'package:palette/modules/student_recommendation_module/bloc/recommendation_bloc/recommendation_state.dart';
import 'package:palette/modules/student_recommendation_module/models/user_models/recommendation_model.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_pendo_repo.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_repository.dart';
import 'package:palette/modules/student_recommendation_module/widgets/recommendation_list_more_options.dart';
import 'package:palette/modules/student_recommendation_module/widgets/recommendation_listitem.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'recommendation_detail_screen.dart';

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  TextEditingController searchController = TextEditingController();
  Recommendation? recommendation;
  StreamController<List<RecommendedByData>> recommendationObserver =
      StreamController<List<RecommendedByData>>.broadcast();
  List<RecommendedByData> recommendationsList = [];
  List<RecommendedByData> mainList = [];
  List<RecommendedByData> filteredList = [];
  String? failedError;
  var counter;
  String sfid = '';
  String sfuuid = '';
  String role = '';
  //
  var _inSelectMode = false;
  var _expandedFAB = false;
  var _isFABLoading = false;

  @override
  void initState() {
    super.initState();
    counter = recommendation != null &&
            recommendation!.data != null &&
            recommendation!.data!.length > 0
        ? recommendation!.data!.length
        : 0;

    setSfidAndRole();
  }

  setSfidAndRole() async {
    var prefs = await SharedPreferences.getInstance();
    sfid = prefs.getString(sfidConstant) ?? '';
    sfuuid = prefs.getString(saleforceUUIDConstant) ?? '';
    role = prefs.getString('role') ?? '';
  }

  var trackRecommendationScreen = false;
  @override
  Widget build(BuildContext context) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    if (trackRecommendationScreen == false) {
      CommonPendoRepo.trackRecommendationScreenVisit(context: context);
      trackRecommendationScreen = true;
    }
    return Semantics(
      label:
          "This is recommendation page you can manage your recommendation here",
      child: SafeArea(
          child: TextScaleFactorClamper(
        child: BlocListener<ConsiderationBulkBloc, ConsiderationBulkState>(
          listener: (context, state) {
            if (state is ConsiderationBulkAddToTodoSuccessState ||
                state is ConsiderationBulkDismissSuccessState) {
                context.read<RecommendationBloc>().add(GetRecommendation());
              setState(() {
                _expandedFAB = false;
                _inSelectMode = false;
                recommendation = null;
              });
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: BlocListener(
              bloc: context.read<RecommendationBulkShareBloc>(),
              listener: (context, state) {
                if (state is RecommendationBulkShareSuccessState) {
                  Helper.showToast('Successfully shared');
                } else if (state is RecommendationBulkShareFailedState) {
                  Helper.showToast(state.err);
                }
              },
              child: Column(
                children: [
                  Semantics(container: true, child: titleRow()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Semantics(
                        container: true,
                        label: "Search button",
                        child: searchBar(context: context)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  BlocListener(
                      bloc: context.read<RecommendationBloc>(),
                      listener: (_, state) {
                        if (state is RecommendationLoadingState) {
                          setState(() {
                            isLoading = true;
                          });
                        } else if (state is RecommendationSuccessState) {
                          setState(() {
                            isLoading = false;
                            recommendation = state.recommendationList;
                            mainList = recommendation!.data!;
                            counter = recommendation!.data!.length;
                            _inSelectMode = false;
                            _expandedFAB = false;
                            // if(mainList.isEmpty){
                            Future.delayed(Duration(milliseconds: 300), () {
                              recommendationObserver.sink
                                  .add(state.recommendationList.data!);
                            });
                          });
                        } else if (state is RecommendationFailedState) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: isLoading && recommendation == null
                          ? _getLoadingIndicator()
                          : isLoading == false && recommendation != null
                              ? counter == 0
                                  ? _failedStateResponseWidget()
                                  : StreamBuilder<List<RecommendedByData>>(
                                      stream: recommendationObserver.stream,
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null &&
                                            snapshot.connectionState ==
                                                ConnectionState.active) {
                                          recommendationsList = snapshot.data!;
                                          return Expanded(
                                            child: ListView.builder(
                                                padding: const EdgeInsets.only(
                                                    bottom:
                                                        kFloatingActionButtonMargin +
                                                            18),
                                                itemCount:
                                                    recommendationsList.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                      padding: const EdgeInsets
                                                          .only(bottom: 8),
                                                      child: mainList.isNotEmpty
                                                          ? RecommendationListItem(
                                                              data:
                                                                  recommendationsList[
                                                                      index],
                                                              recomList:
                                                                  recommendationsList,
                                                              onTap: () {
                                                                if (_inSelectMode ||
                                                                    recommendationsList[
                                                                            index]
                                                                        .isSelected) {
                                                                  recommendationsList[
                                                                          index]
                                                                      .isSelected = !recommendationsList[
                                                                          index]
                                                                      .isSelected;
                                                                  if (_noItemSelected(
                                                                      recommendationsList)) {
                                                                    _inSelectMode =
                                                                        false;
                                                                  }
                                                                  setState(
                                                                      () {});
                                                                } else {
                                                                  final route =
                                                                      MaterialPageRoute(
                                                                          builder: (_) =>
                                                                              RecommendationDetail(recommendationsList[index], deleteCallback: (data) {
                                                                                print('data.event!.id ${data.event!.id}');
                                                                                recommendation!.data!.removeWhere((element) {
                                                                                  print('element.event!.id ${element.event!.id}');
                                                                                  return element.event!.id == data.event!.id;
                                                                                });
                                                                                setState(() => counter--);
                                                                                mainList = recommendation!.data!;
                                                                                recommendationObserver.sink.add(mainList);
                                                                              }));
                                                                  RecommendationPendoRepo.trackVisitedDetailScreen(
                                                                      pendoState:
                                                                          pendoState,
                                                                      event: recommendationsList[
                                                                              index]
                                                                          .event);
                                                                  Navigator.push(
                                                                      context,
                                                                      route);
                                                                }
                                                              },
                                                              onLongPress: () {
                                                                setState(() {
                                                                  _inSelectMode =
                                                                      true;
                                                                  recommendationsList[
                                                                          index]
                                                                      .isSelected = true;
                                                                });
                                                              })
                                                          : Container());
                                                }),
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return isLoading
                                              ? _getLoadingIndicator()
                                              : _failedStateResponseWidget();
                                        } else {
                                          return _failedStateResponseWidget();
                                        }
                                      })
                              : _failedStateResponseWidget())
                ],
              ),
            ),
            floatingActionButton: _inSelectMode
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (_expandedFAB)
                          RecommendationListMoreOptions(
                            onClearTap: () {
                              recommendationsList.forEach((element) {
                                element.isSelected = false;
                              });
                              setState(() {
                                _expandedFAB = false;
                                _inSelectMode = false;
                              });
                            },
                            recommendationsList: recommendationsList,
                            onShareTap: () {
                              setState(() {
                                _expandedFAB = false;
                              });
                            },
                            onRefresh: () {
                              recommendationsList.forEach((element) {
                                element.isSelected = false;
                              });
                              // setState(() {
                              //   _expandedFAB = false;
                              // });
                            },
                          ),
                        SizedBox(height: 10),
                        BlocBuilder<ConsiderationBulkBloc,
                            ConsiderationBulkState>(builder: (context, state) {
                          if (state is ConsiderationBulkAddToTodoLoadingState ||
                              state is ConsiderationBulkDismissLoadingState) {
                            _isFABLoading = true;
                            isLoading = true;
                          }
                          if (state is ConsiderationBulkAddToTodoSuccessState ||
                              state is ConsiderationBulkDismissSuccessState ||
                              state is ConsiderationBulkAddToTodoErrorState ||
                              state is ConsiderationBulkDismissErrorState) {
                            _isFABLoading = false;
                          }
                          return _fab();
                        }),
                      ],
                    ),
                  )
                : null,
          ),
        ),
      )),
    );
  }

  FloatingActionButton _fabLoader() {
    return FloatingActionButton(
        backgroundColor: uploadIconButtonColor,
        onPressed: () {},
        child: SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        ));
  }

  FloatingActionButton _fab() {
    return FloatingActionButton(
      backgroundColor: uploadIconButtonColor,
      onPressed: _isFABLoading
          ? () {}
          : () {
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
    );
  }

  void onSearchTextChanged(String text) async {
    filteredList = [];
    if (!searchController.text.startsWith(' ')) {
      filteredList.addAll(mainList.where((RecommendedByData model) {
        return model.event!.name!.toLowerCase().contains(text.toLowerCase());
      }).toList());
      recommendationObserver.sink.add(filteredList);
    }
  }

  Widget titleRow() {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20,),
      child: Row(
        children: [
          Visibility(
            visible: true,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Text(
            recommendation != null &&
                    recommendation!.data != null &&
                    recommendation!.data!.length >= 0 &&
                    counter >= 0
                ? "Considerations ($counter)"
                : "Considerations",
            style: robotoTextStyle.copyWith(
                fontWeight: FontWeight.bold, fontSize: 26),
          )
        ],
      ),
    );
  }

  Widget searchBar({required BuildContext context}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: ExcludeSemantics(
        child: TextField(
          onTap: () {
            print('searchbartapped');
            RecommendationPendoRepo.trackSearchInRecommendation(
                context: context);
          },
          controller: searchController,
          cursorColor: Colors.blueGrey,
          autocorrect: false,
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            border: InputBorder.none,
            hintText: 'Search...',
          ),
          onChanged: onSearchTextChanged,
        ),
      ),
    );
  }

  bool _noItemSelected(List<RecommendedByData> _recommendationsList) {
    final c = _recommendationsList.where((element) => element.isSelected);
    return c.isEmpty;
  }

  bool isLoading = false;

  Widget _getLoadingIndicator() {
    return Center(
      child: Container(height: 38, width: 50, child: CustomPaletteLoader()),
    );
  }

  Widget _failedStateResponseWidget() {
    return Expanded(
      child: Container(
        child: Center(
          child: Text(
            'No recommendations added',
            style: TextStyle(color: defaultDark),
          ),
        ),
      ),
    );
  }
}
