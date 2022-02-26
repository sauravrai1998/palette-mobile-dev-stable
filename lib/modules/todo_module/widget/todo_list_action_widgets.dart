import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_components/notifications_bell_icon.dart';
import 'package:palette/modules/notifications_module/bloc/notifications_bloc.dart';
import 'package:palette/modules/notifications_module/screens/notification_list_screen.dart';
import 'package:palette/modules/notifications_module/services/notifications_repo.dart';
import 'package:palette/utils/konstants.dart';

import 'circular_todo_button.dart';

class TodoListActionWidget extends StatelessWidget {
  final bool isSearchSelected;
  final bool isCalendarViewSelected;
  final FocusNode searchFocusNode;
  final Function onSearchPressed;
  final Function onCalendarIconPressed;
  final Function onMenuIconPressed;
  final int? notificationCount;
  final void Function(int) onCounterCallBack;
  final void Function(FetchNotificationsSuccessState)
      onNotificationFetchSuccess;
  const TodoListActionWidget(
      {Key? key,
      required this.isSearchSelected,
      required this.onNotificationFetchSuccess,
      required this.onSearchPressed,
      required this.onMenuIconPressed,
      required this.notificationCount,
      required this.onCounterCallBack,
      required this.isCalendarViewSelected,
      required this.onCalendarIconPressed,
      required this.searchFocusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isSearchSelected,
      child: Row(
        children: [
          isCalendarViewSelected
              ? CircularTodoSearchButton(
                  onTap: () {
                    onSearchPressed();
                  },
                  icon: Icons.search,
                )
              : SizedBox(),
          SizedBox(width: 14),
          Container(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: isCalendarViewSelected ? kDarkGrayColor : pinkRed,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      onMenuIconPressed();
                    },
                    child: Material(
                      color: isCalendarViewSelected ? white : pinkRed,
                      borderRadius: BorderRadius.circular(50),
                      elevation: 0.0,
                      child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(Icons.menu_rounded,
                              size: 16.0,
                              color: isCalendarViewSelected
                                  ? kDarkGrayColor
                                  : white)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      onCalendarIconPressed();
                    },
                    child: Material(
                      color: isCalendarViewSelected
                          ? kDarkGrayColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      elevation: isCalendarViewSelected ? 0.0 : 3.0,
                      child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(Icons.calendar_today_outlined,
                              size: 14.0,
                              color: isCalendarViewSelected ? white : pinkRed)),
                    ),
                  ),
                ],
              )),
          SizedBox(width: 14),
        ],
      ),
    );
  }
}
