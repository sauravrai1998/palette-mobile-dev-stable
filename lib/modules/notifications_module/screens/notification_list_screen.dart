import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/modules/notifications_module/bloc/notification_detail_bloc.dart';
import 'package:palette/modules/notifications_module/bloc/notifications_bloc.dart';
import 'package:palette/modules/notifications_module/bloc/read_all_notification_bloc.dart';
import 'package:palette/modules/notifications_module/bloc/single_read_notification_bloc.dart';
import 'package:palette/modules/notifications_module/models/notification_item_model.dart';
import 'package:palette/modules/notifications_module/screens/notification_detail_screen.dart';
import 'package:palette/modules/notifications_module/screens/todo_notification_detail_screen.dart';
import 'package:palette/modules/notifications_module/services/notification_pendo_repo.dart';
import 'package:palette/modules/notifications_module/services/notifications_repo.dart';
import 'package:palette/modules/notifications_module/widgets/notification_item.dart';
import 'package:palette/utils/konstants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef void RemoveApprovalCallBack(NotificationItemModel notificationItem);

typedef void NotificationCounterCallBack(int counter);

class NotificationListScreen extends StatefulWidget {
  final NotificationCounterCallBack? counterCallback;
  NotificationListScreen({this.counterCallback});

  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  NotificationListModel? notification;
  bool isLoading = false;
  bool approvalSort = false;
  StreamController<List<NotificationItemModel>> notificationStream =
      StreamController<List<NotificationItemModel>>.broadcast();
  List<NotificationItemModel> notificationList = [];
  List<NotificationItemModel> approvalList = [];
  String? failedError;
  int counter = 0;
  bool approvalUnread = false;
  String role = "student";

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  getRole() async {
    final prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role')!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getRole();
  }

  void _onRefresh() async {
    // isFilterOn = false;
    // filterCheckboxHeadingList =
    //  getFilterCheckboxHeadingList(listedByNames: listedByNames);
    final bloc = context.read<NotificationsBloc>();
    bloc.add(
      FetchNotifications(),
    );
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  var approvalRequestTypes = [
    'Opportunity Approval Request',
    'Opportunity Modification Request',
    'Opportunity Removal Request',
    'To-Do Approval Request',
    'To-Do Modification Request',
    'To-Do Removal Request'
  ];
  var todoApprovalRequestTypes = [
    'To-Do Approval Request',
    'To-Do Modification Request',
    'To-Do Removal Request'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: PreferredSize(preferredSize: Size.fromHeight(120.0),
        //   child: role.toLowerCase() == 'admin' || role.toLowerCase() == 'advisor'
        //     ? topRowForAdvisorAdmin(context)
        //     : topRow(context),),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: WaterDropHeader(
            waterDropColor: defaultDark,
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: Column(
            children: [
              role.toLowerCase() == 'admin' || role.toLowerCase() == 'advisor'
                  ? topRowForAdvisorAdmin(context)
                  : topRow(context),
              bodyWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyWidget(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SingleNotificationsBloc>(
          create: (context) => SingleNotificationsBloc(
              notificationsRepository: NotificationsRepository.instance),
        ),
      ],
      child: BlocListener(
        bloc: context.read<NotificationsBloc>(),
        listener: (BuildContext context, state) {
          if (state is FetchNotificationsSuccessState) {
            state.notificationList.modelList!.forEach((element) {
              if (!element.isRead) {
                counter++;
              }
            });
            setState(() {});
            print(counter);
          }
        },
        child: BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
          if (state is FetchNotificationsLoadingState) {
            print('loading');
            return _getLoadingIndicator();
          } else if (state is FetchNotificationsSuccessState) {
            // setState(() {
            notification = state.notificationList;
            approvalList = notification!.modelList!
                .where((element) => approvalRequestTypes.contains(element.type))
                .toList();
            approvalUnread =
                approvalList.any((element) => element.isRead == false);
            // notification!.modelList!.forEach((element) {
            //   if (!element.isRead) counter++;
            // });
            // print('counter: $counter');
            Future.delayed(Duration(milliseconds: 300), () {
              if (!approvalSort) {
                notificationStream.sink.add(state.notificationList.modelList!);
              } else {
                notificationStream.sink.add(approvalList);
              }
            });
            isLoading = false;
            // });
            return StreamBuilder<List<NotificationItemModel>>(
                stream: notificationStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.data != null &&
                      snapshot.data!.isNotEmpty &&
                      snapshot.connectionState == ConnectionState.active) {
                    notificationList = snapshot.data!;
                    notificationList
                        .sort((b, a) => a.createdAt.compareTo(b.createdAt));
                    return Expanded(
                      child: ListView.builder(
                        itemCount: notificationList.length,
                        itemBuilder: (context, index) {
                          return NotificationItem(
                            isRequest: approvalRequestTypes.contains(notificationList[index].type),
                            notificationItemModel: notificationList[index],
                            onTap: () async {
                              if (!notificationList[index].isRead) {
                                setState(() {
                                  notificationList[index].isRead = true;
                                  approvalUnread = notificationList.any(
                                      (element) => element.isRead == false);
                                  print('ontap: $counter');
                                });
                                counter--;
                                widget.counterCallback!(counter);
                                context.read<SingleNotificationsBloc>().add(
                                    ReadNotification(
                                        notificationList[index].id));
                              }
                              if (approvalRequestTypes
                                  .contains(notificationList[index].type) && (role.toLowerCase() == 'admin' || role.toLowerCase() == 'advisor')) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return todoApprovalRequestTypes.contains(notificationList[index].type)?
                                  BlocProvider<NotificationsDetailBloc>(
                                    create: (context) =>
                                    NotificationsDetailBloc(
                                        notificationsRepository:
                                        NotificationsRepository
                                            .instance)
                                      ..add(FetchDetailTodoNotifications(
                                          notificationList[index].eventId,notificationList[index].id)),
                                    child: TodoNotificationDetailScreen(
                                      notificationItemModel:
                                      notificationList[index],
                                      removeApprovalCallBack: (data) {
                                        // print('data.event!.id ${data.eventId}');
                                        // notification!.modelList!.removeWhere((element) {
                                        //   print('element.event!.id ${element.eventId}');
                                        //   return element.eventId == data.eventId;
                                        // });
                                        // setState(() =>
                                        // counter--);
                                        // notificationList =
                                        // notification!.modelList!;
                                        // notificationStream.sink.add(notificationList);
                                      },
                                    ),
                                  ):
                                  BlocProvider<NotificationsDetailBloc>(
                                    create: (context) =>
                                        NotificationsDetailBloc(
                                            notificationsRepository:
                                                NotificationsRepository
                                                    .instance)
                                          ..add(FetchDetailNotifications(
                                              notificationList[index].eventId,notificationList[index].id,todoApprovalRequestTypes.contains(notificationList[index].type))),
                                    child: NotificationDetailScreen(
                                      notificationItemModel:
                                          notificationList[index],
                                      removeApprovalCallBack: (data) {
                                        // print('data.event!.id ${data.eventId}');
                                        // notification!.modelList!.removeWhere((element) {
                                        //   print('element.event!.id ${element.eventId}');
                                        //   return element.eventId == data.eventId;
                                        // });
                                        // setState(() =>
                                        // counter--);
                                        // notificationList =
                                        // notification!.modelList!;
                                        // notificationStream.sink.add(notificationList);
                                      },
                                    ),
                                  );
                                }));
                              }
                            },
                          );
                        },
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return _getLoadingIndicator();
                  } else
                    return _failedStateResponseWidget();
                });
          } else if (state is FetchNotificationsFailureState) {
            return _failedStateResponseWidget();
          }
          return SizedBox();
        }),
      ),
    );
  }

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
            'No notification found',
            style: TextStyle(color: defaultDark),
          ),
        ),
      ),
    );
  }

  Widget topRow(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.only(top: 20,left: 35),
      child: Column(
        children: [
          Row(children: [
            // IconButton(
            //   icon: Icon(Icons.arrow_back_ios),
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // ),
            Expanded(
              child: Text('Notifications', style: roboto700),
            ),
            if (counter > 0)
              TextButton(
                onPressed: () async {
                  final pendoState =
                      BlocProvider.of<PendoMetaDataBloc>(context).state;
                  NotificationPendoRepo.trackMarkAllNotificationsRead(
                      pendoState: pendoState);
                  setState(() {
                    notificationList.forEach((element) {
                      element.isRead = true;
                    });
                  });
                  context
                      .read<AllNotificationsBloc>()
                      .add(ReadAllNotifications());
                  counter = 0;
                  widget.counterCallback!(counter);
                },
                style: ButtonStyle(
                  splashFactory: InkRipple.splashFactory,
                  overlayColor: MaterialStateProperty.all<Color>(
                    purpleBlue.withAlpha(80),
                  ),
                ),
                child: Text("Mark all as read",
                    style: roboto700.copyWith(color: purpleBlue, fontSize: 16)),
              ),
            SizedBox(width: 10),
          ]),
        ],
      ),
    );
  }

  Widget topRowForAdvisorAdmin(BuildContext context) {
    return Container(
      height: 98,
      margin: EdgeInsets.only(top: 20,left: 35),
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // IconButton(
            //   icon: Icon(Icons.arrow_back_ios),
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text('Notifications',
                  style: roboto700.copyWith(fontSize: 20, color: pureblack)),
            ),
            Spacer(),
            Column(
              children: [
                apporvalSortButton(isRead: approvalUnread),
                if (counter > 0)
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        notificationList.forEach((element) {
                          element.isRead = true;
                        });
                      });
                      context
                          .read<AllNotificationsBloc>()
                          .add(ReadAllNotifications());
                      counter = 0;
                      widget.counterCallback!(counter);
                    },
                    child: Text("Mark all as read",
                        style: roboto700.copyWith(
                            color: purpleBlue, fontSize: 16)),
                  ),
              ],
            ),
            SizedBox(width: 10),
          ]),
        ],
      ),
    );
  }

  Widget apporvalSortButton({required bool isRead}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          approvalSort = !approvalSort;
        });
      },
      child: Stack(
        children: [
          Container(
            height: 40,
            width: 100,
            margin: EdgeInsets.only(top: 10),
            decoration: !approvalSort
                ? BoxDecoration(
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20))
                : BoxDecoration(
                    gradient:
                        LinearGradient(colors: [purpleBlue, Color(0xFF996DF8)]),
                    borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Text('Approvals',
                    style: roboto700.copyWith(
                        color: !approvalSort ? purpleBlue : Colors.white,
                        fontSize: 14))),
          ),
          Visibility(
            visible: isRead,
            child: Positioned(
              top: 0,
              right: 2,
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
      ),
    );
  }
}
