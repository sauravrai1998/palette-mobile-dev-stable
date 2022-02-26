import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/modules/auth_module/services/notification_repository.dart';
import 'package:palette/modules/comment_module/screens/comments_view.dart';
import 'package:palette/modules/comment_module/services/comment_pendo_repo.dart';
import 'package:palette/modules/notifications_module/bloc/notification_detail_bloc.dart';
import 'package:palette/modules/notifications_module/models/approval_notification_detail_model.dart';
import 'package:palette/modules/notifications_module/models/notification_item_model.dart';
import 'package:palette/modules/notifications_module/models/todo_approval_detail_model.dart';
import 'package:palette/modules/notifications_module/services/notification_pendo_repo.dart';
import 'package:palette/modules/notifications_module/services/notifications_repo.dart';
import 'package:palette/modules/comment_module/bloc/comment_bloc.dart';
import 'package:palette/modules/comment_module/model/send_comment_bloc.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_repository.dart';
import 'package:palette/modules/todo_module/widget/file_resource_card_button.dart';
import 'package:palette/utils/custom_timeago_formatter.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

import 'notification_list_screen.dart';

class TodoNotificationDetailScreen extends StatefulWidget {
  final NotificationItemModel notificationItemModel;
  final RemoveApprovalCallBack removeApprovalCallBack;
  TodoNotificationDetailScreen(
      {Key? key,
      required this.notificationItemModel,
      required this.removeApprovalCallBack})
      : super(key: key);

  @override
  _TodoNotificationDetailScreenState createState() =>
      _TodoNotificationDetailScreenState();
}

class _TodoNotificationDetailScreenState
    extends State<TodoNotificationDetailScreen> {
  // NotificationDetailBloc _bloc = NotificationDetailBloc(
  //     notificationsRepository: NotificationsRepository.instance);
  TodoNotificationDetailList? notification;
  bool isLoading = false;
  bool approvalSort = false;
  StreamController<TodoNotificationDetail> notificationStream =
      StreamController<TodoNotificationDetail>.broadcast();
  late TodoNotificationDetail notificationList;
  bool isDismiss = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return BlocBuilder<NotificationsDetailBloc, NotificationsDetailState>(
              builder: (context, state) {
            if (state is FetchNotificationsDetailTodoLoadingState) {
              print('loading');
              return _getLoadingIndicator();
            } else if (state is FetchNotificationsDetailTodoSuccessState) {
              notification = state.notificationList;
              Future.delayed(Duration(milliseconds: 300), () {
                notificationStream.sink.add(state.notificationList.modelList);
              });
              return StreamBuilder<TodoNotificationDetail>(
                  stream: notificationStream.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data != null &&
                        snapshot.connectionState == ConnectionState.active) {
                      notificationList = snapshot.data!;
                      final type = notificationList.category ?? 'Other';
                      final image = type.startsWith('College') ||
                              type.startsWith('Education')
                          ? "images/education_WM.svg"
                          : type.startsWith('Job')
                              ? "images/business_WM.svg"
                              : _getImageStringForEvent(type: type);
                      return SingleChildScrollView(
                        child: Stack(children: [
                          Column(
                            children: [
                              topRow(context),
                              SizedBox(height: 20),
                              bodyColumn(constraints, image)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                onPressed: () => Navigator.pop(context)),
                          )
                        ]),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return _getLoadingIndicator();
                    } else {
                      return Container();
                    }
                  });
            }
            return _failedStateResponseWidget();
          });
        }),
      ),
    );
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
    } else if (type == 'Education') {
      return "images/education_WM.svg";
    } else if (type == 'Employment') {
      return 'images/employment.svg';
    } else {
      return 'images/genericVM.svg';
    }
  }

  Widget _getLoadingIndicator() {
    return Center(
      child: Container(height: 38, width: 50, child: CustomPaletteLoader()),
    );
  }

  Widget _failedStateResponseWidget() {
    return Container(
      child: Center(
        child: Text(
          'Something went wrong',
          style: TextStyle(color: defaultDark),
        ),
      ),
    );
  }

  Widget topRow(BuildContext context) {
    return Container(
      height: 160,
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Spacer(),
              Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      'images/person_bookmark.svg',
                    ),
                    SizedBox(width: 10),
                  ]),
              SizedBox(height: 15),
              if (notificationList.createdAt != null)
                Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.schedule,
                        color: greyBorder,
                        size: 14,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        DateFormat('dd-MM-yyyy hh:mma').format(
                            DateTime.parse(notificationList.createdAt!)
                                .toLocal()),
                        style: TextStyle(
                          fontSize: 14,
                          color: greyBorder,
                        ),
                      ),
                    ]),
              Container(
                margin: EdgeInsets.only(top: 10),
                // width: 150,
                child: Text(
                  '${notificationList.creatorName ?? ''}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacer(),
              SizedBox(height: 5),
            ],
          ),
          SizedBox(width: 10),
          Align(
            alignment: Alignment.topRight,
            child: Container(
                width: 137,
                height: 155,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                  ),
                  color: Colors.grey,
                ),
                clipBehavior: Clip.antiAlias,
                child: notificationList.creatorProfilePic != null &&
                        notificationList.creatorProfilePic != 'null'
                    ? CachedNetworkImage(
                        imageUrl: '${notificationList.creatorProfilePic}',
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 50,
                        child: Image(
                          image: AssetImage('images/default_profile.png'),
                          fit: BoxFit.fitHeight,
                        ))),
          ),
        ],
      ),
    );
  }

  Widget bodyColumn(BoxConstraints constraints, String image) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: constraints.maxHeight - 210,
      ),
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                eventTypeContainer(image),
                SizedBox(height: 20),
                Text('${notificationList.eventName}',
                    style: montserratBoldTextStyle.copyWith(
                        fontSize: 20, color: defaultDark)),
                SizedBox(height: 10),
                if (notificationList.completeBy != null) dueDateRow(),
                if (notificationList.completeBy != null) SizedBox(height: 5),
                if (notificationList.phone != null) phoneRow(),
                if (notificationList.phone != null) SizedBox(height: 5),
                if (notificationList.venue != null) addressRow(),
                SizedBox(height: 5),
                if (notificationList.description != null) descContainer(),
              ],
            ),
            buttonRow(),
          ],
        ),
      ),
    );
  }

  Widget phoneRow() {
    return Visibility(
      visible: notificationList.phone!.isNotEmpty,
      child: Container(
        child: Row(
          children: [
            Icon(
              Icons.phone_outlined,
              color: greyBorder,
              size: 20,
            ),
            SizedBox(width: 5),
            Text(
              '${notificationList.phone}',
              style: montserratSemiBoldTextStyle.copyWith(
                  fontSize: 14, color: greyBorder),
            ),
          ],
        ),
      ),
    );
  }

  Widget dueDateRow() {
    return Visibility(
      visible: notificationList.completeBy!.isNotEmpty,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: greyBorder,
              size: 18,
            ),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DUE DATE',
                  style: montserratSemiBoldTextStyle.copyWith(
                      fontSize: 10, color: greyBorder),
                ),
                Text(
                  '${DateFormat('hh:mm a, MMMM d yyyy').format(DateTime.parse(notificationList.completeBy!).toLocal())}',
                  style: montserratSemiBoldTextStyle.copyWith(
                      fontSize: 14, color: greyBorder),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget addressRow() {
    return Visibility(
      visible: notificationList.venue!.isNotEmpty,
      child: Container(
        height: 30,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Icon(
                Icons.place_outlined,
                color: greyBorder,
                size: 20,
              ),
            ),
            SizedBox(width: 5),
            Container(
              width: 200,
              child: Text(
                '${notificationList.venue}',
                style: montserratSemiBoldTextStyle.copyWith(
                    fontSize: 14, color: greyBorder),
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget descContainer() {
    return Container(
      height: 220,
      width: 340,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Text('${notificationList.description}',
              style: montserratNormal.copyWith(
                fontSize: 18,
                color: defaultDark,
                wordSpacing: 2,
              ),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.justify),
        ),
      ),
    );
  }

  Widget eventTypeContainer(String image) {
    var eventType = 'Sports';
    // bool isTodo = widget.notificationItemModel.notificationForModule.value == 'todo';
    // String eventType = isTodo ? 'To-Do ${widget.notificationItemModel.eventType}' : '${widget.notificationItemModel.eventType} Event';
    return Container(
      // width: 180,
      height: 40,
      decoration: BoxDecoration(
        color: purpleBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 15),
          SvgPicture.asset(
            image,
            color: Colors.white,
            height: 30,
          ),
          SizedBox(width: 10),
          Text(
            '${notificationList.category}',
            style: kalamTextStyle.copyWith(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    String validUrl;
    if (url.startsWith('http') || url.startsWith('https')) {
      validUrl = url;
      launchURL(validUrl);
      return;
    } else if (!(url.startsWith('https')) || !(url.startsWith('http'))) {
      validUrl = 'http://' + url;
      launchURL(validUrl);
    }
  }

  var todoApprovalRequestTypes = [
    'To-Do Approval Request',
    'To-Do Modification Request',
    'To-Do Removal Request'
  ];

  Widget buttonRow() {
    bool isTodo =
        todoApprovalRequestTypes.contains(widget.notificationItemModel.type);
    // bool isTodo = widget.notificationItemModel.notificationForModule.value.toLowerCase() != 'todo' ;
    return Container(
      height: 60,
      width: 330,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 4,
            offset: Offset(-2, 6), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          openButton(onPressed: () {
            // _launchInBrowser(notificationList.);
          }),
          approveButton(
              onPressed: notificationList.approvalStatus == 'Approved' ||
                      notificationList.approvalStatus == 'AdvisorReview'
                  ? () {}
                  : () async {
                      ///
                      final pendoState =
                          BlocProvider.of<PendoMetaDataBloc>(context).state;
                      NotificationPendoRepo.trackApproveApprovalRequest(
                          pendoState: pendoState);
                      setState(() {
                        isLoading = true;
                      });
                      bool result = await NotificationsRepository.instance
                          .approveDismissTodoRequest(
                        status: 'Accept',
                        eventId: notificationList.id!,
                        notificationId: widget.notificationItemModel.id,
                        notificationType: widget.notificationItemModel.type,
                      );
                      if (!result) {
                        NotificationsRepository.instance
                            .approveDismissTodoRequest(
                          status: 'Reject',
                          eventId: notificationList.id!,
                          notificationId: widget.notificationItemModel.id,
                          notificationType: widget.notificationItemModel.type,
                        );

                        showDialog(
                            context: context,
                            builder: Helper.showGenericDialog(
                                title: 'Oops...',
                                body: "This event has already been approved",
                                context: context,
                                okAction: () {
                                  Navigator.pop(context);
                                  widget.removeApprovalCallBack(
                                      widget.notificationItemModel);
                                  Navigator.pop(context);
                                }));
                      } else {
                        widget.removeApprovalCallBack(
                            widget.notificationItemModel);
                        Navigator.pop(context);
                      }
                    }),
          cancelButton(
              onPressed: notificationList.approvalStatus == 'Not Approved'
                  ? () {}
                  : () async {
                final pendoState =
                    BlocProvider.of<PendoMetaDataBloc>(context).state;
                NotificationPendoRepo.trackRejectApprovalRequest(
                    pendoState: pendoState);

                setState(() {
                  isDismiss = true;
                });
                bool result = await NotificationsRepository.instance
                    .approveDismissTodoRequest(
                  status: 'Reject',
                  eventId: notificationList.id!,
                  notificationId: widget.notificationItemModel.id,
                  notificationType: widget.notificationItemModel.type,
                );
                widget.removeApprovalCallBack(
                    widget.notificationItemModel);

                if (result) {
                  Navigator.pop(context);
                }
              }),
          Visibility(visible: !isTodo, child: SizedBox(width: 20)),
          Visibility(
            visible: !isTodo,
            child: commentButton(onPressed: () {
              final pendoState =
                  BlocProvider.of<PendoMetaDataBloc>(context).state;
              CommentPendoRepo.trackViewCommentBottomSheet(
                pendoState: pendoState,
                eventId: widget.notificationItemModel.eventId.toString(),
                commentOn: "TodoRequest",
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
                        ..add(FetchComments(
                            widget.notificationItemModel.eventId)),
                      child: BlocProvider<SendCommentsBloc>(
                          create: (context) => SendCommentsBloc(
                              commentRepository:
                              RecommendRepository.instance),
                          child: CommentsView(
                            eventId: widget.notificationItemModel.eventId,
                            commentType: "Approval",
                            commentOn: "TodoRequest",
                          )));
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget openButton({required Function onPressed}) {
    return Visibility(
      visible: notificationList.website != null &&
          notificationList.website != 'null',
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Icon(
          Icons.open_in_new_rounded,
          color: pureblack,
          size: 20,
        ),
      ),
    );
  }

  Widget approveButton({required Function onPressed}) {
    return Visibility(
      visible: notificationList.approvalStatus != 'Not Approved' &&
          // notificationList.valid! &&
          notificationList.approvalStatus != 'null',
      child: GestureDetector(
        onTap: () => onPressed(),
        child: isLoading
            ? Container(
                width: 136,
                child: CustomChasingDotsLoader(
                  color: green,
                ),
              )
            : Row(children: [
                Text(
                    notificationList.approvalStatus == 'Approved' ||
                            notificationList.approvalStatus == 'AdvisorReview'
                        ? 'APPROVED'
                        : 'APPROVE',
                    style: robotoTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: neoGreen)),
                SizedBox(width: 5),
                Icon(
                  Icons.task_alt,
                  color: neoGreen,
                )
              ]),
      ),
    );
  }

  Widget cancelButton({required Function onPressed}) {
    return Visibility(
      visible: notificationList.approvalStatus != 'Approved' &&
          notificationList.approvalStatus != 'AdvisorReview' &&
          // notificationList.valid! &&
          notificationList.approvalStatus != 'null',
      child: GestureDetector(
        onTap: () => onPressed(),
        child: isDismiss
            ? Container(
                width: 60,
                child: CustomChasingDotsLoader(
                  color: red,
                ),
              )
            : Row(
                children: [
                  Text(
                      notificationList.approvalStatus == 'Not Approved'
                          ? 'REJECTED'
                          : '',
                      style: robotoTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: red)),
                  Icon(
                    Icons.cancel_outlined,
                    color: red,
                    size: 20,
                  ),
                ],
              ),
      ),
    );
  }

  Widget commentButton({required Function onPressed}) {
    return GestureDetector(
        onTap: () => onPressed(),
        child: SvgPicture.asset(
          'images/coment_icon.svg',
          color: pureblack,
          height: 20,
        ));
  }
}
