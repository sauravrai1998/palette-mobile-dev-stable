import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/custom_circular_indicator.dart';
import 'package:palette/common_components/notifications_bell_icon.dart';
import 'package:palette/modules/bottom_navbar/bloc/bottom_navbar_bloc.dart';
import 'package:palette/modules/bottom_navbar/bloc/bottom_navbar_states.dart';
import 'package:palette/modules/bottom_navbar/widgets/bottom_navigation_bar.dart';
import 'package:palette/modules/chat_module/screens/chat_history_screen.dart';
import 'package:palette/modules/notifications_module/bloc/notifications_bloc.dart';
import 'package:palette/modules/notifications_module/screens/notification_list_screen.dart';
import 'package:palette/modules/notifications_module/services/notifications_repo.dart';
import 'package:palette/modules/observer_dashboard_module/screens/observer_dashboard.dart';
import 'package:palette/modules/profile_module/models/user_models/observer_profile_user_model.dart';
import 'package:palette/modules/student_dashboard_module/widgets/unread_counter_empty_widget.dart';
import 'package:palette/utils/konstants.dart';

import 'home_page_oberver.dart';

class ObserverDashboardWithNavbar extends StatefulWidget {
  final ObserverProfileUserModel? observer;
  ObserverDashboardWithNavbar({this.observer});

  @override
  _ObserverDashboardWithNavbarState createState() =>
      _ObserverDashboardWithNavbarState();
}

class _ObserverDashboardWithNavbarState
    extends State<ObserverDashboardWithNavbar>
    with SingleTickerProviderStateMixin {
  int pageIndex = 0;

  late Animation animation;
  late AnimationController _animationController;
  IconData icon = Icons.arrow_back_ios;
  String text = "Notifications";
  bool right = false;
  var radius = BorderRadius.only(topLeft: Radius.circular(20));
  var align = Alignment.centerLeft;
  bool reverse = false;

  bool onHorizontalDragStart = false;
  int unreadNotifCounter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    unreadMessageCountMapStreamController =
        StreamController<Map<String, int>>.broadcast();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750))
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                icon = Icons.arrow_forward_ios;
                text = "My Profile";
                right = !right;
                radius = BorderRadius.only(topRight: Radius.circular(20));
                align = Alignment.centerRight;
                reverse = true;
              });
            } else if (status == AnimationStatus.dismissed) {
              setState(() {
                icon = Icons.arrow_back_ios;
                text = "Notifications";
                radius = BorderRadius.only(topLeft: Radius.circular(20));
                align = Alignment.centerLeft;
                reverse = false;
              });
            }
          });

    animation = new Tween(
      begin: 0,
      end: 1.0,
    ).animate(
        new CurvedAnimation(parent: _animationController, curve: SineCurve()));
  }

  void toggle() {
    _animationController.isDismissed
        ? _animationController.forward()
        : _animationController.reverse();
  }

  void onChanged() {
    setState(() {
      onHorizontalDragStart = !onHorizontalDragStart;
    });
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      BlocProvider<NotificationsBloc>(
          create: (context) => NotificationsBloc(
              notificationsRepository: NotificationsRepository.instance)
            ..add(FetchNotifications()),
          child: ObserverDashboard(observer: widget.observer)),
      Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: ChatHistoryScreen(),
      ),
      Container()
    ];

    double maxSlide = MediaQuery.of(context).size.width;
    bool _canBeDragged = false;

    void _onDragStart(DragStartDetails details) {
      bool isDragOpenFromLeft = _animationController.isDismissed;
      bool isDragCloseFromRight = _animationController.isCompleted;
      _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
      /*if(_animationController.value > 0.5){
        onChanged();
      }*/
    }

    void _onDragUpdate(DragUpdateDetails details) {
      if (_canBeDragged) {
        double delta = details.primaryDelta! / maxSlide;
        _animationController.value -= delta;
      }
    }

    void _onDragEnd(DragEndDetails details) {
      //I have no idea what it means, copied from Drawer
      double _kMinFlingVelocity = 365.0;
      //onHorizontalDragStart = !onHorizontalDragStart;

      if (_animationController.isDismissed ||
          _animationController.isCompleted) {
        return;
      }
      if (reverse) {
        if (_animationController.value < 0.75) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
      } else {
        if (_animationController.value > 0.25) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    }

    return BlocProvider<NotificationsBloc>(
      create: (context) => NotificationsBloc(
          notificationsRepository: NotificationsRepository.instance)
        ..add(FetchNotifications()),
      child: SafeArea(
        child: Scaffold(
          body: Stack(children: [
            AnimatedBuilder(
                animation: _animationController,
                builder: (context, _) {
                  double slide = maxSlide * _animationController.value;
                  return Stack(children: [
                    Transform(
                      transform: Matrix4.identity()..translate(-slide),
                      child: dashboardSection(pages),
                    ),
                    Transform.translate(
                      offset:
                          Offset(maxSlide * (1 - _animationController.value), 0),
                      child: notificationSection(),
                    ),
                  ]);
                }),
            draggableButton(maxSlide, _onDragStart, _onDragUpdate, _onDragEnd),
          ]),
        ),
      ),
    );
  }

  Positioned draggableButton(double maxSlide, void _onDragStart(DragStartDetails details), void _onDragUpdate(DragUpdateDetails details), void _onDragEnd(DragEndDetails details)) {
    return Positioned(
          bottom: 0,
          right: 0,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              double slide = animation.value == 1
                  ? 0
                  : (maxSlide -110) * animation.value;
              
              
              return GestureDetector(
                onTap: toggle,
                onHorizontalDragStart: _onDragStart,
                onHorizontalDragUpdate: _onDragUpdate,
                onHorizontalDragEnd: _onDragEnd,
                child: Container(
                  alignment: align,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  margin: !_animationController.isCompleted
                      ? _animationController.value > 0.5
                          ? EdgeInsets.only(right: maxSlide - slide -110)
                          : EdgeInsets.only(right: 0)
                      : EdgeInsets.only(right: maxSlide -110),
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    color: Color(0xFF525252),
                  ),
                  width: animation.isCompleted ?110 : slide +110,
                  height: 60,
                  child: animation.isCompleted
                      ? Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            SvgPicture.asset(
                              'images/person_black.svg',
                              color: defaultLight,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            RotatedBox(
                              quarterTurns: 45,
                              child: SvgPicture.asset(
                                'images/arrow_up.svg',
                                color: defaultLight,
                              ),
                            )
                            // animation.isCompleted?Container():Column(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: [
                            //     SizedBox(
                            //       height: 10,
                            //     ),
                            //     SizedBox(
                            //       height: 7,
                            //     ),
                            //     SizedBox(
                            //       width: 64,
                            //       child: Text('$text',style: TextStyle(
                            //           fontSize: 10,fontWeight: FontWeight.bold
                            //       ),),
                            //     )
                            //   ],
                            // ),
                          ],
                        )
                      : Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            RotatedBox(
                              quarterTurns: -45,
                              child: SvgPicture.asset(
                                'images/arrow_up.svg',
                                color: defaultLight,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 40,
                              child: BlocListener(
                                bloc: context.read<NotificationsBloc>(),
                                listener: (BuildContext context, state) {
                                  if (state
                                      is FetchNotificationsSuccessState) {
                                    state.notificationList.modelList!
                                        .forEach((element) {
                                      if (!element.isRead) {
                                        unreadNotifCounter++;
                                      }
                                    });
                                    setState(() {});
                                    print(unreadNotifCounter);
                                  }
                                },
                                child: NotificationBellButton(
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => BlocProvider<
                                      //             NotificationsBloc>(
                                      //             create: (context) => NotificationsBloc(
                                      //                 notificationsRepository:
                                      //                 NotificationsRepository
                                      //                     .instance)
                                      //               ..add(
                                      //                   FetchNotifications()),
                                      //             child:
                                      //             NotificationListScreen(counterCallback: (counter) {
                                      //               setState(() {
                                      //                 unreadNotifCounter = counter;
                                      //               });
                                      //             },))));
                                      // print(
                                      //     'Bell ring ring ring...');
                                    },
                                    icon: Icons.notifications_outlined,
                                    notificationCount: unreadNotifCounter),
                              ),
                            ),
                            if(slide > 120)
                            // Text(right?'My Profile':'Notification'),
                              animation.isCompleted?Container():Container(
                                padding: EdgeInsets.only(left: 60),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    SizedBox(
                                      // width: 64,
                                      child: Text('$text',style: roboto700.copyWith(fontSize: 22,color: Colors.white),),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                ),
              );
            },
          ),
        );
  }

  Stack notificationSection() {
    return Stack(children: [
                    NotificationListScreen(
                      counterCallback: (counter) {
                        setState(() {
                          unreadNotifCounter = counter;
                        });
                      },
                    )
                  ]);
  }

  Stack dashboardSection(List<dynamic> pages) {
    return Stack(
                    children: [
                      BlocBuilder<BottomNavbarBloc, BottomNavbarState>(
                        builder: (context, state) {
                          if (state is InitialBottomNavbarState) {
                            pageIndex = 0;
                            return pages[pageIndex];
                          } else if (state is BottomNavbarLoadingState) {
                            return _getLoadingIndicator();
                          } else if (state is BottomNavbarSuccessState) {
                            pageIndex = state.indexValue;
                            return pages[pageIndex];
                          } else if (state is BottomNavbarFailedState) {
                            return _getErrorLabel();
                          }
                          return Container();
                        },
                      ),
                      UnreadCounterEmptyWidget(),
                      BlocBuilder<BottomNavbarBloc, BottomNavbarState>(
                          builder: (context, state) {
                        return StreamBuilder(
                            stream:
                                unreadMessageCountMapStreamController.stream,
                            builder: (context, snapshot) {
                              var unreadCounter = 0;
                              if (snapshot.hasData) {
                                final data =
                                    snapshot.data! as Map<String, int>;

                                data.forEach((key, value) {
                                  unreadCounter += value;
                                });
                              }

                              var chatIconString =
                                  'images/chat_icon_nav_bar.svg';

                              if (unreadCounter > 0) {
                                chatIconString =
                                    'images/unread_chat_icon_nav_bar.svg';
                              }
                              if (state is BottomNavbarSuccessState) {
                                if (state.indexValue == 1) {
                                  if (unreadCounter > 0) {
                                    chatIconString = 'images/unread_enabled_chat_icon_nav_bar.svg';
                                  } else {
                                    chatIconString = 'images/chat_icon_nav_bar.svg';
                                  }
                                } else {
                                  if (unreadCounter > 0) {
                                    chatIconString =
                                        'images/unread_chat_icon_nav_bar.svg';
                                  } else {
                                    chatIconString =
                                        'images/chat_icon_nav_bar.svg';
                                  }
                                }
                              }

                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: BlocBuilder<BottomNavbarBloc,
                                    BottomNavbarState>(
                                  builder: (context, state) {
                                    if (state is InitialBottomNavbarState) {
                                      pageIndex = 0;
                                      return Container(
                                        height: 60,
                                        child: BottomNavBar(
                                          isParent: true,
                                          bottomNavBarIconNames: [
                                            'images/person_black.svg',
                                            chatIconString,
                                            'images/person_black.svg',
                                          ],
                                          currentIndex: pageIndex,
                                        ),
                                      );
                                    } else if (state
                                        is BottomNavbarSuccessState) {
                                      pageIndex = state.indexValue;
                                      return Container(
                                        height: 60,
                                        child: BottomNavBar(
                                          isParent: true,
                                          bottomNavBarIconNames: [
                                            'images/person_black.svg',
                                            chatIconString,
                                            'images/person_black.svg',
                                          ],
                                          currentIndex: pageIndex,
                                        ),
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              );
                            });
                      }),
                    ],
                  );
  }

  Widget _getLoadingIndicator() {
    return Center(
      child: Container(height: 38, width: 50, child: CustomCircularIndicator()),
    );
  }

  Widget _getErrorLabel() {
    return Center(
      child: Text(
        'Something went wrong. \nTry again later !',
        textAlign: TextAlign.center,
        style: kalamTextStyle.copyWith(color: white, fontSize: 28),
      ),
    );
  }
}
