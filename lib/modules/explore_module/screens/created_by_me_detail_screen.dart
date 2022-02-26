import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/modules/comment_module/services/comment_pendo_repo.dart';
import 'package:palette/modules/explore_module/blocs/explore_detail_bloc.dart';
import 'package:palette/modules/explore_module/blocs/get_my_creations_bloc/get_my_creations_bloc.dart';
import 'package:palette/modules/explore_module/blocs/modification_removal_request_bloc/modification_removal_request_bloc.dart';
import 'package:palette/modules/explore_module/blocs/my_creations_bloc/get_share_users_bloc.dart';
import 'package:palette/modules/explore_module/blocs/my_creations_bloc/my_creations_bulk_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/get_modification_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/opportunity_visibility_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/save_opportunity_bloc.dart';
import 'package:palette/modules/explore_module/models/explore_status.dart';
import 'package:palette/modules/explore_module/models/opp_created_by_me_response.dart';
import 'package:palette/modules/explore_module/models/student_list_response.dart';
import 'package:palette/modules/explore_module/services/explore_pendo_repo.dart';
import 'package:palette/modules/explore_module/services/explore_repository.dart';
import 'package:palette/modules/comment_module/screens/comments_view.dart';
import 'package:palette/modules/explore_module/services/opportunity_repository.dart';
import 'package:palette/modules/explore_module/widgets/bulk_share_bottom_sheet_single.dart';
import 'package:palette/modules/explore_module/widgets/common_opportunity_alerts.dart';
import 'package:palette/modules/explore_module/widgets/modification_review_button.dart';
import 'package:palette/modules/comment_module/bloc/comment_bloc.dart';
import 'package:palette/modules/comment_module/model/send_comment_bloc.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_repository.dart';
import 'package:palette/modules/student_recommendation_module/widgets/removal_bottom_sheet.dart';
import 'package:palette/utils/custom_date_formatter.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

import '../../../main.dart';
import 'edit_opportunity_page.dart';
import 'modification_request_screen.dart';

class CreatedByMeDetailScreen extends StatefulWidget {
  final OppCreatedByMeModel oppCreatedByMeObj;

  const CreatedByMeDetailScreen({Key? key, required this.oppCreatedByMeObj})
      : super(key: key);

  @override
  _CreatedByMeDetailScreenState createState() =>
      _CreatedByMeDetailScreenState();
}

class _CreatedByMeDetailScreenState extends State<CreatedByMeDetailScreen> {
  var isTopRowOpen = false;
  final _snackBar = SnackBar(
    content: Text('Recommendation record created successfully'),
    backgroundColor: closedButtonColor,
  );
  ScrollController _scrollController = ScrollController();

  var searchController = TextEditingController();

  ExploreDetailBloc _bloc =
      ExploreDetailBloc(exploreRepo: ExploreRepository.instance);

  @override
  void initState() {
    super.initState();
    log('initState ${widget.oppCreatedByMeObj.toJson()}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CancelRequestBloc, CancelRequestState>(
      listener: (context, state) {
        if (state is CancelRequestLoadingState) {}
        if (state is CancelRequestSuccessState) {
          final _bloc = BlocProvider.of<GetMyCreationsBloc>(context);
          _bloc.add(GetMyCreationsFetchEvent());
          Navigator.of(context).pop();
        }
        if (state is CancelRequestFailureState) {}
      },
      child:
          BlocListener<OpportunityVisibilityBloc, OpportunityVisibilityState>(
        listener: (context, state) {
          if (state is OpportunityVisibilityLoadingState) {}
          if (state is OpportunityVisibilitySuccessState) {
            final _bloc = BlocProvider.of<GetMyCreationsBloc>(context);
            _bloc.add(GetMyCreationsFetchEvent());
            Navigator.of(context).pop();
          }
          if (state is OpportunityVisibilityErrorState) {}
        },
        child:
            BlocBuilder<CancelRequestBloc, CancelRequestState>(
                builder: (context, state) {
                  if (state is CancelRequestLoadingState) {
                  }
                  if (state is CancelRequestSuccessState) {
                    // Navigator.of(context).pop();
                    Helper.showToast('${state.message}');
                  }
                  if (state is CancelRequestFailureState) {
                    // Navigator.of(context).pop();
                    Helper.showToast('Opportunity Visibility Updated Failed');
                  }

              return BlocBuilder<OpportunityVisibilityBloc, OpportunityVisibilityState>(
                  builder: (context, state) {
          if (state is OpportunityVisibilityLoadingState) {
              // Helper.showLoadingDialog(context);
          }
          if (state is OpportunityVisibilitySuccessState) {
              // Navigator.of(context).pop();
              Helper.showToast('${state.message}');
              BlocProvider.of<OpportunityVisibilityBloc>(context)
                  .add(SetOpportunityVisibilityToInitEvent());
          }
          if (state is OpportunityVisibilityErrorState) {
              // Navigator.of(context).pop();
              Helper.showToast('Opportunity Visibility Updated Failed');
              print('Opportunity Visibility Updated Failed ${state.error}');
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              leading: IconButton(
                  icon: RotatedBox(
                      quarterTurns: 1,
                      child: SvgPicture.asset(
                        'images/dropdown.svg',
                        semanticsLabel:
                            "button to navigate back to list of events",
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
                  actions: [
                         _expandableRow(context: context),
                  ],
            ),
            body: LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                physics: RangeMaintainingScrollPhysics(),
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: _column(context),
                    ),
                  ),
                ),
              );
            }),
          );
        });}
            ),
      ),
    );
  }

  Widget _expandableRow({required BuildContext context}) {
    bool _isRemoved = widget.oppCreatedByMeObj.visibility ==
        OpportunityVisibility.Removed.name;
    return _isRemoved
        ? Container()
        : AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
          width: isTopRowOpen
              ? _isRemoved
                  ? MediaQuery.of(context).size.width * 0.5
                  : MediaQuery.of(context).size.width * 0.7
              : MediaQuery.of(context).size.width * 0.14,
          height: 50,
          decoration: BoxDecoration(
            color: pureblack,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: isTopRowOpen
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            children: isTopRowOpen
                ? [
                    removeButton(context),
                    if (!_isRemoved) visbilityButton(context),
                    editButton(context),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isTopRowOpen = false;
                        });
                      },
                      child: SvgPicture.asset(
                        'images/close_expand_mycreat.svg',
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ]
                : [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isTopRowOpen = true;
                        });
                      },
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: white,
                        ),
                      ),
                    )
                  ],
          ),
        );
  }

  GestureDetector editButton(BuildContext context) {
    bool _isRemovalInReview = widget.oppCreatedByMeObj.removalStatus ==
        OpportunityModificationStatus.InReview.name;
    return GestureDetector(
                        onTap: () {
                          if (_isRemovalInReview)
                          _showAlert(
                              alertType: OpportunityAlertsType.removalInReview,
                              actionType: OpportunityActionType.opportunity,
                              onYesTap: () {
                                print('yes');
                                Navigator.pop(context);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        BlocProvider<SaveOpportunityBloc>(
                                            create: (context) =>
                                                SaveOpportunityBloc(
                                                    SaveOpportunityInitialState()),
                                            child: EditOpportunityPage(
                                                opportunity:
                                                widget.oppCreatedByMeObj))));
                              });
                          else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider<SaveOpportunityBloc>(
                                        create: (context) =>
                                            SaveOpportunityBloc(
                                                SaveOpportunityInitialState()),
                                        child: EditOpportunityPage(
                                            opportunity:
                                            widget.oppCreatedByMeObj))));
                          }
                        },
                        child: SvgPicture.asset(
                          'images/edit_mycreat.svg',
                          height: 24,
                          width: 24,
                        ),
                      );
  }

  GestureDetector removeButton(BuildContext context) {
    bool _isModificationInReview = widget.oppCreatedByMeObj.modificationId != null ;
    return GestureDetector(
      onTap: () {
        setState(() {
          isTopRowOpen = false;
        });
        ExplorePendoRepo.trackMyCreationSingleDeactivate(
          context: context,
          id: widget.oppCreatedByMeObj.id,
          scope: widget.oppCreatedByMeObj.opportunityScope,
          type: widget.oppCreatedByMeObj.type,
        );
        if (_isModificationInReview) {
          _showAlert(
              alertType: OpportunityAlertsType.modificationInReview,
              actionType: OpportunityActionType.opportunity,
              onYesTap: () {
                print('yes');
                Navigator.pop(context);
                showRemoveBottomSheet(context);
              });
        }
        else {
          showRemoveBottomSheet(context);
        }
      },
      child: SvgPicture.asset(
        'images/delete_mycreat.svg',
        height: 24,
        width: 24,
      ),
    );
  }

  Future<dynamic> showRemoveBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return BlocProvider<OpportunityVisibilityBloc>(
              create: (context) => OpportunityVisibilityBloc(
                  OpportunityVisibilityInitialState()),
              child: RemovalBottomSheet(
                opportunityId: [widget.oppCreatedByMeObj.id],
                isBulk: false,
                popCallBack: () {
                  Navigator.pop(context);
                },
                isGlobal:
                    widget.oppCreatedByMeObj.opportunityScope == 'Global',
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
  }

  Widget visbilityButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ExplorePendoRepo.trackMyCreationSingleHide(
            context: context,
            id: widget.oppCreatedByMeObj.id,
            type: widget.oppCreatedByMeObj.type,
            oppScope: widget.oppCreatedByMeObj.opportunityScope!);
        setState(() {
          isTopRowOpen = false;
          widget.oppCreatedByMeObj.visibility == OpportunityVisibility.Hidden;
        });
        OpportunityVisibility visibility =
            widget.oppCreatedByMeObj.visibility == 'Available'
                ? OpportunityVisibility.Hidden
                : OpportunityVisibility.Available;
        // BlocProvider.of<OpportunityVisibilityBloc>(context).add(
        //   ToggleOpportunityVisibilityEvent(
        //     opporunityId: widget.oppCreatedByMeObj.id,
        //     visibility: visibility,
        //   ),
        // );
        BlocProvider.of<MyCreationsBlukBloc>(context).add(
            BulkHideMyCreationsEvent(
                opportunityIds: [widget.oppCreatedByMeObj.id],
                visibility: visibility));
      },
      child: SvgPicture.asset(
        'images/hide_mycreat.svg',
        height: 24,
        width: 24,
      ),
    );
  }

  Widget _column(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // TODO: Modification Request in Review button api integration is pending

            if ((widget.oppCreatedByMeObj.modificationId != null &&
                widget.oppCreatedByMeObj.modificationId != 'null'))
              ModificationInReview(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider<ModificationDetailBloc>(
                                    create: (context) => ModificationDetailBloc(
                                          opportunityRepository:
                                              OpportunityRepository.instance,
                                        )..add(FetchModificationDetail(widget
                                            .oppCreatedByMeObj
                                            .modificationId!))),
                                BlocProvider<CancelRequestBloc>(
                                    create: (context) => CancelRequestBloc(
                                        CancelRequestInitialState()))
                              ],
                              child: ModificationRequestPage(
                                  opportunity: widget.oppCreatedByMeObj),
                            )));
                  },
                  isRemoval: false),
            if (widget.oppCreatedByMeObj.removalStatus != null &&
                widget.oppCreatedByMeObj.removalStatus != 'null' &&
                widget.oppCreatedByMeObj.removalStatus == 'In Review')
              ModificationInReview(
                  onTap: () {
                    _showAlert(
                        alertType: OpportunityAlertsType.cancelRemoval,
                        actionType: OpportunityActionType.opportunity,
                        onYesTap: () {
                          print('yes');
                          Navigator.pop(context);
                          BlocProvider.of<CancelRequestBloc>(context).add(
                              CancelRemovalRequestEvent(
                                  opportunityId: widget.oppCreatedByMeObj.id));
                        });
                  },
                  isRemoval: true),
            if (widget.oppCreatedByMeObj.approvalStatus != null)
              eventTitleRow(context),
            SizedBox(height: 10),
            titleRow(),
            SizedBox(height: 10),
            _dateAndVanueColumn(),
            SizedBox(height: 25),
            Container(
              height: _deviceHeight * 0.45,
              child: Scrollbar(
                isAlwaysShown: true,
                showTrackOnHover: true,
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      widget.oppCreatedByMeObj.description ?? '',
                      style: montserratNormal.copyWith(
                        color: defaultDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          height: 60,
          decoration: BoxDecoration(
              color: pureblack, borderRadius: BorderRadius.circular(34)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (widget.oppCreatedByMeObj.phoneNumber != null &&
                  widget.oppCreatedByMeObj.phoneNumber!.length >= 10)
                GestureDetector(
                  onTap: () async {
                    final phone = widget.oppCreatedByMeObj.phoneNumber;
                    await urlLauncher.launch('tel://$phone');
                  },
                  child: SvgPicture.asset(
                    'images/call_mycreation.svg',
                    height: 24,
                    width: 24,
                  ),
                ),
              GestureDetector(
                onTap: () async {
                  var url = widget.oppCreatedByMeObj.website;
                  print(
                      'widget.oppCreatedByMeObj.website: ${widget.oppCreatedByMeObj.website}');

                  if (url != null) {
                    if (!url.startsWith('http')) {
                      url = 'https://' + url;
                    }
                    if (await urlLauncher.canLaunch(url))
                      await urlLauncher.launch(url);
                  }
                },
                child: SvgPicture.asset(
                  'images/link_mycreation.svg',
                  height: 24,
                  width: 24,
                ),
              ),
              GestureDetector(
                onTap: () {
                  final pendoState =
                      BlocProvider.of<PendoMetaDataBloc>(context).state;
                  CommentPendoRepo.trackViewCommentBottomSheet(
                    pendoState: pendoState,
                    eventId: widget.oppCreatedByMeObj.id.toString(),
                    commentOn: "MyCreation",
                  );
                  showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28.0),
                        topRight: Radius.circular(28.0),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      return BlocProvider<CommentsBloc>(
                          create: (context) => CommentsBloc(
                              commentRepository: RecommendRepository.instance)
                            ..add(FetchComments(widget.oppCreatedByMeObj.id)),
                          child: BlocProvider<SendCommentsBloc>(
                              create: (context) => SendCommentsBloc(
                                  commentRepository:
                                      RecommendRepository.instance),
                              child: CommentsView(
                                eventId: widget.oppCreatedByMeObj.id,
                                commentType: "Generic",
                                commentOn: "MyCreation",
                              )));
                    },
                  );
                },
                child: SvgPicture.asset(
                  'images/comment_mycreation.svg',
                  height: 24,
                  width: 24,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Coming Soon!"),
                  ));
                },
                child: SvgPicture.asset(
                  'images/raise_conflict_mycreation.svg',
                  height: 24,
                  width: 24,
                ),
              ),
              if (widget.oppCreatedByMeObj.visibility?.toLowerCase() !=
                  'removed')
                if (widget.oppCreatedByMeObj.approvalStatus?.toLowerCase() ==
                    'approved')
                  _shareButton()
            ],
          ),
        ),
      ],
    );
  }

  _showAlert(
      {required OpportunityAlertsType alertType,
      required OpportunityActionType actionType,
      required Function onYesTap}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OpportunityAlerts(
          type: alertType,
          actionType: actionType,
          onYesTap: () => onYesTap(),
        );
      },
      barrierDismissible: true,
    );
  }

  Widget _shareButton() {
    return BlocBuilder<OpportunityShareUsersBloc, GetShareUsersState>(
        builder: (context, state) {
      if (state is ShareUsersLoadingState) {
        return floatingLoader();
      } else if (state is ShareUsersSuccessState) {
        return GestureDetector(
          onTap: () {
            _showBottomSheet(context, state.userList);
          },
          child: SvgPicture.asset(
            'images/share_mycreation.svg',
            height: 24,
            width: 24,
          ),
        );
      } else {
        return Container();
      }
    });
  }

  Widget floatingLoader() {
    return CustomChasingDotsLoader(color: white);
  }

  Widget eventTitleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: _getColor(),
              ),
              height: 36,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(bottom: 4),
              child: Center(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: white,
                    ),
                  ),
                  SizedBox(width: 4),
                  _getStatusTextWidget(),
                ],
              )),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 4.0, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 22,
                      height: 26,
                      child: SvgPicture.asset(
                        _getImageStringForEvent(
                            type: widget.oppCreatedByMeObj.type),
                        color: defaultDark.withOpacity(0.50),
                      )),
                  SizedBox(width: 3),
                  Container(
                    width: MediaQuery.of(context).size.width * .3,
                    child: Text(
                      widget.oppCreatedByMeObj.type,
                      style: kalam700.copyWith(
                          color: defaultDark.withOpacity(0.50), fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dateAndVanueColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.oppCreatedByMeObj.venue != null,
          child: Container(
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: iconEvent,
                  size: 18,
                ),
                Text(
                  widget.oppCreatedByMeObj.venue ?? '',
                  style: TextStyle(
                      color: defaultDark.withOpacity(0.50), fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        if (widget.oppCreatedByMeObj.eventDate != null)
          Text(
            '  ${_getEventDateString()}',
            style: kalamLight.copyWith(
                color: defaultDark.withOpacity(0.50), fontSize: 14),
          ),
      ],
    );
  }

  String _getEventDateString() {
    var _date = CustomDateFormatter.dateIn_DDMMMYYYY(
        widget.oppCreatedByMeObj.eventDate ?? '');
    if (_date == '' || _date.contains('1970')) {
      return '';
    }
    return _date;
  }

  Color _getColor() {
    String? status = widget.oppCreatedByMeObj.approvalStatus?.toLowerCase();
    String? visibility = widget.oppCreatedByMeObj.visibility?.toLowerCase();
    if (visibility == 'available') {
      if (status == 'approved') {
        return green;
      } else if (status == 'rejected') {
        return red;
      } else if (status == 'draft' || visibility == 'hidden') {
        return Colors.grey;
      }
    } else if (visibility == 'hidden') {
      return Colors.grey;
    } else if (visibility == 'removed') {
      return red;
    }
    return uploadIconButtonColor;
  }

  Widget _getStatusTextWidget() {
    String status = _statusString(widget.oppCreatedByMeObj);
    return Text(
      status,
      style: robotoTextStyle.copyWith(color: white, fontSize: 18),
    );
  }

  String _statusString(OppCreatedByMeModel opp) {
    var status = opp.status?.toLowerCase();
    var _visibility = opp.visibility?.toLowerCase();
    if (_visibility == 'available') {
      if (status == 'approved') {
        if(opp.opportunityScope?.toLowerCase() == 'global')
          return 'Approved';
        else
          return 'Available';
      } else if (status == 'rejected') {
        return 'Rejected';
      } else if (status == 'draft') {
        return 'Draft';
      } else {
        return 'In Review';
      }
    } else if (_visibility == 'hidden') {
      return 'Hidden';
    } else if (_visibility == 'removed') {
      return 'Removed';
    } else {
      return 'In Review';
    }
  }

  String _getImageStringForEvent({required String type}) {
    if (type == 'Event - Arts') {
      return 'images/arts_WM.svg';
    } else if (type == 'Event - Volunteer') {
      return 'images/volunteerWM.svg';
    } else if (type == 'Event - Social') {
      return 'images/social_WM.svg';
    } else if (type == 'Event - Sports') {
      return 'images/sports_WM.svg';
    } else if (type == 'Employment') {
      return 'images/employment.svg';
    } else if (type.startsWith('Education')) {
      return "images/education_WM.svg";
    } else {
      return 'images/genericVM.svg';
    }
  }

  Widget titleRow() {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        widget.oppCreatedByMeObj.eventName,
        style: roboto700.copyWith(
          color: defaultDark,
          fontSize: 24,
        ),
      ),
    );
  }

  /// BottomSheet

  void _showBottomSheet(
    BuildContext context,
    List<StudentByInstitute> userList,
  ) async {
    String? bottomSheetCallBack = await showModalBottomSheet<String?>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
          return BulkShareBottomSheetForSingle(eventId: widget.oppCreatedByMeObj.id, onPressed: (List<String> studentsIds){
          print('studentsIds: $studentsIds');
          //  Navigator.pop(context);
           _shareButtonOnPressed(pendoState: pendoState, studentIds: studentsIds);
          });
        });

    if (bottomSheetCallBack == 'callBack') {
      String eventId = widget.oppCreatedByMeObj.id;
      final _bloc = BlocProvider.of<OpportunityShareUsersBloc>(context);
      _bloc.add(GetShareUsersFetchEvent(eventId: eventId));
    }
  }

  @override
  void dispose() {
    colorController.close();
    isSharePressedController.close();
    super.dispose();
  }

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
                //
                onPressed!();
              },
              child: Container(
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(255, 89, 100, 1),
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

  _shareButtonOnPressed({required PendoMetaDataState pendoState,required List<String> studentIds}) {
    // Map<String, dynamic> queryParameters = {
    //   'eventId': widget.info.activity!.activityId,
    //   'assigneeIds': studentIds
    // };
    ExplorePendoRepo.trackMyCreationSingleShare(
      context: context,
      assigneesIds: studentIds,
      oppIds: [widget.oppCreatedByMeObj.id],
    );

    Map<String, dynamic> body = {
      'opportunityIds': [widget.oppCreatedByMeObj.id],
      'assigneesIds': studentIds,
    };

    isSharePressedController.sink.add(true);
    _bloc.recommendActivitiesToStudents(body).then((value) async {
      isSharePressedController.sink.add(false);
      _bloc.studentList.map((e) => e.isSelected = false).toList();
      print('selectedForshare');
      studentIds.clear();
      print('student ${value.statusCode}');
      Navigator.pop(context, 'callBack');
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      setState(() {});
    });
    setState(() {});
  }

  StreamController<bool> colorController = StreamController<bool>.broadcast();
  
}
