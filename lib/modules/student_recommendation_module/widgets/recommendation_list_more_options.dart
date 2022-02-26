import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/explore_module/widgets/bulk_share_bottom_sheet.dart';
import 'package:palette/modules/explore_module/widgets/bulk_share_bottom_sheet_single.dart';
import 'package:palette/modules/student_recommendation_module/bloc/recommendation_bloc/consideration_bulk_bloc.dart';
import 'package:palette/modules/student_recommendation_module/bloc/recommendation_bloc/recommendation_bulk_share_bloc.dart';
import 'package:palette/modules/student_recommendation_module/models/user_models/recommendation_model.dart';
import 'package:palette/modules/student_recommendation_module/models/user_models/user_share_list_response.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_pendo_repo.dart';
import 'package:palette/utils/konstants.dart';

class RecommendationListMoreOptions extends StatefulWidget {
  final Function onClearTap;
  final Function onShareTap;
  final List<RecommendedByData> recommendationsList;
  final Function onRefresh;
  const RecommendationListMoreOptions(
      {required this.onClearTap,
      required this.recommendationsList,
      required this.onShareTap,
      required this.onRefresh});

  @override
  _RecommendationListMoreOptionsState createState() =>
      _RecommendationListMoreOptionsState();
}

class _RecommendationListMoreOptionsState
    extends State<RecommendationListMoreOptions> {
  final _snackBar = SnackBar(
    content: Text('Recommendation record created successfully'),
    backgroundColor: closedButtonColor,
  );

  TextEditingController searchController = TextEditingController();
  List<ShareUserByInstitute> filteredList = [];
  List<ShareUserByInstitute> mainList = [];

  bool loadingAddToTodo = false;
  bool loadingDismiss = false;

  @override
  void dispose() {
    colorController.close();
    isSharePressedController.close();

    searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> ids = getSelectedConsiderationsIds(widget.recommendationsList);
    return BlocListener<ConsiderationBulkBloc, ConsiderationBulkState>(
      listener: (context, state) {
        if (state is ConsiderationBulkAddToTodoLoadingState)
          setState(() {
            loadingAddToTodo = true;
          });
        if (state is ConsiderationBulkDismissLoadingState)
          setState(() {
            loadingDismiss = true;
          });
        if (state is ConsiderationBulkDismissSuccessState ||
            state is ConsiderationBulkAddToTodoSuccessState) {
          loadingAddToTodo = false;
          loadingDismiss = false;
          if (widget.recommendationsList
              .every((element) => element.isSelected)) {
            widget.onClearTap();
            Navigator.pop(context);
          }
        }
      },
      child: Container(
        //height: 205,
        width: 152,
        decoration: BoxDecoration(
          color: uploadIconButtonColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    'Options',
                    style:
                        roboto700.copyWith(fontSize: 14, color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: 28,
                    height: 1.6,
                    color: Colors.white,
                  ),
                  SizedBox(height: 18),
                  _addToTodoButton(context: context),
                  SizedBox(height: 22),
                  _dismissButton(context: context),
                  SizedBox(height: 22),
                  if (isShareVisibility()) _shareButton(context: context),
                ],
              ),
            ),
            _clearSelectionButton()
          ],
        ),
      ),
    );
  }

  bool isShareVisibility() {
    bool _isShareVisibility = true;
    widget.recommendationsList.forEach((element) {
      element.event?.opportunityScope?.toLowerCase() == 'discrete'
          ? _isShareVisibility = false
          : _isShareVisibility = true;
    });
    return _isShareVisibility;
  }

  Widget _clearSelectionButton() {
    return InkWell(
      onTap: loadingDismiss || loadingAddToTodo
          ? () {}
          : () {
              print('Clear selection');
              widget.onClearTap();
            },
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 12),
        color: clearSelectionBackgroundColor.withOpacity(0.12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Clear Selection',
              style:
                  robotoTextStyle.copyWith(fontSize: 14, color: Colors.white),
            ),
            Icon(
              Icons.delete,
              color: white,
              size: 18,
            )
          ],
        ),
      ),
    );
  }

  Widget _dismissButton({required BuildContext context}) {
    return GestureDetector(
      onTap: loadingDismiss
          ? () {}
          : () {
              List<String> ids =
                  getSelectedConsiderationsIds(widget.recommendationsList);
              RecommendationPendoRepo.trackBulkDecline(
                context: context,
                considerationIds: ids,
              );
              context
                  .read<ConsiderationBulkBloc>()
                  .add(ConsiderationBulkDismissTodo(ids: ids));
              widget.onRefresh();
            },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            loadingDismiss ? 'Loading..' : 'Dismiss',
            style: robotoTextStyle.copyWith(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          loadingDismiss
              ? _fabLoader()
              : SvgPicture.asset(
                  "images/crossicon.svg",
                  height: 16,
                  width: 16,
                  color: white,
                ),
        ],
      ),
    );
  }

  StreamController<bool> colorController = StreamController<bool>.broadcast();
  List<String> studentIds = [];
  bool isSharePressed = false;
  StreamController<bool> isSharePressedController =
      StreamController<bool>.broadcast();

  Widget floatingShareActionButtons(
      {String? image, String? text, Function? onPressed}) {
    return StreamBuilder<bool>(
        stream: isSharePressedController.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data == false) {
            return InkWell(
              onTap: () {
                onPressed!();
              },
              child: Container(
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: purpleBlue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset('images/$image'),
                    ),
                  )),
            );
          } else {
            return floatingLoader();
          }
        });
  }

  Widget floatingLoader() {
    return Column(
      children: [
        Container(
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: purpleBlue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ))
      ],
    );
  }

  Widget _shareButton({required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        searchController.clear();

        List<String> oppIds = getSelectedEventIds(widget.recommendationsList);
        if (oppIds.length > 1) {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return BulkShareBottomSheetView(
                  onPressed: (userIds) {
                    final state =
                        BlocProvider.of<PendoMetaDataBloc>(context).state;
                    RecommendationPendoRepo.trackBulkShareConsiderations(
                      assigneesIds: userIds,
                      eventIds: oppIds,
                      pendoState: state,
                    );
                    //
                    BlocProvider.of<RecommendationBulkShareBloc>(context).add(
                      RecommendationBulkShareEvent(
                        oppIds: oppIds,
                        userIds: userIds,
                      ),
                    );
                    widget.onClearTap();
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
                    final state =
                        BlocProvider.of<PendoMetaDataBloc>(context).state;
                    RecommendationPendoRepo.trackBulkShareConsiderations(
                      assigneesIds: userIds,
                      eventIds: oppIds,
                      pendoState: state,
                    );

                    BlocProvider.of<RecommendationBulkShareBloc>(context).add(
                      RecommendationBulkShareEvent(
                        oppIds: oppIds,
                        userIds: userIds,
                      ),
                    );

                    Navigator.pop(context);
                  },
                );
              });
        }
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Share',
              style: robotoTextStyle.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SvgPicture.asset(
              "images/share_mycreation.svg",
              height: 16,
              width: 16,
              color: white,
            ),
          ],
        ),
      ),
    );
  }

  List<String> getSelectedEventIds(List<RecommendedByData> oppList) {
    List<String> ids = [];
    oppList.forEach((element) {
      if (element.isSelected) {
        if (element.event != null && element.event?.id != null)
          ids.add(element.event!.id!);
      }
    });
    return ids;
  }

  List<String> getSelectedConsiderationsIds(List<RecommendedByData> oppList) {
    List<String> ids = [];
    oppList.forEach((element) {
      if (element.isSelected) {
        if (element.id != null && element.id.isNotEmpty)
          element.id.forEach((element) {
            ids.add(element);
          });
      }
    });
    return ids;
  }

  Widget _addToTodoButton({required BuildContext context}) {
    return InkWell(
      onTap: loadingAddToTodo
          ? () {}
          : () {
              List<String> ids =
                  getSelectedConsiderationsIds(widget.recommendationsList);
              RecommendationPendoRepo.trackBulkAddToTodo(
                context: context,
                considerationIds: ids,
              );
              print('selected Considerations $ids');
              context
                  .read<ConsiderationBulkBloc>()
                  .add(ConsiderationBulkAddToTodo(ids: ids));
              // BlocProvider.of<ConsiderationBulkBloc>(context).add(
              //     AddTodoBulkEvent(todoIds: Considerationsids,));
              widget.onRefresh();
            },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            loadingAddToTodo ? 'Loading..' : 'Add to Todo',
            style: robotoTextStyle.copyWith(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          loadingAddToTodo
              ? _fabLoader()
              : SvgPicture.asset(
                  "images/done_enrolled.svg",
                  height: 12,
                  width: 12,
                  color: white,
                ),
        ],
      ),
    );
  }

  Widget _fabLoader() {
    return SizedBox(
      height: 12,
      width: 12,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      ),
    );
  }
}
