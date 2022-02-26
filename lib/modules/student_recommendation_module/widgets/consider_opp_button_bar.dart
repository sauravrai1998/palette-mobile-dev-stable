import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/comment_module/services/comment_pendo_repo.dart';
import 'package:palette/modules/explore_module/models/explore_status.dart';
import 'package:palette/modules/comment_module/screens/comments_view.dart';
import 'package:palette/modules/comment_module/bloc/comment_bloc.dart';
import 'package:palette/modules/student_recommendation_module/bloc/recommendation_bloc/consideration_detail_bloc.dart';
import 'package:palette/modules/comment_module/model/send_comment_bloc.dart';
import 'package:palette/modules/student_recommendation_module/models/user_models/recommendation_model.dart';
import 'package:palette/modules/student_recommendation_module/models/user_models/user_share_list_response.dart';
import 'package:palette/modules/student_recommendation_module/screens/recommendation_detail_screen.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_pendo_repo.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_repository.dart';
import 'package:palette/modules/student_recommendation_module/widgets/conflict_bottom_sheet.dart';
import 'package:palette/modules/student_recommendation_module/widgets/role_name_viewer.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsiderOppButtonBar extends StatefulWidget {
  const ConsiderOppButtonBar({
    Key? key,
    required this.recommendation,
    required this.rejectOpportunityCallBack,
    required this.setter,
    required this.role,
    required this.sfid,
    required this.sfuuid,
    required this.otherOptionsClickedCallback,
    required this.otherOptionsClicked,
  }) : super(key: key);

  final RecommendedByData recommendation;
  final RejectOpportunityCallBack rejectOpportunityCallBack;
  final ValueChanged<bool> setter;
  final String sfid;
  final String sfuuid;
  final bool otherOptionsClicked;
  final String role;
  final Function otherOptionsClickedCallback;

  @override
  _ConsiderOppButtonBarState createState() => _ConsiderOppButtonBarState();
}

class _ConsiderOppButtonBarState extends State<ConsiderOppButtonBar>
    with TickerProviderStateMixin<ConsiderOppButtonBar> {
  ConsiderationDetailBloc _bloc =
      ConsiderationDetailBloc(recommendRepo: RecommendRepository.instance);

  final _snackBar = SnackBar(
    content: Text('Recommendation record created successfully'),
    backgroundColor: closedButtonColor,
  );

  final decoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    color: white,
    boxShadow: [
      BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 8,
        color: Colors.black.withOpacity(0.08),
      )
    ],
  );

  @override
  void dispose() {
    colorController.close();
    isSharePressedController.close();
    _bloc.dispose();
    super.dispose();
  }

  bool clicked = false;

  void showRecommendedPopup() {
    showGeneralDialog(
      barrierLabel: 'recomendation_label',
      barrierDismissible: true,
      barrierColor: Color(0x01000000),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return TextScaleFactorClamper(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(0),
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 200,
                decoration: BoxDecoration(
                  color: defaultDark,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Recommended by,",
                      style: montserratNormal.copyWith(
                          fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 43.8,
                                  childAspectRatio: 1 / 4,
                                  crossAxisSpacing: 5.8,
                                  mainAxisSpacing: 0),
                          itemBuilder: (context, ind) {
                            return NameAndRoleViwer(
                                name: widget
                                    .recommendation.recommendedBy[ind].name,
                                role: widget
                                    .recommendation.recommendedBy[ind].role);
                          },
                          itemCount: widget.recommendation.recommendedBy.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0.2)).animate(anim1),
          child: child,
        );
      },
    ).then((value) {
      setState(() {
        clicked = !clicked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _bloc.getUserList(eventId: widget.recommendation.event!.id!);
    return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
        builder: (context, pendoState) {
      return Container(
        height: 60,
        width: 350,
        margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0.5,
              blurRadius: 4,
              offset: Offset(-2, 6), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 2,
            ),
            _recommendedByButton(pendoState),
            SizedBox(
              width: 2,
            ),
            commentBottomSheet(eventId: widget.recommendation.event!.id!),
            SizedBox(
              width: 2,
            ),
            _shareButton(context),
            SizedBox(width: 2),
            Container(
              height: 6,
              width: 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(1.0), bottom: Radius.circular(1.0)),
                  color: Color(0xFFE4E4E4)),
            ),
            SizedBox(width: 2),
            _addToTodoButton(pendoState),
            SizedBox(width: 2),
            _rejectButton(pendoState),
            SizedBox(
              width: 2,
            ),
          ],
        ),
      );
    });
  }

  StreamController<bool> colorController = StreamController<bool>.broadcast();
  List<String> studentIds = [];
  bool isSharePressed = false;
  StreamController<bool> isSharePressedController =
      StreamController<bool>.broadcast();

  Widget _userListItem({
    required ShareUserByInstitute stu,
    required int index,
  }) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(left: 22, right: 22, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: stu.status == ExploreStatus.Enrolled.value ||
                stu.status == ExploreStatus.Recommended.value
            ? Colors.grey[100]
            : _bloc.studentList[index].isSelected == true
                ? defaultDark
                : shareBackground,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 9,
          ),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(width: 2, color: defaultDark)),
            child: stu.profilePicture != null
                ? CachedNetworkImage(
                    imageUrl: stu.profilePicture ?? '',
                    imageBuilder: (context, imageProvider) => Container(
                      width: 59,
                      height: 59,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircleAvatar(
                        radius:
                            // widget.screenHeight <= 736 ? 35 :
                            29,
                        backgroundColor: Colors.white,
                        child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Center(child: Text(Helper.getInitials(stu.name!))),
                  )
                : Center(
                    child: Text(Helper.getInitials(stu.name!),
                        style: kalamLight.copyWith(
                          color: defaultDark,
                        ))),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stu.name!,
                style: roboto700.copyWith(
                    color: _bloc.studentList[index].isSelected == true
                        ? Colors.white
                        : defaultDark,
                    fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(stu.role!,
                      style: roboto700.copyWith(
                          color: _bloc.studentList[index].isSelected == true
                              ? Colors.white
                              : defaultDark,
                          fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1)),
              SizedBox(
                height: 2,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 4,
                    ),
                    Container(
                        child: Text(
                            stu.status == ExploreStatus.Disinterest.value
                                ? ExploreStatus.Disinterest.name
                                : stu.status! == 'Open'
                                    ? ''
                                    : stu.status!,
                            style: roboto700.copyWith(
                                color:
                                    _bloc.studentList[index].isSelected == true
                                        ? Colors.white
                                        : defaultDark,
                                fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1)),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget userListData(ScrollController scrollController) {
    if (_bloc.studentList.length > 0) {
      return Builder(builder: (context) {
        return Stack(
          children: [
            TextScaleFactorClamper(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                    itemCount: _bloc.studentList.length,
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      ShareUserByInstitute stu = _bloc.studentList[index];
                      ShareUserByInstitute stuUpdated =
                          _bloc.studentList[index];
                      return InkWell(
                        onTap: stu.status == ExploreStatus.Enrolled.value ||
                                stu.status == ExploreStatus.Recommended.value ||
                                stu.status == ExploreStatus.CantShare.value
                            ? null
                            : () {
                                print('selectedForshare ${stu.name}');

                                final studentToSelect =
                                    _bloc.studentList[index];
                                if (studentToSelect.isSelected == false) {
                                  studentIds.add(stu.id!);
                                  studentToSelect.isSelected = true;
                                  // selectedForshare.add(studentToSelect);
                                  colorController.sink.add(true);
                                } else if (studentToSelect.isSelected == true) {
                                  studentToSelect.isSelected = false;
                                  studentIds.remove(stu.id!);
                                  // selectedForshare.removeWhere((element) => element.id == studentToSelect.id);
                                  colorController.sink.add(false);
                                }
                              },
                        child: _userListItem(stu: stu, index: index),
                      );
                    }),
              ),
            ),
          ],
        );
      });
    } else
      return Container();
  }

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

  _shareButtonOnPressed(PendoMetaDataState pendoState) {
    // ExplorePendoRepo.trackExploreShareEvent(
    //   eventTitle: widget.info.activity!.name ?? '',
    //   pendoState: pendoState,
    //   studentList: studentIds,
    // );
    Map<String, dynamic> queryParameters = {
      'opportunityIds': [widget.recommendation.event!.id!],
      'assigneesIds': studentIds
    };
    isSharePressedController.sink.add(true);
    _bloc.recommendConsiderationToUsers(queryParameters).then((value) async {
      isSharePressedController.sink.add(false);
      _bloc.studentList.map((e) => e.isSelected = false).toList();
      print('selectedForshare');
      studentIds.clear();
      print('student ${value.statusCode}');
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      setState(() {});
    });
    setState(() {});
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StreamBuilder<bool>(
              stream: colorController.stream,
              builder: (context, snapshot) {
                return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                    builder: (context, pendoState) {
                  return DraggableScrollableSheet(
                      initialChildSize: 0.7,
                      maxChildSize: 0.95, // full screen on scroll
                      minChildSize: 0.5,
                      builder: (context, scrollController) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          child: Stack(
                            children: [
                              ListView(
                                controller: scrollController,
                                children: [
                                  Center(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 5, bottom: 15),
                                      height: 4,
                                      width: 42,
                                      color: defaultDark,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    height: 70,
                                    width: 200,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                            backgroundColor: white,
                                            radius: 30,
                                            child:
                                                Image.asset('images/TAWS.png')),
                                        SizedBox(width: 10),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .7,
                                          child: Text(
                                            'TAWS - Tranzed Academy For Working Students',
                                            style: roboto700.copyWith(
                                                fontSize: 16,
                                                color: defaultDark
                                                    .withOpacity(0.5)),
                                            maxLines: 2,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  userListData(scrollController),
                                ],
                              ),
                              Positioned(
                                  bottom: 30,
                                  right: 30,
                                  child: studentIds.isEmpty
                                      ? Container()
                                      : floatingShareActionButtons(
                                          image: 'share.svg',
                                          onPressed: () {
                                            _shareButtonOnPressed(pendoState);
                                          }))
                            ],
                          ),
                        );
                      });
                });
              });
        });
  }

  Widget _shareButton(BuildContext context) {
    return StreamBuilder<List<ShareUserByInstitute>>(
        stream: _bloc.userListObserver.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null &&
              snapshot.connectionState == ConnectionState.active) {
            _bloc.userListObserver.sink.add(_bloc.studentList);
            return GestureDetector(
              onTap: () {
                _showBottomSheet(context);
              },
              child: SvgPicture.asset(
                'images/share_mycreation.svg',
                height: 16,
                width: 16,
                color: defaultDark,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(pureblack),
                strokeWidth: 2.5,
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Widget conflictButton() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return ConflictBottomSheet();
            },
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            backgroundColor: Colors.black54,
            elevation: 2);
      },
      child: SvgPicture.asset(
        'images/conflict_icon.svg',
        color: defaultDark,
      ),
    );
  }

  Widget _addToTodoButton(PendoMetaDataState pendoState) {
    return GestureDetector(
        onTap: () {
          Helper.showAcceptRejectDialog(
              body: 'Are you sure you want to accept this recommendation?',
              context: context,
              okAction: () async {
                bool result =
                    await RecommendRepository.instance.acceptRecommendation(
                  Ids: widget.recommendation.id,
                );
                if (!result) {
                  RecommendRepository.instance
                      .rejectRecommendation(id: widget.recommendation.id);
                  Navigator.pop(context);

                  showDialog(
                      context: context,
                      builder: Helper.showGenericDialog(
                          title: 'Oops...',
                          body:
                              "This event has already been added to your todo list",
                          context: context,
                          okAction: () {
                            Navigator.pop(context);
                            widget.rejectOpportunityCallBack(
                                widget.recommendation);
                            Navigator.pop(context);
                          }));
                } else {
                  RecommendationPendoRepo.trackAcceptRecommendation(
                      pendoState: pendoState,
                      event: widget.recommendation.event);
                  final prefs = await SharedPreferences.getInstance();
                  String? studentId = prefs.getString(sfidConstant);
                  final bloc = BlocProvider.of<TodoListBloc>(context);
                  bloc.add(TodoListEvent(studentId: studentId!));
                  Navigator.pop(context);
                  widget.rejectOpportunityCallBack(widget.recommendation);
                  Navigator.pop(context);
                }
                // final bloc = BlocProvider.of<RecommendationBloc>(context);
                // bloc.add(GetRecommendation());
              },
              cancel: () {
                Navigator.pop(context);
              });
        },
        child: Container(
          width: 118,
          child: Row(children: [
            Text('Add to To-Do',
                style: robotoTextStyle.copyWith(
                    color: neoGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
            SizedBox(width: 5),
            Icon(Icons.done_all, color: neoGreen, size: 20)
          ]),
        ));
  }

  Widget _recommendedByButton(PendoMetaDataState pendoState) {
    return GestureDetector(
        onTap: () {
          setState(() {
            clicked = !clicked;
          });
          showRecommendedPopup();
          RecommendationPendoRepo.trackTappingRecommendedByButton(
              recommendedBy: widget.recommendation.recommendedBy
                  .map((e) => e.name)
                  .toList(),
              pendoState: pendoState,
              event: widget.recommendation.event);
        },
        child: SvgPicture.asset(
          "images/recommended_by.svg",
          height: 16,
          width: 16,
          color: defaultDark,
        ));
  }

  Widget _rejectButton(PendoMetaDataState pendoState) {
    return GestureDetector(
      onTap: () {
        final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
        Helper.showAcceptRejectDialog(
            body: 'Are you sure you want to reject this recommendation?',
            context: context,
            okAction: () async {
              bool result = await RecommendRepository.instance
                  .rejectRecommendation(id: widget.recommendation.id);
              widget.rejectOpportunityCallBack(widget.recommendation);

              if (result) {
                RecommendationPendoRepo.trackRejectRecommendation(
                    pendoState: pendoState, event: widget.recommendation.event);
              }
              Navigator.pop(context);

              Navigator.pop(context);
            },
            cancel: () {
              Navigator.pop(context);
            });
      },
      child: SvgPicture.asset(
        'images/dismiss_icon.svg',
        color: Color(0xFFB62931),
      ),
    );
  }
}

class commentBottomSheet extends StatefulWidget {
  final String eventId;
  commentBottomSheet({required this.eventId});

  @override
  _commentBottomSheetState createState() => _commentBottomSheetState();
}

class _commentBottomSheetState extends State<commentBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final pendoState =
            BlocProvider.of<PendoMetaDataBloc>(context).state;
        CommentPendoRepo.trackViewCommentBottomSheet(
          pendoState: pendoState,
          eventId: widget.eventId.toString(),
          commentOn: "Consideration",
        );
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return BlocProvider<CommentsBloc>(
                  create: (context) => CommentsBloc(
                      commentRepository: RecommendRepository.instance)
                    ..add(FetchComments(widget.eventId)),
                  child: BlocProvider<SendCommentsBloc>(
                      create: (context) => SendCommentsBloc(
                          commentRepository: RecommendRepository.instance),
                      child: CommentsView(
                        eventId: widget.eventId,
                        commentType: "Generic",
                        commentOn: "Consideration",
                      )));
            },
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            backgroundColor: Colors.transparent,
            elevation: 2);
      },
      child: SvgPicture.asset(
        'images/comment_mycreation.svg',
        height: 16,
        width: 16,
        color: defaultDark,
      ),
    );
  }
}
