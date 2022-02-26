import 'package:intl/intl.dart';

class DateTimeUtils {
  static List<String> shortMonthList = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  static bool isSameDate(DateTime first, DateTime second) {
    return first.day == second.day &&
        first.month == second.month &&
        first.year == second.year;
  }

  static DateTime getDateFromString(String date) {
    //2021-11-18 18:30:00.000
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    return inputDate;
  }

  static String getMonthAndDate(DateTime date) {
    return "${shortMonthList.elementAt(date.month - 1)} ${date.day}";
  }

  static String getTime(DateTime date) {
    String formattedDate = DateFormat('kk:mm a').format(date);
    return formattedDate;
  }
}
