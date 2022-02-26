import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:palette/modules/notifications_module/bloc/notifications_bloc.dart';
import 'package:palette/modules/notifications_module/models/notification_item_model.dart';
import 'package:palette/utils/custom_timeago_formatter.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

class NotificationItem extends StatelessWidget {
  final NotificationItemModel notificationItemModel;
  final Function onTap;
  final bool isRequest;
  const NotificationItem(
      {required this.notificationItemModel,
      required this.onTap,
      this.isRequest = false});

  @override
  Widget build(BuildContext context) {
    var todoApprovalRequestTypes = [
      'To-Do Approval Request',
      'To-Do Modification Request',
      'To-Do Removal Request'
    ];
    final type = todoApprovalRequestTypes.contains(notificationItemModel.type)
        ? notificationItemModel.todoType ?? ''
        : notificationItemModel.opportunityCategory ?? '';
    final image = type.startsWith('College') || type.startsWith('Education')
        ? "images/education_WM.svg"
        : type.startsWith('Job')
            ? "images/business_WM.svg"
            : _getImageStringForEvent(type: type);
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                  // height: !isRequest
                  //     ? MediaQuery.of(context).size.height * 0.09
                  //     : MediaQuery.of(context).size.height * 0.147,
                  width: MediaQuery.of(context).size.width * 0.87,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 0.2,
                        blurRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        nameRow(image),
                        // if (isRequest)
                          SizedBox(height: 10),
                        typeAndDesc(image,context)
                      ])),
            ),
            Positioned(
              top: 18,
              right: 25,
              child:  NotificationTimeAgo(notificationItemModel: notificationItemModel),),
            isRequest
                ? Positioned(
                    top: 15,
                    left: 3,
                    child: profilePicture(
                        imageUrl: notificationItemModel.profilePicture == null
                            ? ''
                            : notificationItemModel.profilePicture),
                  )
                : Positioned(
                    top: 15,
                    left: 15,
                    child: Visibility(
                      visible: !notificationItemModel.isRead,
                      child: CircleAvatar(
                        radius: 9.5,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 8,
                          foregroundColor: purpleBlue,
                          backgroundColor: purpleBlue,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
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

  Widget nameRow(String image) {
    late String notiftype =
    notificationItemModel.type == null ? '' : notificationItemModel.type;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 22),
        if (isRequest)
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 5,top: 10),
              child: Text(notificationItemModel.creatorName,
                  style: roboto700.copyWith(fontSize: 14, color: defaultDark)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5,top: 2),
              child: Text(notiftype,
                  style: roboto700.copyWith(
                    fontSize: 14,
                    color: red,
                  )),
            ),
          ]),
        // Spacer(),
        // if (!isRequest)


      ],
    );
  }

  Widget typeAndDesc(String image, BuildContext context) {
    // late String notiftype = 'Approval Request';
    late String notiftype =
        notificationItemModel.type == null ? '' : notificationItemModel.type;
    // if (notificationItemModel.type == NotificationsType.ApprovalRequest) {
    //   notiftype = 'Approval Request11';
    // } else if (notificationItemModel.type ==
    //     NotificationsType.NewConsidereation) {
    //   notiftype = 'New in Considereation';
    // } else if (notificationItemModel.type == NotificationForModule.Todo.value) {
    //   notiftype = 'New To Do';
    // }
    // print(notiftype);
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(!isRequest)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5,),
                    child: Text(notiftype,
                        style: roboto700.copyWith(
                          fontSize: 14,
                          color: red,
                        )),
                  ),
                Container(
                  height: 28,
                  child: Text(notificationItemModel.title,
                      style: robotoTextStyle.copyWith(fontSize: 12, color: pureblack),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify),
                ),
              ],
            ),
          ),
          Spacer(),
          if (isRequest)
            SvgPicture.asset(
              image,
              width: 20,
              height: 20,
              color: iconEvent,
            ),
          SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget profilePicture({required String imageUrl}) {
    return Stack(
      children: [
        if (imageUrl != null)
          CircleAvatar(
            radius: 24.6,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => CircleAvatar(
                  backgroundColor: Colors.transparent, child: Container()),
              errorWidget: (context, url, error) => Text(
                Helper.getInitials(
                  notificationItemModel.creatorName,
                ),
                style: robotoTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        Positioned(
          top: -1,
          left: 0,
          child: Visibility(
            visible: !notificationItemModel.isRead,
            child: CircleAvatar(
              radius: 9.5,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 8,
                foregroundColor: purpleBlue,
                backgroundColor: purpleBlue,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class NotificationTimeAgo extends StatelessWidget {
  const NotificationTimeAgo({
    Key? key,
    required this.notificationItemModel,
  }) : super(key: key);

  final NotificationItemModel notificationItemModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.schedule,
          size: 15,
          color: Colors.grey[500],
        ),
        SizedBox(width: 4),
        Text(
            TimeAgo.timeAgoSinceDate(DateFormat('dd-MM-yyyy hh:mma')
                .format(notificationItemModel.createdAt)),
            style: robotoTextStyle.copyWith(
                fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
