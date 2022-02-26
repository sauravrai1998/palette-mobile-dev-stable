import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/call_button.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/common_components/link_button.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/comment_module/bloc/comment_bloc.dart';
import 'package:palette/modules/comment_module/model/send_comment_bloc.dart';
import 'package:palette/modules/comment_module/screens/comments_view.dart';
import 'package:palette/modules/comment_module/services/comment_pendo_repo.dart';
import 'package:palette/modules/explore_module/blocs/event_detail_enroll_bloc/event_detail_enoll_bloc.dart';
import 'package:palette/modules/explore_module/blocs/event_detail_enroll_bloc/event_detail_enroll_states.dart';
import 'package:palette/modules/explore_module/blocs/event_detail_enroll_bloc/event_details_enroll_events.dart';
import 'package:palette/modules/explore_module/blocs/event_detail_wishlist_bloc/event_detail_wishlist_bloc.dart';
import 'package:palette/modules/explore_module/blocs/event_detail_wishlist_bloc/event_detail_wishlist_events.dart';
import 'package:palette/modules/explore_module/blocs/event_detail_wishlist_bloc/event_detail_wishlist_states.dart';
import 'package:palette/modules/explore_module/blocs/explore_bloc.dart';
import 'package:palette/modules/explore_module/blocs/explore_detail_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/add_opportunities_consideration_bloc.dart';
import 'package:palette/modules/explore_module/models/explore_list_model.dart';
import 'package:palette/modules/explore_module/models/student_list_response.dart';
import 'package:palette/modules/explore_module/services/explore_repository.dart';
import 'package:palette/modules/explore_module/widgets/add_to_todo_bottomsheet.dart';
import 'package:palette/modules/explore_module/widgets/bulk_share_bottom_sheet_single.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_repository.dart';
import 'package:palette/utils/custom_date_formatter.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/explore_pendo_repo.dart';

typedef WishListCallBack = Function(bool);
typedef EnrollCallBack = Function(bool);

class ExploreDetail extends StatefulWidget {
  final ExploreModel info;
  final ExploreListBloc exploreListBloc;
  final WishListCallBack isWishListedCallBack;
  final EnrollCallBack isEnrollCallBack;
  final String sfid;
  final String sfuuid;
  final String role;
  ExploreDetail({
    required this.info,
    required this.exploreListBloc,
    required this.isWishListedCallBack,
    required this.isEnrollCallBack,
    required this.sfid,
    required this.sfuuid,
    required this.role,
  });
  @override
  _ExploreDetailState createState() => _ExploreDetailState();
}

class _ExploreDetailState extends State<ExploreDetail> {
  ExploreDetailBloc _bloc =
      ExploreDetailBloc(exploreRepo: ExploreRepository.instance);
  final _snackBar = SnackBar(
    content: Text('Recommendation record created successfully'),
    backgroundColor: closedButtonColor,
  );

  TextEditingController searchController = TextEditingController();
  List<StudentByInstitute> copystudentList = [];
  bool isStudentsFetched = false;
  var canLaunchUrl = false;
  var canLaunchPhone = false;
  var isTopRowOpen = false;

  final decoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(22.5)),
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
  void initState() {
    super.initState();
    print('ExploreDetail initState ${widget.info.activity?.activityId}');
    _checkForUrl();
    _checkForPhone();
  }

  Future<void> _checkForPhone() async {
    if (widget.info.activity == null) return;
    if (widget.info.activity!.phone == null) return;
    canLaunchPhone = await canLaunch('tel:${widget.info.activity!.phone}');
    canLaunchPhone = canLaunchPhone &&
        widget.info.activity!.phone != null &&
        widget.info.activity!.phone!.trim().length >= 10;
    setState(() {});
  }

  Future<void> _checkForUrl() async {
    if (widget.info.activity == null) return;
    if (widget.info.activity!.website == null) return;
    canLaunchUrl = await canLaunch(widget.info.activity!.website!);
    print('canLaunchUrl: $canLaunchUrl');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: context.read<EventDetailWishlistBloc>(),
        listener: (context, state) {
          if (state is EventDetailWishlistSuccessState) {
            // widget.exploreListBloc.getExploreList();
          }
        },
        child: BlocListener(
          bloc: context.read<EventDetailEnrollBloc>(),
          listener: (context, state) {
            if (state is EventDetailEnrollSuccessState) {
              // widget.exploreListBloc.getExploreList();
            } else if (state is EventDetailEnrollErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Something went wrong"),
              ));
            }
          },
          child: TextScaleFactorClamper(
            child: Semantics(
              child: SafeArea(
                child: Stack(
                  children: [
                    Scaffold(
                        appBar: appBar(context),
                        // backgroundColor: white,
                        body: LayoutBuilder(builder: (context, constraint) {
                          return SingleChildScrollView(
                            physics: RangeMaintainingScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraint.maxHeight),
                              child: IntrinsicHeight(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 20),
                                          SizedBox(height: 10),
                                          topRow(),
                                          SizedBox(height: 10),
                                          eventTitleRow(),
                                          SizedBox(height: 50),
                                          Container(
                                            height: 320,
                                            child: Scrollbar(
                                              child: SingleChildScrollView(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: Text(
                                                    widget.info.activity!
                                                            .description ??
                                                        '',
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: montserratNormal
                                                        .copyWith(
                                                            color: defaultDark,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                      FutureBuilder<String>(
                                          future: _getPathForRegister(),
                                          builder: (context, snapshot) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                
                                                SizedBox(height: 10),
                                                if (snapshot.data != null)
                                                  BlocListener<
                                                          AddOpportunitiesToTodoBloc,
                                                          AddOpportunitiesToTodoState>(
                                                      listener:
                                                          (context, state) {
                                                        if (state
                                                                is AddOpportunitiesToTodoSuccessState ||
                                                            state
                                                                is AddOpportunitiesToTodoFailureState) {
                                                          ExploreListBloc
                                                              _bloc =
                                                              ExploreListBloc(
                                                                  exploreRepo:
                                                                      ExploreRepository
                                                                          .instance);
                                                          _bloc
                                                              .getExploreList();
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      child: buttonAtBottom(context)),
                                              ],
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })),
                    _expandableRow(context: context),
                  ],
                ),
              ),
            ),
          ),
        ));
    // return
  }

  Widget _actionRow() {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    return BlocBuilder<EventDetailEnrollBloc, EventDetailEnrollState>(
        builder: (context, state) {
      if (widget.info.enrolledEvent ||
          state is EventDetailEnrollSuccessState ||
          state is EventDetailEnrollLoadingState) {
        // return buttonAtBottom(context);
      }
      return Container(
        height: 60,
        width: 340,
        margin: EdgeInsets.only(left: 10, bottom: 10),
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
          children: [
            SizedBox(width: 20),
            addTodoBtn(context),
            Spacer(),
            _commentsButton(),
            SizedBox(width: 5),
            _shareButton(context),
            SizedBox(width: 5),
            _wishlistButton(),
            SizedBox(width: 10),
          ],
        ),
      );
    });
  }

  Widget _linkAndCallButtonRow() {
    return Builder(builder: (context) {
      final url = widget.info.activity!.website;
      final phone = widget.info.activity!.phone;
      print('openlinkbutton: $url, $phone');
      var showOpenLinkButton = false;
      var showOpenCallButton = false;

      if (url != null && url.isNotEmpty && canLaunchUrl) {
        print('openlinkbutton url true');
        showOpenLinkButton = true;
      }

      if (phone != null && phone.isNotEmpty && canLaunchPhone) {
        print('openlinkbutton phone true');
        showOpenCallButton = true;
      }

      return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
          builder: (context, pendoState) {
        return Row(
          children: [
            showOpenLinkButton
                ? openLinkButton(onTap: () {
                    _launchURL(pendoState);
                  })
                : Container(),
            SizedBox(width: 14),
            showOpenCallButton
                ? callButton(onTap: () {
                    _launchCall(
                      'tel:${widget.info.activity!.phone}',
                      pendoState,
                    );
                  })
                : Container(),
          ],
        );
      });
    });
  }

  Widget _wishlistButton() {
    return BlocBuilder<EventDetailEnrollBloc, EventDetailEnrollState>(
        builder: (context, enrolledState) {
      return BlocBuilder<EventDetailWishlistBloc, EventDetailWishlistState>(
          builder: (context, state) {
        return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
            builder: (context, pendoState) {
          return Builder(builder: (context) {
            return IgnorePointer(
              ignoring: state is EventDetailWishlistLoadingState ||
                  enrolledState is EventDetailEnrollLoadingState ||
                  widget.info.enrolledEvent,
              child: GestureDetector(
                onTap: () {
                  if (widget.info.activity!.activityId == null) return;
                  final eventId = widget.info.activity!.activityId!;
                  bool? wishList;

                  if (state is EventDetailWishlistSuccessState) {
                    wishList = !state.wishListed;
                  } else
                    wishList = !widget.info.wishListedEvent;

                  widget.isWishListedCallBack(wishList);
                  context
                      .read<EventDetailWishlistBloc>()
                      .add(EventWishlistEvent(
                        eventId: eventId,
                        wishList: wishList,
                      ));
                },
                child: Container(
                    // decoration: decoration,
                    padding: EdgeInsets.all(6),
                    height: 40,
                    width: 40,
                    child: Builder(builder: (context) {
                      if (widget.info.enrolledEvent) {
                        return Container();
                      }
                      final wishListedWidget = SvgPicture.asset(
                        "images/wishlist_fill.svg",
                        color: pureblack,
                      );

                      final unWishListedWidget = SvgPicture.asset(
                        "images/wishlist.svg",
                        color: widget.info.enrolledEvent
                            ? pureblack.withOpacity(0.5)
                            : pureblack,
                      );
                      if (state is EventDetailWishlistLoadingState) {
                        return CustomChasingDotsLoader(color: pureblack);
                      }

                      if (state is EventDetailWishlistSuccessState) {
                        print('state.wishListed: ${state.wishListed}');
                        ExplorePendoRepo.trackExploreWishlistEvent(
                            eventTitle: widget.info.activity!.name ?? '',
                            isEventWishlist: state.wishListed,
                            pendoState: pendoState);
                        if (state.wishListed) {
                          widget.isWishListedCallBack(true);
                          return wishListedWidget;
                        } else {
                          return unWishListedWidget;
                        }
                      } else {
                        if (widget.info.wishListedEvent) {
                          return wishListedWidget;
                        } else {
                          return unWishListedWidget;
                        }
                      }
                    })),
              ),
            );
          });
        });
      });
    });
  }

  Future<String> _getPathForRegister() async {
    final prefs = await SharedPreferences.getInstance();
    final String role = prefs.getString('role').toString();
    if (role == "Student") {
      return 'Student';
    } else if (role == "Observer") {
      return 'Observer';
    } else if (role == "Advisor" || role.toLowerCase() == "faculty/staff") {
      return 'Advisor';
    } else if (role == "Admin") {
      return 'Admin';
    } else {
      return 'Parent';
    }
  }

  String convertIntoString(DateTime date) {
    //6am, 8th March 2021
    print(DateFormat('hh:mm a, dd MMM yyyy').format(date));

    // =  DateFormat('yyyy-MMMM-dd').format("2021-05-14 00:00:00.000");
    var theDate = DateFormat('hh:mm a, dd MMM yyyy').format(date);
    return theDate;
  }

  @override
  void dispose() {
    colorController.close();
    isSharePressedController.close();
    _bloc.dispose();
    super.dispose();
  }

  Widget topRow() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 200),
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        width: 18,
                        height: 22,
                        child: SvgPicture.asset(
                          _getImageStringForEvent(
                              type: widget.info.activity!.category ?? ''),
                          color: iconEvent,
                        )),
                    SizedBox(
                      width: 3,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .33,
                      child: Text(
                        widget.info.activity!.category ?? '',
                        style:
                            kalam700.copyWith(color: iconEvent, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  widget.info.activity!.name ?? '',
                  style: kalam700.copyWith(
                    color: defaultDark,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget eventTitleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.info.activity!.venue != null)
          Icon(Icons.location_on_outlined, color: iconEvent),
        SizedBox(width: 3),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .50,
              child: Text(
                widget.info.activity!.venue ?? '',
                style: TextStyle(
                    color: defaultDark.withOpacity(0.50), fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Text(
              _getEventDateString(),
              style: kalamLight.copyWith(
                  color: defaultDark.withOpacity(0.50), fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  String _getEventDateString() {
    var _date = CustomDateFormatter.dateIn_DDMMMYYYY(
        widget.info.activity?.startDate ?? '');
    if (_date == '') {
      return '';
    }
    if (_date.contains('1970')) {
      return '';
    }
    return _date;
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
    } else if (type == 'Education') {
      return 'images/education.svg';
    } else {
      return 'images/genericVM.svg';
    }
  }

  String _getFirst({required String category}) {
    String first = category.split(' ').first;
    return first;
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      leading: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
          builder: (context, pendoState) {
        return IconButton(
            icon: RotatedBox(
                quarterTurns: 1,
                child: SvgPicture.asset(
                  'images/dropdown.svg',
                  semanticsLabel: "button to navigate back to list of events",
                )),
            onPressed: () {
              ExplorePendoRepo.trackNavigateBack(
                  pendoState: pendoState,
                  eventTitle: widget.info.activity!.name ?? '');
              Navigator.of(context).pop();
            });
      }),
      // title: Row(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     FutureBuilder<String>(
      //         future: _getPathForRegister(),
      //         builder: (context, snapshot) {
      //           if (snapshot.hasData) {
      //             if (snapshot.data == 'Student')
      //               return _linkAndCallButtonRow();
      //           }
      //           return Container();
      //         }),
      //   ],
      // ),
    );
  }

  void _launchURL(PendoMetaDataState state) async {
    ExplorePendoRepo.trackExploreOpenWebsiteLinkEvent(
      eventTitle: widget.info.activity!.name ?? '',
      eventWebsite: widget.info.activity!.website ?? '',
      pendoState: state,
    );
    String url = widget.info.activity!.website!;
    if (url.isNotEmpty) {
      if (await canLaunch(url)) {
        await launch(url, forceWebView: true);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  void _launchCall(String phoneNo, PendoMetaDataState pendoState) async {
    ExplorePendoRepo.trackExploreOpenContactNoEvent(
      eventTitle: widget.info.activity!.name ?? '',
      eventContactNo: widget.info.activity!.phone ?? '',
      pendoState: pendoState,
    );

    await canLaunch(phoneNo)
        ? await launch(phoneNo)
        : throw 'Could not launch $phoneNo';
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
          return BulkShareBottomSheetForSingle(
              eventId: widget.info.activity!.activityId!,
              onPressed: (students) {
                students = studentIds;
                _shareButtonOnPressed(pendoState);
              });
        });
  }

  _shareButtonOnPressed(PendoMetaDataState pendoState) {
    ExplorePendoRepo.trackExploreShareEvent(
      eventTitle: widget.info.activity!.name ?? '',
      pendoState: pendoState,
      studentList: studentIds,
    );
    // Map<String, dynamic> queryParameters = {
    //   'eventId': widget.info.activity!.activityId,
    //   'assigneeIds': studentIds
    // };

    Map<String, dynamic> body = {
      'opportunityIds': [widget.info.activity!.activityId],
      'assigneesIds': studentIds,
    };

    isSharePressedController.sink.add(true);
    _bloc.recommendActivitiesToStudents(body).then((value) async {
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

  

  bool isSharePressed = false;
  StreamController<bool> isSharePressedController =
      StreamController<bool>.broadcast();
 

  StreamController<bool> colorController = StreamController<bool>.broadcast();
  List<String> studentIds = [];
  // List<StudentByInstitute> selectedForshare = [];


 
  Widget buttonAtBottom(BuildContext context) {
    return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
        builder: (context, pendoState) {
      return FutureBuilder<String>(
          future: _getPathForRegister(),
          builder: (context, snapshot) {
            final url = widget.info.activity!.website;
            final phone = widget.info.activity!.phone;
            var showOpenLinkButton = false;
            var showOpenCallButton = false;

            if (url != null && url.isNotEmpty && canLaunchUrl) {
              showOpenLinkButton = true;
            }

            if (phone != null &&
                phone.length >= 10 &&
                phone.isNotEmpty &&
                canLaunchPhone) {
              showOpenCallButton = true;
            }

            print('snapshot.data: ${snapshot.data}');
            if (snapshot.data != null && widget.info.activity != null) {
              _bloc.getUsersListShareOpp(
                  eventId: widget.info.activity!.activityId!);
              return _actionRow();
            } else {
              return Align(
                  alignment: Alignment.bottomCenter,
                  child: BlocBuilder<EventDetailEnrollBloc,
                      EventDetailEnrollState>(
                    builder: (context, state) {
                      return IgnorePointer(
                        ignoring: (state is EventDetailEnrollSuccessState ||
                            state is EventDetailEnrollLoadingState ||
                            widget.info.enrolledEvent),

                        /// If enrolled in is true then ignore the button
                        child: GestureDetector(
                          onTap: () {
                            ExplorePendoRepo.trackExploreEnrolledEvent(
                              eventTitle: widget.info.activity!.name ?? '',
                              pendoState: pendoState,
                            );
                            print(
                                'widget.info.activity!.activityId: ${widget.info.activity!.activityId}');
                            print(
                                'widget.info.activity!.listedBy:${widget.info.activity!.listedBy}');
                            if (widget.info.activity!.activityId == null)
                              return;

                            context.read<EventDetailEnrollBloc>().add(
                                  EventEnrollEvent(
                                    opportunityId:
                                        widget.info.activity!.activityId!,
                                  ),
                                );
                          },
                          child: Container(
                            width: 202,
                            height: 40,
                            decoration: decoration.copyWith(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              border: Border.all(color: todoListActiveTab),
                            ),
                            child: Center(
                              child: Builder(builder: (context) {
                                if (state is EventDetailEnrollLoadingState) {
                                  return CustomChasingDotsLoader(
                                    color: todoListActiveTab,
                                  );
                                }
                                if (state is EventDetailEnrollSuccessState ||
                                    widget.info.enrolledEvent) {
                                  widget.isEnrollCallBack(true);
                                  return Container(
                                    alignment: Alignment.center,
                                    width: 260,
                                    height: 40,
                                    decoration: decoration,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: todoListActiveTab,
                                        ),
                                        Text(
                                          'Added to To-do',
                                          textAlign: TextAlign.center,
                                          style:
                                              montserratBoldTextStyle.copyWith(
                                            color: todoListActiveTab,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                          ),
                                          semanticsLabel: "Tap to enroll event",
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Container(
                                  alignment: Alignment.center,
                                  width: 260,
                                  height: 40,
                                  decoration: decoration,
                                  child: Text(
                                    'Add to To-do',
                                    style: montserratBoldTextStyle.copyWith(
                                      color: todoListActiveTab,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      );
                    },
                  ));
            }
          });
    });
  }

  Widget _expandableRow({required BuildContext context}) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    final url = widget.info.activity!.website;
    final phone = widget.info.activity!.phone;
    print('openlinkbutton: $url, $phone');
    var showOpenLinkButton = false;
    var showOpenCallButton = false;

    if (url != null && url.isNotEmpty && canLaunchUrl) {
      print('openlinkbutton url true');
      showOpenLinkButton = true;
    }

    if (phone != null && phone.isNotEmpty && canLaunchPhone) {
      print('openlinkbutton phone true');
      showOpenCallButton = true;
    }
    return Positioned(
      top: 5,
      right: 0,
      child: Visibility(
        visible: showOpenCallButton || showOpenLinkButton,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
          width: isTopRowOpen
              ? MediaQuery.of(context).size.width * 0.46
              : MediaQuery.of(context).size.width * 0.12,
          height: 45,
          decoration: BoxDecoration(
            color: pureblack,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: isTopRowOpen
                ? [
                    Visibility(
                      visible: showOpenCallButton,
                      child: GestureDetector(
                        onTap: () => _launchCall('tel:$phone', pendoState),
                        child: SvgPicture.asset(
                          "images/call_icon.svg",
                          color: white,
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: showOpenLinkButton,
                      child: GestureDetector(
                        onTap: () {
                          _launchURL(pendoState);
                        },
                        child: Icon(
                          Icons.launch,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isTopRowOpen = false;
                        });
                      },
                      child: SvgPicture.asset(
                        'images/close_expand_mycreat.svg',
                        height: 20,
                        width: 20,
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
        ),
      ),
    );
  }

  // Button bar widgets
  Widget addTodoBtn(BuildContext context) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    final role = pendoState.role;
    return BlocBuilder<EventDetailEnrollBloc, EventDetailEnrollState>(
      builder: (context, state) {
        return IgnorePointer(
          ignoring: (state is EventDetailEnrollSuccessState ||
              state is EventDetailEnrollLoadingState ||
              widget.info.enrolledEvent),

          /// If enrolled in is true then ignore the button
          child: GestureDetector(
            onTap: () {
              if (role.toLowerCase() != 'student') {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  isDismissible: true,
                  builder: (context) {
                    return AddTodoBottomSheet(
                      oppurtunityIds: [widget.info.activity!.activityId!],
                    );
                  },
                );
              } else {
                /// Pendo Log
                ///
                ExplorePendoRepo.trackExploreEnrolledEvent(
                  eventTitle: widget.info.activity!.name ?? '',
                  pendoState: pendoState,
                );
                context.read<EventDetailEnrollBloc>().add(
                      EventEnrollEvent(
                        opportunityId: widget.info.activity!.activityId!,
                      ),
                    );
              }
              print(
                  'widget.info.activity!.activityId: ${widget.info.activity!.activityId}');
              print(
                  'widget.info.activity!.listedBy:${widget.info.activity!.listedBy}');
              if (widget.info.activity!.activityId == null) return;
            },
            child: Center(
              child: Builder(builder: (context) {
                if (state is EventDetailEnrollLoadingState) {
                  return Container(
                    width: 136,
                    child: CustomChasingDotsLoader(
                      color: green,
                    ),
                  );
                }
                if (state is EventDetailEnrollSuccessState ||
                    widget.info.enrolledEvent) {
                  widget.isEnrollCallBack(true);
                  return Container(
                    width: 136,
                    child: Row(children: [
                      Text('Added to To-Do',
                          style: robotoTextStyle.copyWith(
                              color: neoGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                      SizedBox(width: 5),
                      Icon(Icons.done_all, color: neoGreen, size: 20)
                    ]),
                  );
                }

                return Container(
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
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _shareButton(BuildContext context) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    return StreamBuilder<List<StudentByInstitute>>(
        stream: _bloc.studentListObserver.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null &&
              snapshot.connectionState == ConnectionState.active) {
            _bloc.studentListObserver.sink.add(_bloc.studentList);
            return GestureDetector(
              onTap: () {
                ExplorePendoRepo.trackExploreOpenShareBottomSheetEvent(
                  eventTitle: widget.info.activity!.name ?? '',
                  pendoState: pendoState,
                );
                _showBottomSheet(context);
              },
              child: Container(
                width: 40,
                height: 40,
                child: Center(
                    child: SvgPicture.asset(
                  'images/share_icon.svg',
                  color: pureblack,
                  height: 20,
                  width: 20,
                )),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: 40,
              height: 40,
              child: CustomChasingDotsLoader(color: pureblack),
            );
          } else {
            return Container();
          }
        });
  }

  Widget _commentsButton() {
    return GestureDetector(
      onTap: () {
        final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
        CommentPendoRepo.trackViewCommentBottomSheet(
          pendoState: pendoState,
          eventId: widget.info.activity!.activityId!.toString(),
          commentOn: "Opportunity",
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
                  ..add(FetchComments(widget.info.activity!.activityId!)),
                child: BlocProvider<SendCommentsBloc>(
                    create: (context) => SendCommentsBloc(
                        commentRepository: RecommendRepository.instance),
                    child: CommentsView(
                      eventId: widget.info.activity!.activityId!,
                      commentType: "Generic",
                      commentOn: "Opportunity",
                    )));
          },
        );
      },
      child: Container(
        width: 40,
        height: 40,
        child: Center(
            child: SvgPicture.asset(
          'images/coment_icon.svg',
          color: pureblack,
          height: 22,
          width: 22,
        )),
      ),
    );
  }
}
