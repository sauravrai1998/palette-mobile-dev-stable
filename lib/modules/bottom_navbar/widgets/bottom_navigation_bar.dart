import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/modules/auth_module/services/notification_repository.dart';
import 'package:palette/modules/bottom_navbar/bloc/bottom_navbar_bloc.dart';
import 'package:palette/modules/bottom_navbar/bloc/bottom_navbar_events.dart';
import 'package:palette/modules/bottom_navbar/change_index_bloc/navbar_change_index_bloc.dart';
import 'package:palette/modules/todo_module/bloc/hide_bottom_navbar_bloc/hide_bottom_navbar_bloc.dart';
import 'package:palette/modules/todo_module/services/todo_repo.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

import '../../todo_module/screens/todo_list_screen.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final List<String> bottomNavBarIconNames;
  final bool isParent;

  BottomNavBar({
    this.currentIndex = 0,
    required this.bottomNavBarIconNames,
    this.isParent = false,
  });
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  List<Widget> displayItems = [];
  double navbarHeight = 60;

  @override
  void initState() {
    super.initState();
    _page = widget.currentIndex;
    _subscribeForNotifications();
  }

  _subscribeForNotifications() {
    final globalChatNotifData = NotificationRepo.instance.globalChatNotifData;
    final globalTodoNotifData = TodoRepo.instance.globalTodoNotifData;
    if (globalChatNotifData != null) {
      NotificationRepo.instance.globalChatNotifData = null;
      Helper.navigateToChatScreenDueToNotifWith(
        notifData: globalChatNotifData,
        context: context,
      );
    }

    if (globalTodoNotifData != null) {
      TodoRepo.instance.globalTodoNotifData = null;
      Helper.navigateToTodoScreenDueToNotifWith(
        todoData: globalTodoNotifData,
        context: context,
      );
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Get any messages which caused the application to open from
      // background state.
      print('app started from background message?.data: ${message.data}');

      FlutterAppBadger.updateBadgeCount(0);
      badgeCounter = 0;
      if (message.data.containsKey('type') && message.data['type'] == 'todo') {
        Helper.navigateToTodoScreenDueToNotifWith(
            todoData: message.data, context: context);
      } else {
        Helper.navigateToChatScreenDueToNotifWith(
          notifData: message.data,
          context: context,
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      badgeCounter = 0;
      FlutterAppBadger.updateBadgeCount(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    displayItems = widget.bottomNavBarIconNames.map((element) {
      var index = widget.bottomNavBarIconNames.indexOf(element);
      return Semantics(
        label: widget.isParent
            ? index == 0
                ? "Dashboard section"
                : index == 1
                    ? "Recommendation section"
                    : "Explore section"
            : index == 0
                ? "Todo section"
                : index == 1
                    ? "Recommendation section"
                    : "Explore section",
        child: widget.bottomNavBarIconNames[index] !=
                    'images/unread_chat_icon_nav_bar.svg' &&
                widget.bottomNavBarIconNames[index] !=
                    'images/unread_enabled_chat_icon_nav_bar.svg'
            ? SvgPicture.asset(
                widget.bottomNavBarIconNames[index],
                color: widget.currentIndex == index ? pureblack : defaultLight,
              )
            : SvgPicture.asset(widget.bottomNavBarIconNames[index]),
      );
    }).toList();

    return BlocBuilder<HideNavbarBloc, HideNavbarState>(
        builder: (context, state) {
      if (state is HideBottomNavbarState) {
        navbarHeight = 0;
      }
      if (state is ShowBottomNavbarState) {
        navbarHeight = 60;
      }

      return BlocListener(
        bloc: context.read<NavBarChangeIndexBloc>(),
        listener: (context, state) {
          if (state is NavBarChangeIndexState) {
            setState(() {
              _page = state.index;
              final bloc = context.read<BottomNavbarBloc>();
              bloc.add(GetBottomNavbarIndexValue(
                indexValue: state.index,
              ));
            });
          }
        },
        child: CurvedNavigationBar(
          key: _bottomNavigationKey,
          items: displayItems,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Colors.transparent,
          color: pureblack,
          height: navbarHeight,
          index: _page,
          onTap: (index) {
            setState(() {
              if (index == (widget.bottomNavBarIconNames.length - 1)) {
                print('tapp');
                return;
              } else {
                _page = index;
                final bloc = context.read<BottomNavbarBloc>();
                bloc.add(GetBottomNavbarIndexValue(
                  indexValue: index,
                ));
              }
            });
          },
        ),
      );
    });
  }
}
