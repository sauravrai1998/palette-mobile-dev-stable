import 'package:flutter/material.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/utils/calendar_utils.dart';
import 'package:palette/utils/konstants.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar_format_button.dart';

class TodoCalendarWidget extends StatelessWidget {
  final bool isMonthAndYearViewSelected;
  final DateTime focusedDay;
  final RangeSelectionMode rangeSelectionMode;
  final CalendarFormat calendarFormat;
  final List<Todo> Function(DateTime)? eventLoader;
  final void Function(DateTime dateTime) updateFocusedDate;
  final void Function(CalendarFormat format) updateCalendarFormat;
  final void Function(bool value) updateIsMonthAndYearViewSelected;
  final void Function(PageController) onCalendarCreated;
  final void Function(DateTime, DateTime) onDaySelected;

  TodoCalendarWidget(
      {required this.isMonthAndYearViewSelected,
      required this.onDaySelected,
      required this.onCalendarCreated,
      required this.focusedDay,
      required this.rangeSelectionMode,
      required this.calendarFormat,
      required this.eventLoader,
      required this.updateFocusedDate,
      required this.updateCalendarFormat,
      required this.updateIsMonthAndYearViewSelected});
  @override
  Widget build(BuildContext context) {
    return isMonthAndYearViewSelected
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            width: double.infinity,
            decoration: BoxDecoration(
                color: kLightGrayColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 36.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...kYearsList
                          .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0),
                                child: GestureDetector(
                                  onTap: () {
                                    updateFocusedDate(
                                        DateTime(e, focusedDay.month, 1));
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        e.toString(),
                                        style: montserratSemiBoldTextStyle
                                            .copyWith(
                                                color: white, fontSize: 16.0),
                                      ),
                                      if (focusedDay.year == e)
                                        Container(
                                          height: 6,
                                          width: 6,
                                          decoration: BoxDecoration(
                                              color: white,
                                              borderRadius:
                                                  BorderRadius.circular(50.0)),
                                        )
                                    ],
                                  ),
                                ),
                              ))
                          .toList()
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 36.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...kMonthsList
                          .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0),
                                child: GestureDetector(
                                  onTap: () {
                                    updateFocusedDate(DateTime(focusedDay.year,
                                        kMonthsList.indexOf(e) + 1, 1));
                                  },
                                  child: Column(
                                    children: [
                                      Text(e.toString().toUpperCase(),
                                          style: montserratSemiBoldTextStyle
                                              .copyWith(
                                            color: white,
                                            fontSize: 18.0,
                                          )),
                                      if (kMonthsList[focusedDay.month - 1] ==
                                          e)
                                        Container(
                                          height: 6,
                                          width: 6,
                                          decoration: BoxDecoration(
                                              color: white,
                                              borderRadius:
                                                  BorderRadius.circular(50.0)),
                                        )
                                    ],
                                  ),
                                ),
                              ))
                          .toList()
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        updateIsMonthAndYearViewSelected(false);
                      },
                      child: Container(
                          margin: EdgeInsets.only(bottom: 6.0, right: 16.0),
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: kDarkGrayColor),
                          child: Text(
                            "DONE",
                            style: montserratSemiBoldTextStyle.copyWith(
                                color: defaultLight, fontSize: 14),
                          )),
                    ),
                  ],
                ),
              ],
            ))
        : Container(
            padding: EdgeInsets.only(bottom: 14.0),
            width: double.infinity,
            decoration: BoxDecoration(
                color: kLightGrayColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                      .map((e) => Expanded(
                          child: Center(
                              child: Text(e,
                                  style: TextStyle(
                                      color: white,
                                      fontFamily: "MontserratBold",
                                      fontWeight: FontWeight.w700)))))
                      .toList(),
                ),
                SizedBox(
                  height: 10,
                ),
                TableCalendar<Todo>(
                  sixWeekMonthsEnforced: true,
                  headerVisible: false,
                  daysOfWeekVisible: false,
                  pageAnimationEnabled: true,
                  rowHeight: 40.0,
                  currentDay: DateTime.now(),
                  availableGestures: AvailableGestures.horizontalSwipe,
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) => isSameDay(focusedDay, day),
                  calendarFormat: calendarFormat,
                  rangeSelectionMode: rangeSelectionMode,
                  eventLoader: eventLoader,
                  formatAnimationCurve: Curves.decelerate,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle:
                        kalamLight.copyWith(color: white, fontSize: 14),
                    weekendStyle:
                        kalamLight.copyWith(color: white, fontSize: 14),
                  ),
                  onDaySelected: onDaySelected,

                  calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: defaultPurple,
                      ),
                      todayTextStyle: kalamLight.copyWith(
                          fontFamily: "Pacifico", color: white, fontSize: 16),
                      selectedTextStyle: kalamLight.copyWith(
                          fontFamily: "Pacifico", color: white, fontSize: 16),
                      selectedDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: defaultLight.withOpacity(0.6),
                      ),
                      cellPadding: EdgeInsets.all(0.0),
                      outsideTextStyle: kalamLight.copyWith(
                          fontFamily: "Pacifico",
                          color: white.withOpacity(0.6),
                          fontSize: 16),
                      weekendTextStyle: kalamLight.copyWith(
                          fontFamily: "Pacifico", color: white, fontSize: 16),
                      defaultTextStyle: kalamLight.copyWith(
                          fontFamily: "Pacifico", color: white, fontSize: 16),
                      markersMaxCount: 1,
                      markerDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0)),
                      canMarkersOverflow: false,
                      markersAnchor: 1.6,
                      markerSize: 5.3,
                      cellMargin: EdgeInsets.all(0.0)),
                  onFormatChanged: (format) {
                    if (calendarFormat != format) {
                      updateCalendarFormat(format);
                    }
                  },
                  onCalendarCreated: onCalendarCreated,
                  // onCalendarCreated: (pgController) {
                  //   _calendarPageController = pgController;
                  // },
                  onPageChanged: (focusedDay) {
                    updateFocusedDate(focusedDay);
                  },
                ),
                Container(
                  padding: const EdgeInsets.only(top: 4.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CalendarFormatButton(
                          isSelected: calendarFormat == CalendarFormat.month,
                          title: "MONTHLY",
                          onTap: () {
                            updateCalendarFormat(CalendarFormat.month);
                          }),
                      SizedBox(width: 10.0),
                      CalendarFormatButton(
                          isSelected: calendarFormat == CalendarFormat.week,
                          title: "WEEKLY",
                          onTap: () {
                            updateCalendarFormat(CalendarFormat.week);
                          }),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
